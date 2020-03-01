<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    PostGradeMenu_postGrade = isc.Menu.create({
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
    PostGradeTS_postGrade = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.Label.create({
                ID: "totalsLabel_postGrade"
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshPostGradeLG_postGrade();
                        }
                    })
                ]
            })

        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PostGradeDS_postGrade = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="post.grade.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeUrl + "/iscList"
    });

    PostGradeLG_postGrade = isc.TrLG.create({
        dataSource: PostGradeDS_postGrade,
        fields: [
            {name: "code",},
            {name: "titleFa",},
        ],
        autoFetchData: true,
        gridComponents: [PostGradeTS_postGrade, "filterEditor", "header", "body",],
        contextMenu: PostGradeMenu_postGrade,
        sortField: 0,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_postGrade.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_postGrade.setContents("&nbsp;");
            }
        }
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [PostGradeTS_postGrade, PostGradeLG_postGrade],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPostGradeLG_postGrade() {
        PostGradeLG_postGrade.filterByEditor();
    };