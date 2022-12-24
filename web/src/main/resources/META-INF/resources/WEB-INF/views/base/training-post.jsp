<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var TrainingPost_PostList_TrainingPost_Jsp = null;
    var naTrainingPost_TrainingPost_Jsp = null;
    var PersonnelTrainingPost_TrainingPost_Jsp = null;
    var PostTrainingPost_TrainingPost_Jsp = null;
    var refresh_TrainingPost = true;
    var trainingPostsSelection=false;
    let LoadAttachments_Training_Post = null;
    var peopleTypeMap ={
        "Personal" : "شرکتی",
        "ContractorPersonal" : "پیمان کار",
        // "Company" : "شرکتی",
        // "OrgCostCenter" : "پیمان کار"
    };
    let TrainingPostDS_Url = viewTrainingPostUrl + "/training-post/iscList";


    let PostDS_TrainingPost = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap, filterOnKeypress: true},
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
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}

        ],
        fetchDataURL: viewPostUrl + "/iscList"
    });

    var Menu_PostLG_TrainingPost_Jsp = isc.Menu.create({
        width: 150,
        data: [{
            title: "افزودن پست", icon: "<spring:url value="refresh.png"/>",
            click: function () {
                if (ListGrid_TrainingPost_Jsp.getSelectedRecord() !== null || ListGrid_TrainingPost_Jsp.getSelectedRecord() !== undefined) {
                    let ids = [];
                    ids.add(PostLG_TrainingPost.getSelectedRecord().id);
                    addPosts(ids, PostLG_TrainingPost, ListGrid_TrainingPost_Jsp, ListGrid_ForThisTrainingPost_GetPosts);
                }
            }
        }
        ]
    });

    let PostLG_TrainingPost = isc.TrLG.create({
        dataSource: PostDS_TrainingPost,
        // contextMenu: Menu_PostLG_TrainingPost_Jsp,
        autoFetchData: true,
        sortField: 1,
        fields: [
            {name: "peopleType",
                filterOnKeypress: true,
            },
            {
                name: "code",
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
            {
                name: "costCenterCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "costCenterTitleFa"},
            {name: "competenceCount"},
            {name: "personnelCount"},
            {
                name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            }
        ],
        // doubleClick: function () {
        //     if (ListGrid_TrainingPost_Jsp.getSelectedRecord() !== null || ListGrid_TrainingPost_Jsp.getSelectedRecord() !== undefined) {
        //         let ids = [];
        //         ids.add(PostLG_TrainingPost.getSelectedRecord().id);
        //         addPosts(ids, PostLG_TrainingPost, ListGrid_TrainingPost_Jsp, ListGrid_ForThisTrainingPost_GetPosts);
        //     }
        // }
    });

    let window_unGroupedPosts_TrainingPost = isc.Window.create({
        minWidth: 1024,
        autoCenter: true,
        showMaximizeButton: false,
        autoSize: false,
        keepInParentRect: true,
        isModal: false,
        placement: "fillScreen",
        items: [PostLG_TrainingPost],
    });

    var RestDataSource_TrainingPost_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "departmentId", title: "departmentId", primaryKey: true, canEdit: false, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap,filterOnKeypress: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, hidden: true},
            {name: "mojtameTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "توضیحات", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {
                name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
            {name: "version", title: "version", canEdit: false, hidden: true},
            {name: "hasPermission", title: "hasPermission", canEdit: false, hidden: true}
        ],
        transformRequest: function (dsRequest) {
            // if (postAdmin !== undefined && postAdmin != null) {
                // if (postAdmin === "true") {
                    this.fetchDataURL = viewTrainingPostUrl + "/training-post/iscList";
                // } else {
                //     this.fetchDataURL = viewTrainingPostUrl + "/rolePostIscList";
                // }
            // }
            transformCriteriaForLastModifiedDateNA(dsRequest);
            return this.Super("transformRequest", arguments);
        },
        // fetchDataURL: TrainingPostDS_Url
    });
    var Menu_ListGrid_TrainingPost_Jsp = isc.Menu.create({
        width: 150,
        data: [
            <sec:authorize access="hasAuthority('Training_Post_R')">
            {
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                    ListGrid_TrainingPost_refresh();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Training_Post_C')">
            {
                title: " ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                    ListGrid_TrainingPost_add();
                    }
            },
            </sec:authorize>

<%--            <sec:authorize access="hasAuthority('Training_Post_U')">--%>
//             {
<%--                title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {--%>
//                     ListGrid_TrainingPost_edit();
//                 }
//             },
<%--            </sec:authorize>--%>

<%--            <sec:authorize access="hasAuthority('Training_Post_D')">--%>
<%--            {--%>
<%--                title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {--%>
<%--                    ListGrid_TrainingPost_remove();--%>
<%--                }--%>
<%--            },--%>
<%--            </sec:authorize>--%>

            {isSeparator: true},

            <sec:authorize access="hasAuthority('Training_Post_R')">
            {
                title: "لیست پست های انفرادی دسته بندی شده", icon: "<spring:url value="post.png"/>", click: function () {
                    let record = ListGrid_TrainingPost_Jsp.getSelectedRecord();
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
                        trainingPostsSelection=true;
                        RestDataSource_ForThisTrainingPost_GetPosts.fetchDataURL = trainingPostUrl + "/" + record.id + "/getPosts";
                        ListGrid_ForThisTrainingPost_GetPosts.invalidateCache();
                        ListGrid_ForThisTrainingPost_GetPosts.fetchData();
                        DynamicForm_thisTrainingPostHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                        Window_Add_Post_to_TrainingPost.show();
                    }
                }
            },
            </sec:authorize>
            {isSeparator: true},
            <sec:authorize access="hasAuthority('remove.uncertainty.needAssessment.changes')">
            {
                title: "<spring:message code="remove.uncertainty.needAssessment.changes"/>",
                click: function () {
                    receive_trainingPost_response();
                }
            }
            </sec:authorize>

        ]
    });
    var ListGrid_TrainingPost_Jsp = isc.TrLG.create({
        color: "red",
        selectionType: "single",
        <sec:authorize access="hasAuthority('Training_Post_R')">
        dataSource: RestDataSource_TrainingPost_Jsp,
        </sec:authorize>
        contextMenu: Menu_ListGrid_TrainingPost_Jsp,
        canMultiSort: true,
        dataPageSize: 20,
        allowAdvancedCriteria: true,
        initialSort: [
            {property: "competenceCount", direction: "ascending"},
            {property: "id", direction: "descending"}
        ],
        autoFetchData: true,
        selectionUpdated: function() {
            TrainingPost_PostList_TrainingPost_Jsp = null;
            selectionUpdated_TrainingPost_Jsp();
        },
        doubleClick: function () {
            // ListGrid_TrainingPost_edit();
        },
        getCellCSSText: function (record) {
            return setColorForListGrid(record);
        },
    });



    var method = "POST";
    var Menu_ListGrid_Post_Group_Posts = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                objectIdAttachment=null
                LoadAttachments_Training_Post.ListGrid_JspAttachment.setData([]);
                ListGrid_TrainingPost_Posts_refresh();
            }
        }, {
            title: " حذف پست انفرادی از پست مربوطه", icon: "<spring:url value="remove.png"/>", click: function () {
                activePostGroup = ListGrid_TrainingPost_Jsp.getSelectedRecord();
                activePost = ListGrid_TrainingPost_Posts.getSelectedRecord();
                if (activePostGroup == null || activePost == null) {
                    simpleDialog("پیام", "پست یا پست انفرادی انتخاب نشده است.", 0, "confirm");

                } else {
                    var Dialog_Delete = isc.Dialog.create({
                        message: getFormulaMessage("آیا از حذف  پست انفرادی:' ", "2", "black", "c") + getFormulaMessage(activePost.titleFa, "3", "red", "U") + getFormulaMessage(" از پست:' ", "2", "black", "c") + getFormulaMessage(activePostGroup.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه پست:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                        icon: "[SKIN]ask.png",
                        title: "تائید حذف",
                        buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                            title: "خیر"
                        })],
                        buttonClick: function (button, index) {
                            this.close();

                            if (index == 0) {
                                deletePostFromTrainingPost(activePost.id, activePostGroup.id, ListGrid_TrainingPost_Posts);
                            }
                        }
                    });

                }
            }
        },

        ]
    });

    var RestDataSource_TrainingPost_Posts_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap},
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
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}

        ],
        fetchDataURL: postUrl + "/iscList"
    });
    var RestDataSource_All_Posts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both", valueMap:peopleTypeMap},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}
        ]
        // , fetchDataURL: postUrl + "/iscList"
    });

    var RestDataSource_All_Posts_Clone = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both", valueMap:peopleTypeMap},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}
        ]
        // , fetchDataURL: postUrl + "/iscList"
    });

    var RestDataSource_ForThisTrainingPost_GetPosts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both", valueMap:peopleTypeMap},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}
        ]
    });

    var RestDataSource_Job_JspTrainingPost = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "<spring:message code="job.title"/>"},
            {name: "code", title: "<spring:message code="job.code"/>"},
            {name: "peopleType", title: "<spring:message code="people.type"/>",  valueMap:peopleTypeMap},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}
        ],
        fetchDataURL: jobUrl + "/iscList"
    });

    var RestDataSource_Department_JspTrainingPost = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="cost.center.title"/>", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "code", title: "<spring:message code="cost.center.code"/>", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "hozeTitle", title: "<spring:message code="area"/>", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "moavenatTitle", title: "<spring:message code="assistance"/>", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "omorTitle", title: "<spring:message code="affairs"/>", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ghesmatCode", title: "<spring:message code="section"/>", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "vahedTitle", title: "<spring:message code="unit"/>", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "type", title: "<spring:message code="people.type"/>", autoFitWidth: true, autoFitWidthApproach: "both",
                valueMap:{
                    "Company" : "شرکتی",
                    "OrgCostCenter" : "پیمان کار"
                }
            },
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}
        ],
        fetchDataURL: departmentUrl + "/iscList"
    });

    var RestDataSource_PostGradeLvl_PCNR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="post.grade.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                hidden: true
            },
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "peopleType", title: "<spring:message code="people.type"/>",  valueMap:peopleTypeMap},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}
        ],
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });

    var DynamicForm_thisTrainingPostHeader_Jsp = isc.DynamicForm.create({
        height: "5%",
        align: "center",
        fields: [{name: "sgTitle", type: "staticText", title: "افزودن پست به گروه پست ", wrapTitle: false}]
    });

    Lable_AllPosts = isc.LgLabel.create({contents:"لیست تمامی پست ها", customEdges: ["R","L","T", "B"]});
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
            {name: "peopleType",
                filterOnKeypress: true,
            },
            {name: "code", filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }},
            {name: "titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode"},
            {name: "costCenterTitleFa"},
            {
                name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true
            },
            {name: "OnAdd", title: " ", canSort:false, canFilter:false, width:30},
        ],
        dataArrived:function(startRow, endRow){
            let lgIds = ListGrid_ForThisTrainingPost_GetPosts.data.getAllCachedRows().map(function(item) {
                return item.id;
            });

            let findRows=ListGrid_AllPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:lgIds}]});
            ListGrid_AllPosts.setSelectedState(findRows);
            findRows.setProperty("enabled", false);
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName == "OnAdd") {
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
                        let selected=ListGrid_ForThisTrainingPost_GetPosts.data.getAllCachedRows().map(function(item) {return item.id;});

                        let ids = [];

                        if ($.inArray(current.id, selected) === -1){
                            ids.push(current.id);
                        }

                        if(ids.length!=0){
                            addPosts(ids, ListGrid_AllPosts, ListGrid_TrainingPost_Jsp, ListGrid_ForThisTrainingPost_GetPosts);
                        }
                    }
                });
                recordCanvas.addMember(addIcon);
                return recordCanvas;
            } else
                return null;
        }
    });

    Lable_ForThisTrainingPost_GetPosts = isc.LgLabel.create({contents:"لیست پست های انفرادی این پست", customEdges: ["R","L","T", "B"]});
    var ListGrid_ForThisTrainingPost_GetPosts = isc.TrLG.create({
        height: "45%",
        dataSource: RestDataSource_ForThisTrainingPost_GetPosts,
        // selectionAppearance: "checkbox",
        // selectionType: "simple",
        sortField: 0,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [Lable_ForThisTrainingPost_GetPosts, "filterEditor", "header", "body"],
        fields: [
            {name: "id", hidden:true},
            {name: "peopleType",
                filterOnKeypress: true,
            },
            {name: "code", filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }},
            {name: "titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode"},
            {name: "costCenterTitleFa"},
            {
                name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true
            },
            {name: "OnDelete", title: " ", canSort:false, canFilter:false, width:30}
        ],
        dataArrived:function(){
            if(trainingPostsSelection) {
                nullPostsRefresh(RestDataSource_All_Posts, ListGrid_AllPosts);
                trainingPostsSelection=false;
                refresh_TrainingPost = true;
            }
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName == "OnDelete") {
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
                        var active = record;
                        var activeId = active.id;
                        var activeGroup = ListGrid_TrainingPost_Jsp.getSelectedRecord();
                        var activeGroupId = activeGroup.id;
                        deletePostFromTrainingPost(activeId, activeGroupId, ListGrid_ForThisTrainingPost_GetPosts);
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        }
    });

    let addSelections = isc.ToolStripButtonAdd.create({
        height:25,
        title:"اضافه کردن گروهی",
        click: function () {
            let result = hasTrainingPostSelected();
            if(!result){
                let ids = ListGrid_AllPosts_Clone.getSelection().filter(function(x){return x.enabled!=false}).map(function(item) {return item.id;});
                if(ids.length > 0){
                    let dialog = createDialog('ask', "<spring:message code="msg.record.adds.ask"/>");
                    dialog.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index == 0) {
                                addPosts(ids, ListGrid_AllPosts_Clone, ListGrid_TrainingPost_Jsp, ListGrid_ForThisTrainingPost_GetPosts);
                            }
                        }
                    });
                }
            }
        }
    });

    Lable_NullPosts = isc.LgLabel.create({contents:"لیست پست های انفرادی دسته بندی نشده", customEdges: ["R","L","T", "B"]});

    var ListGrid_AllPosts_Clone = isc.TrLG.create({
        height: "45%",
        dataSource: RestDataSource_All_Posts_Clone,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        sortField: 1,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [
            Lable_NullPosts,
            addSelections,
            "filterEditor", "header", "body"],
        fields: [
            {name: "peopleType",
                filterOnKeypress: true,
            },
            {name: "code", filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }},
            {name: "titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode"},
            {name: "costCenterTitleFa"},
            {
                name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true
            },
            {name: "OnAdd", title: " ", canSort:false, canFilter:false, width:30}
        ],
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName == "OnAdd") {
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
                        let result = hasTrainingPostSelected();
                        if(!result){
                            let current = record;
                            let ids = [];
                            ids.push(current.id);
                            if(ids.length!=0){
                                addPosts(ids, ListGrid_AllPosts_Clone, ListGrid_TrainingPost_Jsp, ListGrid_ForThisTrainingPost_GetPosts);
                            }
                        }
                    }
                });
                recordCanvas.addMember(addIcon);
                return recordCanvas;
            } else
                return null;
        }
    });

    var VLayOut_TrainingPost_Posts_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        border: "3px solid gray",
        layoutMargin: 5,
        members: [
            DynamicForm_thisTrainingPostHeader_Jsp,
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
                            if (index == 0) {
                                let ids = ListGrid_AllPosts.getSelection().filter(function(x){return x.enabled!=false}).map(function(item) {return item.id;});
                                addPosts(ids, ListGrid_AllPosts, ListGrid_TrainingPost_Jsp, ListGrid_ForThisTrainingPost_GetPosts);
                            }
                        }
                    })

                }
            }),
            isc.LayoutSpacer.create({ID: "spacer", height: "5%"}),
            ListGrid_ForThisTrainingPost_GetPosts,
            isc.ToolStripButtonRemove.create({
                width:"100%",
                height:25,
                title:"حذف گروهی",
                click: function () {
                    let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
                    dialog.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index == 0) {
                                var ids = ListGrid_ForThisTrainingPost_GetPosts.getSelection().map(function(item) {return item.id;});
                                var activeGroup = ListGrid_TrainingPost_Jsp.getSelectedRecord();
                                var activeGroupId = activeGroup.id;
                                let JSONObj = {"ids": ids};
                                isc.RPCManager.sendRequest({
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    actionURL: trainingPostUrl + "/removePosts/" + activeGroupId + "/" + ids,
                                    httpMethod: "DELETE",
                                    data: JSON.stringify(JSONObj),
                                    serverOutputAsString: false,
                                    callback: function (resp) {
                                        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                                            ListGrid_ForThisTrainingPost_GetPosts.invalidateCache();
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

    var Window_Add_Post_to_TrainingPost = isc.Window.create({
        title: "لیست پست ها",
        align: "center",
        placement: "fillScreen",
        minWidth: 1024,
        closeClick: function () {
            ListGrid_TrainingPost_Posts_refresh();
            nullPostsRefresh(RestDataSource_All_Posts_Clone, ListGrid_AllPosts_Clone);
            this.hide();
        },
        items: [
            VLayOut_TrainingPost_Posts_Jsp
        ]
    });

    let ToolStrip_TrainingPost_Grades_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_TrainingPost_Posts.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "trainingPostSet", operator: "equals", value: ListGrid_TrainingPost_Jsp.getSelectedRecord().id});

                    ExportToFile.downloadExcel(null, ListGrid_TrainingPost_Posts , "trainingPost_Post", 0, null, '',"لیست رده پستی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_TrainingPost = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_TrainingPost_Grades_Export2EXcel
        ]
    });

    var ListGrid_TrainingPost_Posts = isc.TrLG.create({
        dataSource: RestDataSource_TrainingPost_Posts_Jsp,
        contextMenu: Menu_ListGrid_Post_Group_Posts,
        autoFetchData: false,
        sortField: 1,
        gridComponents: [ActionsTS_TrainingPost, "header", "filterEditor", "body",],
        fields: [
            {name: "peopleType",
                filterOnKeypress: true,
            },
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
            {
                name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true
            }
        ],
        dataArrived: function () {
            TrainingPost_PostList_TrainingPost_Jsp = ListGrid_TrainingPost_Posts.data.localData;
        },
    });

    var DynamicForm_TrainingPost_Jsp = isc.DynamicForm.create({
        width: "700",
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
        colWidths: [150, "*"],
        margin: 10,
        padding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "عنوان پست",
                type: "text",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
                hint: "Persian/فارسی",
                showHintInField: true,
                length: "250",
                width: "*",
                height: "40",
                colSpan: 2,
            },
            {
                name: "code",
                title: "<spring:message code='code'/>",
                type: "text",
                required: true,
                requiredMessage: "<spring:message code="msg.field.is.required"/>",
                colSpan: 2,
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    }]
            },
            {
                name: "jobId",
                colSpan: 1,
                type: "ComboBoxItem",
                multiple: false,
                title: "<spring:message code="job"/>",
                autoFetchData: false,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Job_JspTrainingPost,
                displayField: "titleFa",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {name: "titleFa", filterOperator: "iContains"},
                    {name: "code", filterOperator: "iContains"},
                    {name: "peopleType", filterOperator: "iContains"},
                    {
                        name: "enabled",
                        valueMap:{
                            // undefined : "فعال",
                            74 : "غیر فعال"
                        },filterOnKeypress: true
                        // formatCellValue: function (value, record) {
                        //     let newVal = value == undefined ? "فعال" : "غیر فعال";
                        //     return newVal;
                        // }
                    }
                ],
                filterFields: ["titleFa", "code"],
            },
            {
                name: "departmentId",
                colSpan: 1,
                type: "ComboBoxItem",
                multiple: false,
                title: "<spring:message code="department"/>",
                autoFetchData: false,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Department_JspTrainingPost,
                displayField: "title",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "title", title: "<spring:message code="cost.center.title"/>"},
                    {name: "code", title: "<spring:message code="cost.center.code"/>"},
                    {name: "hozeTitle", title: "<spring:message code="area"/>"},
                    {name: "moavenatTitle", title: "<spring:message code="assistance"/>"},
                    {name: "omorTitle", title: "<spring:message code="affairs"/>"},
                    {name: "ghesmatCode", title: "<spring:message code="section"/>"},
                    {name: "vahedTitle", title: "<spring:message code="unit"/>"},
                    {name: "type", filterOperator: "iContains"},
                    {
                        name: "enabled",
                        valueMap:{
                            // undefined : "فعال",
                            74 : "غیر فعال"
                        },filterOnKeypress: true
                        // formatCellValue: function (value, record) {
                        //     let newVal = value == undefined ? "فعال" : "غیر فعال";
                        //     return newVal;
                        // }
                    }
                ],
                filterFields: ["title", "code","hozeTitle","moavenatTitle","omorTitle","ghesmatCode","vahedTitle"],
            },
            {
                name: "postGradeId",
                title:"<spring:message code='post.grade'/>",
                textAlign: "center",
                optionDataSource: RestDataSource_PostGradeLvl_PCNR,
                autoFetchData: false,
                type: "ComboBoxItem",
                valueField: "id",
                displayField: "titleFa",
                endRow: false,
                colSpan: 1,
                layoutStyle: "horizontal",
                hint: "",
                pickListFields: [
                    {name: "code"},
                    {name: "titleFa"},
                    {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals",width:150, valueMap:peopleTypeMap, filterOnKeypress: true},
                    {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
                ],
                filterFields: ["titleFa"],
                // pickListProperties: {
                //     sortField: 1,
                //     showFilterEditor: true},
                // textMatchStyle: "substring",
            },
            {
                width: 300,
                name: "peopleType",
                title: "نوع پرسنل",
                type: "radioGroup",
                colSpan: 1,
                valueMap: peopleTypeMap,
                textAlign: "center",
                // hint: "شرکتی/پیمان کار",
                required: true,
                vertical: false,
                fillHorizontalSpace: true,
                // showHintInField: true,
                // pickListProperties: {
                //     showFilterEditor: false
                // },
            },
            <%--{--%>
                <%--width: 300,--%>
                <%--ID: "enabled",--%>
                <%--name: "enabled",--%>
                <%--colSpan: 1,--%>
                <%--// rowSpan: 1,--%>
                <%--title: "<spring:message code="active.status"/>:",--%>
                <%--wrapTitle: true,--%>
                <%--type: "radioGroup",--%>
                <%--vertical: false,--%>
                <%--fillHorizontalSpace: true,--%>
                <%--defaultValue: "1",--%>
<%--// endRow:true,--%>
                <%--valueMap: {--%>
                    <%--74: "غیر فعال",--%>
                    <%--// null: "فعال",--%>
                <%--},--%>
            <%--},--%>
            {
                // width: 300,
                ID: "enabled",
                name: "enabled",
                // colSpan: 1,
                type: "checkbox",
                // title: "<spring:message code="active.status"/>:",
                // titleOrientation: "top",
                labelAsTitle: true,
                title : "غیر فعال"
                // defaultValue: true
            },
        ]
    });

    var IButton_TrainingPost_Exit_Jsp = isc.IButtonCancel.create({
        top: 260, title: "لغو",
        //icon: "<spring:url value="remove.png"/>",
        align: "center",
        click: function () {
            Window_TrainingPost_Jsp.close();
        }
    });

    var IButton_TrainingPost_Save_Jsp = isc.IButtonSave.create({
        top: 260, title: "ذخیره",
        //icon: "pieces/16/save.png",
        align: "center", click: function () {

            DynamicForm_TrainingPost_Jsp.validate();
            if (DynamicForm_TrainingPost_Jsp.hasErrors()) {
                return;
            }
            var data = DynamicForm_TrainingPost_Jsp.getValues();

            data.enabled = data.enabled ? "74" : null;

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
                        ListGrid_TrainingPost_refresh();
                        Window_TrainingPost_Jsp.close();
                    }else if(resp.httpResponseCode == 409){
                        var ERROR = isc.Dialog.create({
                            message: (resp),
                            icon: "[SKIN]stop.png",
                            title: "پیغام"
                        });
                        setTimeout(function () {
                        ERROR.close();
                        }, 3000);
                    }else if(resp.httpResponseCode == 404){
                        var ERROR = isc.Dialog.create({
                            message: (resp),
                            icon: "[SKIN]stop.png",
                            title: "پیغام"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 3000);
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

    var HLayOut_TrainingPost_SaveOrExit_Jsp = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "700",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_TrainingPost_Save_Jsp, IButton_TrainingPost_Exit_Jsp]
    });

    var Window_TrainingPost_Jsp = isc.Window.create({
        title: "پست ",
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
            members: [DynamicForm_TrainingPost_Jsp, HLayOut_TrainingPost_SaveOrExit_Jsp]
        })]
    });

    ToolStripButton_unGroupedPosts_Jsp = isc.ToolStripButton.create({
        title: "پست های دسته بندی نشده",
        click: function () {
            loadPostData(PostLG_TrainingPost,
                {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "trainingPostSet", operator: "isNull"}]
            }, this.title);
        }
    });
    ToolStripButton_newPosts_Jsp = isc.ToolStripButton.create({
        title: "پست های جدید",
        click: function () {
            loadPostData(PostLG_TrainingPost,
                {
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
            if (ListGrid_TrainingPost_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            if (postAdmin==="true"  || (ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission!==undefined && ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission!==null && ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission===true)){
                Window_NeedsAssessment_Edit.showUs(ListGrid_TrainingPost_Jsp.getSelectedRecord(), "TrainingPost",false);
            }else {
                simpleDialog("پیغام", "شما دسترسی ویرایش نیازسنجی ندارید . در صورت نیاز , دسترسی به پست مربوطه را در نقش عملیاتی داده شود", 0, "say");

            }
        }
    });
    ToolStripButton_EditNA_JspGap = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی (گپ)",
        click: function () {
            if (ListGrid_TrainingPost_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            if (postAdmin==="true"  || (ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission!==undefined && ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission!==null && ListGrid_TrainingPost_Jsp.getSelectedRecord().hasPermission===true)){
                Window_NeedsAssessment_Edit_Gap.showUs(ListGrid_TrainingPost_Jsp.getSelectedRecord(), "TrainingPost",true);
            }else {
                simpleDialog("پیغام", "شما دسترسی ویرایش نیازسنجی ندارید . در صورت نیاز , دسترسی به پست مربوطه را در نقش عملیاتی داده شود", 0, "say");
            }
        }
    });

    ToolStripButton_NA_training_Post_all_competece_gap = isc.ToolStripButton.create({
        title: "نمای کلی  نیازسنجی بر اساس گپ شایستگی",
        click: function () {
            if (ListGrid_TrainingPost_Jsp.getSelectedRecord() == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_all_competence_gap.showUs(ListGrid_TrainingPost_Jsp.getSelectedRecord(), "TrainingPost",true);
        }
    });


    ToolStripButton_TreeNA_JspTrainingPost = isc.ToolStripButton.create({
        title: "درخت نیازسنجی",
        click: function () {
            if (ListGrid_TrainingPost_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Tree.showUs(ListGrid_TrainingPost_Jsp.getSelectedRecord(), "TrainingPost");
        }
    });


    ToolStrip_NA_TrainingPost_Jsp = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            // ToolStripButton_unGroupedPosts_Jsp,
            // ToolStripButton_newPosts_Jsp,
            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            ToolStripButton_EditNA_Jsp,
            </sec:authorize>

            <sec:authorize access="hasAuthority('NeedAssessment_T')">
            ToolStripButton_TreeNA_JspTrainingPost,
            </sec:authorize>
            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            ToolStripButton_EditNA_JspGap,
            </sec:authorize>
            <sec:authorize access="hasAuthority('NeedAssessment_U')">
            ToolStripButton_NA_training_Post_all_competece_gap,
            </sec:authorize>
        ]
    });

    var ToolStripButton_Refresh_TrainingPost_Jsp = isc.ToolStripButtonRefresh.create({
        // icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {
            objectIdAttachment=null
            LoadAttachments_Training_Post.ListGrid_JspAttachment.setData([]);
            ListGrid_TrainingPost_refresh();
        }
    });

    defineWindowsEditNeedsAssessment(ListGrid_TrainingPost_Jsp);
    defineWindowsEditNeedsAssessmentForGap(ListGrid_TrainingPost_Jsp);
    defineWindow_NeedsAssessment_all_competence_gap(ListGrid_TrainingPost_Jsp);
    defineWindowTreeNeedsAssessment();

    <sec:authorize access="hasAuthority('Training_Post_U')">
    var ToolStripButton_Edit_TrainingPost_Jsp = isc.ToolStripButtonEdit.create({

        title: "ویرایش",
        click: function () {

            // ListGrid_TrainingPost_edit();
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Training_Post_C')">
    var ToolStripButton_Add_TrainingPost_Jsp = isc.ToolStripButtonAdd.create({

        title: "ایجاد",
        click: function () {

            ListGrid_TrainingPost_add();
        }
    });
    </sec:authorize>

<%--    <sec:authorize access="hasAuthority('Training_Post_D')">--%>
<%--    var ToolStripButton_Remove_TrainingPost_Jsp = isc.ToolStripButtonRemove.create({--%>
<%--        // icon: "[SKIN]/actions/remove.png",--%>
<%--        title: "حذف",--%>
<%--        click: function () {--%>
<%--            ListGrid_TrainingPost_remove();--%>
<%--        }--%>
<%--    });--%>
<%--    </sec:authorize>--%>

    <sec:authorize access="hasAuthority('Training_Post_R')">
    var ToolStripButton_Add_TrainingPost_AddPost_Jsp = isc.ToolStripButton.create({
        title: "لیست پست ها",
        click: function () {
            let result = hasTrainingPostSelected();
            let record = ListGrid_TrainingPost_Jsp.getSelectedRecord();
             if(!result){
                trainingPostsSelection=true;
                RestDataSource_ForThisTrainingPost_GetPosts.fetchDataURL = trainingPostUrl + "/" + record.id + "/getPosts";
                ListGrid_ForThisTrainingPost_GetPosts.invalidateCache();
                ListGrid_ForThisTrainingPost_GetPosts.fetchData();
                DynamicForm_thisTrainingPostHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                Lable_ForThisTrainingPost_GetPosts.setContents("لیست پست های گروه پست " + getFormulaMessage(record.titleFa, "2", "red", "B"));
                Window_Add_Post_to_TrainingPost.show();


                //Window_Add_Post_to_TrainingPost.
                //   Window_Add_Post_to_TrainingPost.show();

            }
        }
    });
    </sec:authorize>

    let ToolStrip_TrainingPost_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_TrainingPost_Jsp.getCriteria();
                    ExportToFile.downloadExcel(null, ListGrid_TrainingPost_Jsp , "trainingPost", 0, null, '',"لیست پست - آموزش"  , criteria, null);
                }
            })
        ]
    });

    // var DynamicForm_AlarmSelection = isc.DynamicForm.create({
    //     width: "85%",
    //     height: "100%",
    //     fields: [
    //         {
    //
    //             name: "loadTypeSelect",
    //             title: "",
    //             type: "radioGroup",
    //             defaultValue: "1",
    //             valueMap: {
    //                 "1": "لیست تمامی پست ها",
    //                 "2": "لیست پست های عملیاتی",
    //             },
    //             vertical: false,
    //             changed: function (form, item, value) {
    //                 if (value === "1") {
    //                     objectIdAttachment=null
    //                     LoadAttachments_Training_Post.ListGrid_JspAttachment.setData([]);
    //                     TrainingPostDS_Url = viewTrainingPostUrl + "/iscList" ;
    //                     RestDataSource_TrainingPost_Jsp.fetchDataURL  = TrainingPostDS_Url ;
    //                     ListGrid_TrainingPost_refresh();
    //                 } else if(value === "2"){
    //                     objectIdAttachment=null
    //                     LoadAttachments_Training_Post.ListGrid_JspAttachment.setData([]);
    //                     TrainingPostDS_Url = viewTrainingPostUrl + "/rolePostIscList" ;
    //                     RestDataSource_TrainingPost_Jsp.fetchDataURL  = TrainingPostDS_Url ;
    //                     ListGrid_TrainingPost_Jsp.invalidateCache();
    //                 }
    //
    //             },
    //         }
    //     ]
    // });
        var ToolStrip_Actions_TrainingPost_Jsp = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Training_Post_C')">
            ToolStripButton_Add_TrainingPost_Jsp,
            </sec:authorize>

