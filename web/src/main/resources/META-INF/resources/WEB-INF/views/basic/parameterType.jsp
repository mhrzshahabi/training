<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    ParameterTypeMenu_parameterType = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refreshParameterTypeLG_parameterType();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    ParameterTypeTS_parameterType = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonPrint.create({
                menu: isc.Menu.create({
                    data: [
                        {
                            title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                                printParameterTypeLG_parameterType("pdf");
                            }
                        },
                        {
                            title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>", click: function () {
                                printParameterTypeLG_parameterType("excel");
                            }
                        },
                        {
                            title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>", click: function () {
                                printParameterTypeLG_parameterType("html");
                            }
                        },
                    ]
                })
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.Label.create({
                        ID: "totalsLabel_parameterType"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshParameterTypeLG_parameterType();
                        }
                    }),
                ]
            })
        ]
    })
    ;

    // ------------------------------------------- TabSet -------------------------------------------

    let ParameterTypeTabs_parameterType = isc.TabSet.create({
        tabs: [
            {
                title: "<spring:message code="parameterType.group.plural.list"/>",
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
    ParameterTypeDS_parameterType = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="parameterType.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="parameterType.title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterTypeUrl + "iscList"
    });

    ParameterTypeLG_parameterType = isc.TrLG.create({
        dataSource: ParameterTypeDS_parameterType,
        fields: [
            {name: "code",},
            {name: "titleFa",},
        ],
        autoFetchData: true,
        gridComponents: [ParameterTypeTS_parameterType, "filterEditor", "header", "body"],
        contextMenu: ParameterTypeMenu_parameterType,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_parameterType.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_parameterType.setContents("&nbsp;");
            }
        },
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
// members: [ParameterTypeLG_parameterType, isc.HLayout.create({members: [ParameterTypeTabs_parameterType]})],
        members: [ParameterTypeLG_parameterType],
    });


    // ------------------------------------------- Functions -------------------------------------------
    function refreshParameterTypeLG_parameterType() {
        ParameterTypeLG_parameterType.filterByEditor();
    }

    function printParameterTypeLG_parameterType(type) {
        isc.RPCManager.sendRequest(TrDSRequest(parameterTypeUrl + "print/pdf", "POST", null, "callback:test(rpcResponse)"));

// isc.RPCManager.sendRequest(TrDSRequest("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf", "POST", null, "callback:show_TermActionResult(rpcResponse)"));


// isc.RPCManager.sendRequest(TrDSRequest(termUrl + "checkForConflict/" + strsData + "/" + streData, "GET", null, "callback:conflictReq(rpcResponse)"));

// isc.RPCManager.sendRequest(TrDSRequest("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf", "POST", null, "test"));

// trPrintWithCriteria("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf", ParameterTypeLG_parameterType.getCriteria());
// trPrintWithCriteria(,
// ParameterTypeLG_parameterType.getCriteria());
// isc.RPCManager.sendRequest(TrDSRequest(parameterTypeUrl + "print/" + type, "GET", JSON.stringify({"CriteriaStr": ParameterTypeLG_parameterType.getCriteria()}), "test"));
    }

    function test(resp) {
// alert('hi');
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
