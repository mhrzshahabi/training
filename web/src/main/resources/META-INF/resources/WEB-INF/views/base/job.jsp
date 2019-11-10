<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    JobMenu_job = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshJobLG_job();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    JobTS_job = isc.ToolStrip.create({
        members: [
            isc.TrRefreshBtn.create({
                click: function () {
                    refreshJobLG_job();
                }
            }),
            isc.TrPrintBtn.create({
                menu: isc.Menu.create({
                    data: [
                        {
                            title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                                printJobLG_job("pdf");
                            }
                        },
                        {title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>", click: function () {
                                printJobLG_job("excel");
                            }},
                        {title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>", click: function () {
                                printJobLG_job("html");
                            }},
                    ]
                })
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.Label.create({
                ID: "totalsLabel_job"
            }),
        ]
    })
    ;

    // ------------------------------------------- TabSet -------------------------------------------

    let JobTabs_job = isc.TabSet.create({
        tabs: [
            {
                title: "<spring:message code="job.group.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="post.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="need.assessment.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="competence.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="skill.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="course.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
            {
                title: "<spring:message code="class.plural.list"/>",
                pane: isc.TrVLayout.create({
                    members: []
                }),
            },
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    JobDS_job = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobUrl + "iscList"
    });

    JobLG_job = isc.TrLG.create({
        dataSource: JobDS_job,
        fields: [
            {name: "code",},
            {name: "titleFa",},
        ],
        autoFetchData: true,
        gridComponents: [JobTS_job, "filterEditor", "header", "body"],
        contextMenu: JobMenu_job,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_job.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_job.setContents("&nbsp;");
            }
        },
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [JobLG_job, isc.HLayout.create({members: [JobTabs_job]})],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshJobLG_job() {
        JobLG_job.filterByEditor();
    };

    function printJobLG_job(type) {
        alert(jobUrl + "print/" + type, "POST", null, "test");
        let criteria = JobLG_job.getCriteria();
        isc.RPCManager.sendRequest(TrDSRequest(jobUrl + "print/" + type, "POST", null, "test"));

        <%--isc.RPCManager.sendRequest(TrDSRequest(addressUrl + "getOneByPostalCode/" + postalCode, "GET", null,--%>
        <%--    "callback: homeAddress_findOne_result(rpcResponse)"));--%>

        <%--var advancedCriteria_course = ListGrid_Course.getCriteria();--%>
        <%--var criteriaForm_course = isc.DynamicForm.create({--%>
        <%--    method: "POST",--%>
        <%--    action: "<spring:url value="/course/printWithCriteria/"/>" + type,--%>
        <%--    target: "_Blank",--%>
        <%--    canSubmit: true,--%>
        <%--    fields:--%>
        <%--        [--%>
        <%--            {name: "CriteriaStr", type: "hidden"},--%>
        <%--            {name: "myToken", type: "hidden"}--%>
        <%--        ]--%>
        <%--})--%>
        <%--criteriaForm_course.setValue("CriteriaStr", JSON.stringify(advancedCriteria_course));--%>
        <%--criteriaForm_course.setValue("myToken", "<%=accessToken%>");--%>
        <%--criteriaForm_course.show();--%>
        <%--criteriaForm_course.submitForm();--%>
    };

    function test() {
        alert("done");
    }

    <%--function trPrintWithCriteria(url, advancedCriteria) {--%>
    <%--    let trCriteriaForm = isc.DynamicForm.create({--%>
    <%--        method: "POST",--%>
    <%--        action: url,--%>
    <%--        target: "_Blank",--%>
    <%--        canSubmit: true,--%>
    <%--        fields:--%>
    <%--            [--%>
    <%--                {name: "CriteriaStr", type: "hidden"},--%>
    <%--                {name: "token", type: "hidden"}--%>
    <%--            ]--%>
    <%--    });--%>
    <%--    trCriteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));--%>
    <%--    trCriteriaForm.setValue("token", "<%=accessToken%>");--%>
    <%--    trCriteriaForm.show();--%>
    <%--    trCriteriaForm.submitForm();--%>
<%--}--%>