<%--            <sec:authorize access="hasAuthority('Training_Post_U')">--%>
//             ToolStripButton_Edit_TrainingPost_Jsp,
<%--            </sec:authorize>--%>

<%--            <sec:authorize access="hasAuthority('Training_Post_D')">--%>
//             ToolStripButton_Remove_TrainingPost_Jsp,
<%--            </sec:authorize>--%>

            <sec:authorize access="hasAuthority('Training_Post_R')">
            ToolStripButton_Add_TrainingPost_AddPost_Jsp,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Training_Post_P')">
            ToolStrip_TrainingPost_Export2EXcel,
            </sec:authorize>
            // DynamicForm_AlarmSelection,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('Training_Post_R')">
                    ToolStripButton_Refresh_TrainingPost_Jsp,
                    </sec:authorize>
                ]
            }),
        ]
    });

    var HLayout_Actions_TrainingPost_Jsp = isc.VLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_TrainingPost_Jsp, ToolStrip_NA_TrainingPost_Jsp]
    });

    Delete_Button_response_trainingPost = isc.Button.create({
        title: "حذف نیازسنجی فعلی"  ,
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            delete_uncertainly_assessment_trainingPost();
        }
    });
    Cancel_Button_Response_trainingPost = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_delete_uncertainly_needAssessment_trainingPost.close();
        }
    });
    HLayout_IButtons_Uncertainly_needAssessment_trainingPost = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Delete_Button_response_trainingPost,

            Cancel_Button_Response_trainingPost,

        ]
    });

    DynamicForm_Uncertainly_needAssessment_trainingPost= isc.DynamicForm.create({
        width: 600,
        height: 100,
        numCols: 2,
        fields: [
            {
                name: "createdBy",
                title: "ایجاد کننده :",
                canEdit: false,
                hidden: false
            },
            {
                name: "mainWorkStatus",
                title: "وضعیت نیازسنجی :",
                canEdit: false
            },

        ]

    });
    Window_delete_uncertainly_needAssessment_trainingPost = isc.Window.create({
        title: "حذف تغییرات نیازسنجی بلا تکلیف",
        width: 600,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [

            DynamicForm_Uncertainly_needAssessment_trainingPost,
            HLayout_IButtons_Uncertainly_needAssessment_trainingPost,

        ]

    });


    ////////////////////////////////////////////////////////////personnel/////////////////////////////////////////////////
    PersonnelDS_TrainingPost_Jsp = isc.TrDS.create({
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
            {name: "mobile",  title: "<spring:message code="mobile"/>", filterOperator: "iContains",autoFitWidth: true},
            {name: "email",  title: "<spring:message code="email"/>", filterOperator: "iContains",autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAssistant", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpSection", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: personnelUrl + "/iscList",
    });

    let ToolStrip_TrainingPost_Personnel_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PersonnelLG_TrainingPost_Jsp.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "trainingPostId", operator: "equals", value:ListGrid_TrainingPost_Jsp.getSelectedRecord().id});

                    ExportToFile.downloadExcel(null, PersonnelLG_TrainingPost_Jsp , "trainingPostPersonnel", 0, null, '',"لیست پرسنل - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Personnel_TrainingPost = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_TrainingPost_Personnel_Export2EXcel
        ]
    });

    PersonnelLG_TrainingPost_Jsp = isc.TrLG.create({
        dataSource: PersonnelDS_TrainingPost_Jsp,
        selectionType: "single",
        alternateRecordStyles: true,
        gridComponents: [ActionsTS_Personnel_TrainingPost, "header", "filterEditor", "body"],
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
            {name: "mobile"},
            {name: "email"},
            {name: "ccpArea"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpSection"},
            {name: "ccpUnit"},
        ]
    });

    ///////////////////////////////////////////////////////////needs assessment/////////////////////////////////////////
    PriorityDS_TrainingPost_Jsp = isc.TrDS.create({
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

    DomainDS_TrainingPost_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_TrainingPost_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    CourseDS_TrainingPost_Jsp = isc.TrDS.create({
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

    let ToolStrip_TrainingPost_NA_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {

                    let record = ListGrid_TrainingPost_Jsp.getSelectedRecord();
                    if (record == null)
                        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                    else {
                        let criteria = CourseLG_TrainingPost_Jsp.getCriteria();
                        if(typeof(criteria.operator)=='undefined'){
                            criteria._constructor="AdvancedCriteria";
                            criteria.operator="and";
                        }
                        if(typeof(criteria.criteria)=='undefined'){
                            criteria.criteria=[];
                        }
                        criteria.criteria.push({fieldName: "objectId", operator: "equals", value: ListGrid_TrainingPost_Jsp.getSelectedRecord().id});
                        criteria.criteria.push({fieldName: "objectType", operator: "equals", value: "PostGroup"});
                        criteria.criteria.push({fieldName: "personnelNo", operator: "equals", value: null});

                        ExportToFile.downloadExcel(null, CourseLG_TrainingPost_Jsp , "NeedsAssessment", 0, null, '',"لیست نیازسنجی پست - کدپست: " + record.code + " " + "عنوان پست: " + record.titleFa, criteria, null);
                    }
                }
            })
        ]
    });

    let ActionsTS_NA_TrainingPost = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_TrainingPost_NA_Export2EXcel
        ]
    });

    CourseLG_TrainingPost_Jsp = isc.TrLG.create({
        dataSource: CourseDS_TrainingPost_Jsp,
        selectionType: "none",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        gridComponents: [
            ActionsTS_NA_TrainingPost,
            "header", "filterEditor", "body",],
        fields: [
            {name: "competence.title"},
            {
                name: "competence.competenceTypeId",
                type: "SelectItem",
                filterOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: CompetenceTypeDS_TrainingPost_Jsp,
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
                optionDataSource: PriorityDS_TrainingPost_Jsp,
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
                optionDataSource: DomainDS_TrainingPost_Jsp,
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

    ////////////////////////////////////////////////////////////Tabs//////////////////////////////////////////////////////////////////////////////
    var Detail_Tab_TrainingPost = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {name: "TabPane_manage_TrainingPost_Jsp", title: "پست های انفرادی گروه بندی نشده", pane: ListGrid_AllPosts_Clone},
            {name: "TabPane_Post_TrainingPost_Jsp", title: "لیست پست های انفرادی دسته بندی شده", pane: ListGrid_TrainingPost_Posts},
            {name: "TabPane_Personnel_TrainingPost_Jsp", title: "لیست پرسنل", pane: PersonnelLG_TrainingPost_Jsp},
            {name: "TabPane_NA_TrainingPost_Jsp", title: "<spring:message code='need.assessment'/>", pane: CourseLG_TrainingPost_Jsp},
            {ID: "TrainingPost_AttachmentsTab",title: "<spring:message code="attachments"/>"},

        ],
        tabSelected: function (){
            selectionUpdated_TrainingPost_Jsp();
        }
    });

    //////////////////////////////////////////////////////////Form///////////////////////////////////////////////////////


    var HLayout_Tab_TrainingPost = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            <sec:authorize access="hasAuthority('Training_Post_R')">
            Detail_Tab_TrainingPost
            </sec:authorize>
        ]
    });

    var HLayout_Grid_TrainingPost_Jsp = isc.HLayout.create({
        width: "100%",
        height: "100%",
        showResizeBar: true,
        members: [ListGrid_TrainingPost_Jsp]
    });

    var VLayout_Body_TrainingPost_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_TrainingPost_Jsp
            , HLayout_Grid_TrainingPost_Jsp
            , HLayout_Tab_TrainingPost
        ]

    });


    ////////////////////////////////////////////////////////////Functions//////////////////////////////////////////////////////////////////////////////
    $(document).ready(function () {
        trainingPostsSelection = false;
        nullPostsRefresh(RestDataSource_All_Posts_Clone, ListGrid_AllPosts_Clone);
    });

    function ListGrid_TrainingPost_Posts_refresh() {
        // if (postAdmin !== undefined && postAdmin != null) {
        //     if (postAdmin === true) {
                RestDataSource_TrainingPost_Jsp.fetchDataURL  = viewTrainingPostUrl + "/training-post/iscList";
            // } else {
            //     RestDataSource_TrainingPost_Jsp.fetchDataURL = viewTrainingPostUrl + "/rolePostIscList";
            // }
        // }
        if (ListGrid_TrainingPost_Jsp.getSelectedRecord() == null)
            ListGrid_TrainingPost_Posts.setData([]);
        else
            ListGrid_TrainingPost_Posts.invalidateCache();
        CourseLG_TrainingPost_Jsp.setData([]);
        PersonnelLG_TrainingPost_Jsp.setData([]);
    }

    function ListGrid_TrainingPost_edit() {
        var record = ListGrid_TrainingPost_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {

            simpleDialog("پیغام", "گروه پستی انتخاب نشده است.", 0, "say");

        } else {
            if (postAdmin==="true"  || (record.hasPermission!==undefined && record.hasPermission!==null && record.hasPermission===true)){
                DynamicForm_TrainingPost_Jsp.clearValues();
                method = "PUT";
                url = trainingPostUrl + "/" + record.id;
                DynamicForm_TrainingPost_Jsp.editRecord(record);
                Window_TrainingPost_Jsp.show();
            }else {
                simpleDialog("پیغام", "شما دسترسی ویرایش ندارید . در صورت نیاز , دسترسی به پست مربوطه  در نقش عملیاتی داده شود", 0, "say");

            }

        }
    }

    function ListGrid_TrainingPost_remove() {
        var record = ListGrid_TrainingPost_Jsp.getSelectedRecord();
        if (record == null) {
            simpleDialog("پیغام", "گروه پستی انتخاب نشده است.", 0, "ask");
        } else {

            if (postAdmin==="true"  || (record.hasPermission!==undefined && record.hasPermission!==null && record.hasPermission===true)){
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
                            wait.show();
                            isc.RPCManager.sendRequest(TrDSRequest(trainingPostUrl + "/" + record.id, "DELETE", null, "callback: postGroup_delete_result(rpcResponse)"));
                        }
                    }
                });
            }else {
                simpleDialog("پیغام", "شما دسترسی حذف ندارید . در صورت نیاز , دسترسی به پست مربوطه  در نقش عملیاتی داده شود", 0, "say");

            }
        }
    }

    function postGroup_delete_result(resp) {
        wait.close();
        // console.log(resp)
        if (resp.httpResponseCode == 200) {
            ListGrid_TrainingPost_Jsp.invalidateCache();
            simpleDialog("انجام فرمان", "حذف با موفقیت انجام شد", 2000, "say");
            ListGrid_TrainingPost_Posts.setData([]);

        }
        else if (resp.httpResponseCode == 406) {
            simpleDialog("پیام خطا", "گروه پستی قادر به حذف نیست", 2000, "stop");
        } else {
            simpleDialog("پیام خطا", "حذف با خطا مواجه شد", 2000, "stop");

        }
    };

    function nullPostsRefresh(Ds, Lg){
        Ds.fetchDataURL = trainingPostUrl + "/getNullPosts";
        Lg.invalidateCache();
        Lg.fetchData();
    }

    function ListGrid_TrainingPost_refresh() {
        TrainingPost_PostList_TrainingPost_Jsp = null;
        naTrainingPost_TrainingPost_Jsp = null;
        PersonnelTrainingPost_TrainingPost_Jsp = null;
        PostTrainingPost_TrainingPost_Jsp = null;
        ListGrid_TrainingPost_Jsp.invalidateCache();

        nullPostsRefresh(RestDataSource_All_Posts_Clone, ListGrid_AllPosts_Clone);

        ListGrid_TrainingPost_Posts_refresh();
    }

    function ListGrid_TrainingPost_add() {
        method = "POST";
        url = trainingPostUrl;
        DynamicForm_TrainingPost_Jsp.clearValues();
        Window_TrainingPost_Jsp.show();
    }

    function deletePostFromTrainingPost(activeId, activeGroupId, listGrid) {

        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL:  trainingPostUrl + "/removePost/" + activeGroupId + "/" + activeId,
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                    listGrid.invalidateCache();

                    let findRows=ListGrid_AllPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:[activeId]}]});

                    if(typeof (findRows)!='undefined' && findRows.length>0){
                        findRows.setProperty("enabled", true);
                        ListGrid_AllPosts.deselectRecord(findRows[0]);
                    }

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
                trainingPostsSelection = true;
                listGrid.dataArrived();
            }
        });
    }

    function selectionUpdated_TrainingPost_Jsp() {
        let trainingPost = ListGrid_TrainingPost_Jsp.getSelectedRecord();
        let tab = Detail_Tab_TrainingPost.getSelectedTab();
        if (trainingPost == null && tab.pane != null && tab.name !== "TabPane_manage_TrainingPost_Jsp") {
            tab.pane.setData([]);
            return;
        }
        switch (tab.name || tab.ID) {
            case "TabPane_Post_TrainingPost_Jsp": {
                if (PostTrainingPost_TrainingPost_Jsp === trainingPost.id && !refresh_TrainingPost)
                    return;
                PostTrainingPost_TrainingPost_Jsp = trainingPost.id;
                ListGrid_TrainingPost_Posts.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "trainingPostSet", operator: "equals", value: trainingPost.id}]
                });
                ListGrid_TrainingPost_Posts.invalidateCache();
                ListGrid_TrainingPost_Posts.fetchData();
                refresh_TrainingPost = false;
                break;
            }
            case "TabPane_Personnel_TrainingPost_Jsp": {
                if (PersonnelTrainingPost_TrainingPost_Jsp === trainingPost.id)
                    return;
                PersonnelTrainingPost_TrainingPost_Jsp = trainingPost.id;
                PersonnelDS_TrainingPost_Jsp.fetchDataURL = trainingPostUrl + "/" + trainingPost.id + "/getPersonnel";
                PersonnelLG_TrainingPost_Jsp.invalidateCache();
                PersonnelLG_TrainingPost_Jsp.fetchData();
                break;
            }
            case "TabPane_NA_TrainingPost_Jsp": {
                if (naTrainingPost_TrainingPost_Jsp === trainingPost.id)
                    return;
                naTrainingPost_TrainingPost_Jsp = trainingPost.id;
                CourseDS_TrainingPost_Jsp.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + trainingPost.id + "&objectType=TrainingPost";
                CourseDS_TrainingPost_Jsp.invalidateCache();
                CourseDS_TrainingPost_Jsp.fetchData();
                CourseLG_TrainingPost_Jsp.invalidateCache();
                CourseLG_TrainingPost_Jsp.fetchData();
                break;
            }
            case "TabPane_manage_TrainingPost_Jsp": {
                if (trainingPostsSelection) {
                     nullPostsRefresh(RestDataSource_All_Posts_Clone, ListGrid_AllPosts_Clone);
                    trainingPostsSelection = false;
                }
                break;
            }
            case "TrainingPost_AttachmentsTab": {

                if (typeof LoadAttachments_Training_Post.loadPage_attachment_Job !== "undefined")
                    LoadAttachments_Training_Post.loadPage_attachment_Job("TrainingPost",trainingPost.id, "<spring:message code="attachment"/>", {
                        1: "جزوه",
                        2: "لیست نمرات",
                        3: "لیست حضور و غیاب",
                        4: "نامه غیبت موجه"
                    }, false);
                break;
            }
        }
    }

    function loadPostData(listGrid, criteria, title) {
        listGrid.setImplicitCriteria(criteria);
        listGrid.invalidateCache();
        listGrid.fetchData();
        window_unGroupedPosts_TrainingPost.setTitle(title);
        window_unGroupedPosts_TrainingPost.show();
    }

    function addPosts(ids, listGridAllPosts, listGridTrainingPost, listGridForThisTrainingPost) {
        var activeGroup = listGridTrainingPost.getSelectedRecord();
        var activeGroupId = activeGroup.id;
        let JSONObj = {"ids": ids};
        wait.show();
        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: trainingPostUrl + "/addPosts/" + activeGroupId + "/" + ids,
            httpMethod: "POST",
            data: JSON.stringify(JSONObj),
            serverOutputAsString: false,
            callback: function (resp) {
                wait.close();
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    listGridForThisTrainingPost.invalidateCache();

                    let findRows=listGridAllPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:ids}]});

                    if(typeof (findRows)!='undefined' && findRows.length>0){
                        findRows.setProperty("enabled", false);
                        listGridAllPosts.redraw();
                    }
                    refresh_TrainingPost = true;
                    isc.say("عملیات با موفقیت انجام شد.");
                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    }


    function hasTrainingPostSelected() {
        let result = false;
        let record = ListGrid_TrainingPost_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {
            result = true;
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "پیام",
                buttons: [isc.IButtonSave.create({title: "تائید"})],
                buttonClick: function () {
                    this.close();
                }
            });
        }
        return result;
    }

    if (!loadjs.isDefined('load_Attachments_Training_Post')) {
        loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments_Training_Post');
    }

    loadjs.ready('load_Attachments_Training_Post', function () {
        setTimeout(()=> {
            LoadAttachments_Training_Post = new loadAttachments();
            Detail_Tab_TrainingPost.updateTab(TrainingPost_AttachmentsTab, LoadAttachments_Training_Post.VLayout_Body_JspAttachment);
        },0);

    })
    function receive_trainingPost_response(){
        let record= ListGrid_TrainingPost_Jsp.getSelectedRecord();
        DynamicForm_Uncertainly_needAssessment_trainingPost.clearValues();
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/getNeedAssessmentTempByCode?code=" + record.code, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let detail = JSON.parse(resp.httpResponseText);
                DynamicForm_Uncertainly_needAssessment_trainingPost.setValues(detail);
                Window_delete_uncertainly_needAssessment_trainingPost.show();
            } else {
                createDialog("info", "<spring:message code="this.code.doesnt.have.needAssessment"/>", "<spring:message code="error"/>");
            }
        }));



    }
    function delete_uncertainly_assessment_trainingPost(){

        let record= ListGrid_TrainingPost_Jsp.getSelectedRecord();

        if (postAdmin==="true"  || (record.hasPermission!==undefined && record.hasPermission!==null && record.hasPermission===true)){
            DynamicForm_Uncertainly_needAssessment_trainingPost.clearValues();
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/removeConfirmation?code=" + record.code, "GET", null, function (resp) {
                wait.close();
                if (resp.httpResponseCode === 201 || resp.httpResponseCode===200)   {

                    Window_delete_uncertainly_needAssessment_trainingPost.close();
                    createDialog("info","عملیات حذف موفقیت آمیز بود")
                } else {
                    createDialog("info", "<spring:message code="delete.was.not.successful"/>", "<spring:message code="error"/>");
                }
            }));
        }else {
            simpleDialog("پیغام", "شما دسترسی ویرایش نیازسنجی ندارید . در صورت نیاز , دسترسی به پست مربوطه را در نقش عملیاتی داده شود", 0, "say");

        }

    }



    // </script>