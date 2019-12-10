<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    ParameterTypeMenu_parameter = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                click: function () {
                    refreshParameterTypeLG_parameter();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    ParameterTypeTS_parameter = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonPrint.create({
                click: function () {
                    printParameterTypeLG_parameter("pdf");
                },
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
                        ID: "totalsLabel_parameter"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshParameterTypeLG_parameter();
                        }
                    }),
                ]
            })
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    ParameterTypeDS_parameter = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterTypeUrl + "/iscList"
    });

    ParameterTypeLG_parameter = isc.TrLG.create({
        dataSource: ParameterTypeDS_parameter,
        fields: [
            {name: "code",},
            {name: "titleFa",},
        ],
        autoFetchData: true,
        gridComponents: [ParameterTypeTS_parameter, "filterEditor", "header", "body"],
        contextMenu: ParameterTypeMenu_parameter,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_parameter.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_parameter.setContents("&nbsp;");
            }
        },
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        // members: [ParameterTypeLG_parameter, isc.HLayout.create({members: [ParameterTypeTabs_parameter]})],
        members: [ParameterTypeLG_parameter],
    });


    // ------------------------------------------- Functions -------------------------------------------
    function refreshParameterTypeLG_parameter() {
        ParameterTypeLG_parameter.filterByEditor();
    }

    function printParameterTypeLG_parameter(type) {
        isc.RPCManager.sendRequest(TrDSRequest(parameterTypeUrl + "/print/pdf", "POST", null, "callback:test(rpcResponse)"));

        // isc.RPCManager.sendRequest(TrDSRequest("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf", "POST", null, "callback:show_TermActionResult(rpcResponse)"));


        // isc.RPCManager.sendRequest(TrDSRequest(termUrl + "checkForConflict/" + strsData + "/" + streData, "GET", null, "callback:conflictReq(rpcResponse)"));

        // isc.RPCManager.sendRequest(TrDSRequest("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf", "POST", null, "test"));

        // trPrintWithCriteria("<spring:url value="education/orientation/printWithCriteria/"/>" + "pdf", ParameterTypeLG_parameter.getCriteria());
        // trPrintWithCriteria(,
        // ParameterTypeLG_parameter.getCriteria());
        // isc.RPCManager.sendRequest(TrDSRequest(parameterTypeUrl + "/print/" + type, "GET", JSON.stringify({"CriteriaStr": ParameterTypeLG_parameter.getCriteria()}), "test"));
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
