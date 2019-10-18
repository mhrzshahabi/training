<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    PostMenu_post = isc.Menu.create({
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
    PostTS_post = isc.ToolStrip.create({
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
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PostDS_post = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "departmentArea", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "departmentAssistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "departmentAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "departmentSection", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "departmentUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
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
            {name: "departmentArea",},
            {name: "departmentAssistance",},
            {name: "departmentAffairs",},
            {name: "departmentSection",},
            {name: "departmentUnit",},
        ],
        autoFetchData: true,
        gridComponents: [PostTS_post, "filterEditor", "header", "body",],
        contextMenu: PostMenu_post,
        sortField: 0,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            var totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_post.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_post.setContents("&nbsp;");
            }
        }
    });

    // ------------------------------------------- DynamicForm -------------------------------------------
    isc.DynamicForm.create({
        ID: "postFilterForm_post",
        saveOnEnter: true,
        dataSource: PostDS_post,
        numCols: 2,
        submit: function () {
            PostLG_post.filterData(postFilterForm_post.getValuesAsCriteria());
        },
        fields: [
            {name: "departmentArea", title: "<spring:message code="area"/>", operator: "iContains",},
            {name: "departmentAssistance", title: "<spring:message code="assistance"/>", operator: "iContains",},
            {name: "departmentAffairs", title: "<spring:message code="affairs"/>", operator: "iContains",},
        ]
    })

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [
            isc.HLayout.create({
                height: "10%",
                // defaultLayoutAlign: "center",
                members: [
                    postFilterForm_post,
                    isc.Button.create({
                        title: "<spring:message code="filter"/>",
                        click: function () {
                            postFilterForm_post.submit();
                        }
                    }),]
            }),
            PostLG_post],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPostLG_post() {
        PostLG_post.filterByEditor();
    };