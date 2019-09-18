<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

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
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                ID: "totalsLabel_post"
            }),
            isc.LayoutSpacer.create({
                width: 40
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PostDS_post = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "contains", autoFitWidth:true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "contains", autoFitWidth:true},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "contains", autoFitWidth:true},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "contains", autoFitWidth:true},
            {name: "department.area", title: "<spring:message code="area"/>", filterOperator: "contains", autoFitWidth:true},
            {name: "department.assistance", title: "<spring:message code="assistance"/>", filterOperator: "contains", autoFitWidth:true},
            {name: "department.affairs", title: "<spring:message code="affairs"/>", filterOperator: "contains"},
        ],
        fetchDataURL: postUrl + "iscList"
    });

    PostLG_post = isc.TrLG.create({
        dataSource: PostDS_post,
        fields: [
            {name: "code",},
            {name: "titleFa",},
            {name: "job.titleFa",},
            {name: "postGrade.titleFa",},
            {name: "department.area",},
            {name: "department.assistance",},
            {name: "department.affairs",},
        ],
        autoFetchData: true,
        gridComponents: [PostTS_post, "header", "filterEditor", "body",],
        contextMenu: PostMenu_post,
        sortField: 0,
        dataChanged : function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows > 0 && this.data.lengthIsKnown()) {
                totalsLabel_post.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_post.setContents("&nbsp;");
            }
        }
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [PostTS_post, PostLG_post],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPostLG_post() {
        PostLG_post.invalidateCache();
    };