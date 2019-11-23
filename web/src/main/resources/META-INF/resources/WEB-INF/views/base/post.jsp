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
            isc.ToolStripButton.create({
                icon:"[SKIN]/RichTextEditor/print.png",
                title: "<spring:message code='print'/>",
                click:function () {
                    print_PostListGrid("PDF");
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
            <%--{name: "department.area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "department.assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "department.affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "department.section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "department.unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},--%>
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
            // {name: "department.area",},
            // {name: "department.assistance",},
            // {name: "department.affairs",},
            // {name: "department.section",},
            // {name: "department.unit",},
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
            <%--isc.HLayout.create({--%>
            <%--    height: "10%",--%>
            <%--    // defaultLayoutAlign: "center",--%>
            <%--    members: [--%>
            <%--        // postFilterForm_post,--%>
            <%--        isc.Button.create({--%>
            <%--            title: "<spring:message code="filter"/>",--%>
            <%--            click: function () {--%>
            <%--                postFilterForm_post.submit();--%>
            <%--            }--%>
            <%--        }),]--%>
            <%--}),--%>
            PostLG_post],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshPostLG_post() {
        PostLG_post.filterByEditor();
    };
    function print_PostListGrid(type) {
        var advancedCriteria_post = PostLG_post.getCriteria();
        var print_form_post = isc.DynamicForm.create({
            method:"POST",
            action: "<spring:url value="/post/print_list"/>"+type,
            target: "_Blank",
            canSubmit: true,
            fields:[
                {name:"CriteriaStr",type:"hidden"},
                {name:"myToken",type:"hidden"}
            ]
        })
        print_form_post.setValue("CriteriaStr",JSON.stringify(advancedCriteria_post));
        print_form_post.setValue("myToken","<%=accessToken%>");
        print_form_post.show();
        print_form_post.submitForm();
    };