<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let method_PCTQ = "GET";
    let saveActionUrl_PCTQ;
    let wait_PCTQ;
    let classId_PCTQ = null;

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    questionsDS_PCTQ = isc.TrDS.create({
        fields: [
            {name: "preCourseTestQuestions", filterOperator: "iContains"}
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    questionsDF_PCTQ = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {
                name: "preCourseTestQuestions",
                title: "<spring:message code='question'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            }
        ]
    });

    IButton_Save_PCTQ = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            if (!questionsDF_PCTQ.valuesHaveChanged())
                return;
            wait_PCTQ = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrl_PCTQ,
                method_PCTQ,
                JSON.stringify(questionsDF_PCTQ.getValues()),
                questionsLG_Save_Result_PCTQ));
        }
    });

    IButton_Cancel_PCTQ = isc.TrCancelBtn.create({
        click: function () {
            questionsDF_PCTQ.clearValues();
            Window_PCTQ.close();
        }
    });

    HLayout_SaveOrExit_PCTQ = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_PCTQ, IButton_Cancel_PCTQ]
    });

    Window_PCTQ = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='question'/>",
        items: [isc.TrVLayout.create({
            members: [questionsDF_PCTQ, HLayout_SaveOrExit_PCTQ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_PCTQ = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                refreshLG(questionsLG_PCTQ);
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                questionsLG_Add_PCTQ();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                questionsLG_Edit_PCTQ();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                questionsLG_Remove_PCTQ();
            }
        }
        ]
    });

    questionsLG_PCTQ = isc.TrLG.create({
        dataSource: questionsDS_PCTQ,
        contextMenu: Menu_PCTQ,
        align: "center",
        sortField: 1,
        fields: [
            {
                name: "preCourseTestQuestions",
                title: "<spring:message code='question'/>",
            }
        ],
        rowDoubleClick: function () {
            questionsLG_Edit_PCTQ();
        }
    });

    ToolStripButton_Refresh_PCTQ = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(questionsLG_PCTQ);
        }
    });

    ToolStripButton_Edit_PCTQ = isc.ToolStripButtonEdit.create({
        click: function () {
            questionsLG_Edit_PCTQ();
        }
    });
    ToolStripButton_Add_PCTQ = isc.ToolStripButtonCreate.create({
        click: function () {
            questionsLG_Add_PCTQ();
        }
    });
    ToolStripButton_Remove_PCTQ = isc.ToolStripButtonRemove.create({
        click: function () {
            questionsLG_Remove_PCTQ();
        }
    });

    ToolStrip_Actions_PCTQ = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_PCTQ,
                ToolStripButton_Edit_PCTQ,
                ToolStripButton_Remove_PCTQ,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_PCTQ
                    ]
                })
            ]
    });

    VLayout_Body_PCTQ = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_PCTQ,
            questionsLG_PCTQ
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function questionsLG_Add_PCTQ() {
        method_PCTQ = "POST";
        saveActionUrl_PCTQ = classUrl + "/" + classId_PCTQ;
        questionsDF_PCTQ.clearValues();
        Window_PCTQ.show();
    }

    function questionsLG_Edit_PCTQ() {
        <%--let record = questionsLG_PCTQ.getSelectedRecord();--%>
        <%--if (record == null || record.id == null) {--%>
        <%--    createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
        <%--} else {--%>
        <%--    method_PCTQ = "PUT";--%>
        <%--    saveActionUrl_PCTQ = employmentHistoryUrl + "/" + record.id;--%>
        <%--    questionsDF_PCTQ.clearValues();--%>
        <%--    questionsDF_PCTQ.editRecord(record);--%>
        <%--    Window_PCTQ.show();--%>
        <%--}--%>
    }

    function questionsLG_Remove_PCTQ() {
        <%--let record = questionsLG_PCTQ.getSelectedRecord();--%>
        <%--if (record == null) {--%>
        <%--    createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
        <%--} else {--%>
        <%--    let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>");--%>
        <%--    Dialog_Delete.addProperties({--%>
        <%--        buttonClick: function (button, index) {--%>
        <%--            this.close();--%>
        <%--            if (index === 0) {--%>
        <%--                wait_PCTQ = createDialog("wait");--%>
        <%--                isc.RPCManager.sendRequest(TrDSRequest(employmentHistoryUrl +--%>
        <%--                    "/" +--%>
        <%--                    classId_PCTQ +--%>
        <%--                    "," +--%>
        <%--                    questionsLG_PCTQ.getSelectedRecord().id,--%>
        <%--                    "DELETE",--%>
        <%--                    null,--%>
        <%--                    questionsLG_Remove_Result_PCTQ));--%>
        <%--            }--%>
        <%--        }--%>
        <%--    });--%>
        <%--}--%>
    }

    function questionsLG_Save_Result_PCTQ(resp) {
        wait_PCTQ.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            refreshLG(questionsLG_PCTQ);
            Window_PCTQ.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function questionsLG_Remove_Result_PCTQ(resp) {
        wait_PCTQ.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshLG(questionsLG_PCTQ);
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function loadPage_preCourseTestQuestions(id) {
        if (classId_PCTQ !== id) {
            classId_PCTQ = id;
            questionsDS_PCTQ.fetchDataURL = classUrl + "/iscList/" + classId_PCTQ;
            // questionsLG_PCTQ.fetchData();
            // refreshLG(questionsLG_PCTQ);
        }
    }

    function clear_preCourseTestQuestions() {
        questionsLG_PCTQ.clear();
    }

    //</script>