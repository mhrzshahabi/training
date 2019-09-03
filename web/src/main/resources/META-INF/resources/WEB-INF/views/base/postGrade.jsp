<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

//<script>

    // ------------------------------------------- Menu -------------------------------------------
    PostGradeMenu_postGrade = isc.TrMenu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshPostGradeLG_postGrade();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    PostGradeTS_postGrade = isc.TrTS.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refreshPostGradeLG_postGrade();
                }
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PostGradeDS_postGrade = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.grade.code"/>", filterOperator: "contains"},
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "contains"},
        ],
        fetchDataURL: postGradeUrl + "iscList"
    });

    PostGradeLG_postGrade = isc.TrLG.create({
        dataSource: PostGradeDS_postGrade,
        fields: [
            {name: "code",},
            {name: "titleFa",},
        ],
        autoFetchData: true,
        gridComponents: [PostGradeTS_postGrade, "header", "filterEditor", "body",],
        contextMenu: PostGradeMenu_postGrade,
        sortField: 0,
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [PostGradeTS_postGrade, PostGradeLG_postGrade],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPostGradeLG_postGrade() {
        PostGradeLG_postGrade.invalidateCache();
    }