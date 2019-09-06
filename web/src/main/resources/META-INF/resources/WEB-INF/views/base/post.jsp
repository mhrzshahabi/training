<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

//<script>

    // ------------------------------------------- Menu -------------------------------------------
    PostMenu_post = isc.TrMenu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshPostLG_post();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    PostTS_post = isc.TrTS.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refreshPostLG_post();
                }
            }),
        ]
    });



private String area;
private String assistance;
private String affairs;
private String section;
private String unit;
private String costCenterCode;
private String costCenterTitleFa;

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PostDS_post = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "contains"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "contains"},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "contains"},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "contains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "contains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "contains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "contains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "contains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "contains"},
        ],
        fetchDataURL: postUrl + "iscList"
    });

    PostLG_post = isc.TrLG.create({
        dataSource: PostDS_post,
        fields: [
            {name: "code",},
            {name: "titleFa",},
        ],
        autoFetchData: true,
        gridComponents: [PostTS_post, "header", "filterEditor", "body",],
        contextMenu: PostMenu_post,
        sortField: 0,
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [PostTS_post, PostLG_post],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPostLG_post() {
        PostLG_post.invalidateCache();
    }