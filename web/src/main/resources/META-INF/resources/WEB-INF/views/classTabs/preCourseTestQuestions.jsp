<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let method_PCTQ = "GET";
    let saveActionUrl_PCTQ;
    let wait_PCTQ;
    let classId_PCTQ = null;
    let questions_PCTQ = null;

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

    <%--questionsDF_PCTQ = isc.DynamicForm.create({--%>
    <%--    width: "100%",--%>
    <%--    height: "100%",--%>
    <%--    titleAlign: "left",--%>
    <%--    fields: [--%>
    <%--        {--%>
    <%--            name: "question",--%>
    <%--            title: "<spring:message code='question'/>",--%>
    <%--            required: true,--%>
    <%--            keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"--%>
    <%--        }--%>
    <%--    ]--%>
    <%--});--%>

    IButton_Save_PCTQ = isc.IButtonSave.create({
        click: function () {
            if (questionsLG_PCTQ.hasErrors() || classId_PCTQ == null)
                return;
            wait_PCTQ = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "preCourse-test-questions/" + classId_PCTQ, "PUT", JSON.stringify(questionsLG_PCTQ.data.map(r => r.question)), questionsLG_Save_Result_PCTQ));
        }
    });

    IButton_Cancel_PCTQ = isc.IButtonCancel.create({
        click: function () {
            loadPage_preCourseTestQuestions(classId_PCTQ);
        }
    });

    HLayout_SaveOrExit_PCTQ = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_PCTQ, IButton_Cancel_PCTQ]
    });

    <%--Window_PCTQ = isc.Window.create({--%>
    <%--    width: "500",--%>
    <%--    align: "center",--%>
    <%--    border: "1px solid gray",--%>
    <%--    title: "<spring:message code='question'/>",--%>
    <%--    items: [isc.TrVLayout.create({--%>
    <%--        members: [questionsDF_PCTQ, HLayout_SaveOrExit_PCTQ]--%>
    <%--    })]--%>
    <%--});--%>

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_PCTQ = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                loadPage_preCourseTestQuestions(classId_PCTQ);
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                questionsLG_PCTQ.startEditingNew();
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
        contextMenu: Menu_PCTQ,
        align: "center",
        canReorderRecords: true,
        autoFitMaxRecords: 4,
        autoFitData: "vertical",
        canEdit: true,
        modalEditing: true,
        canRemoveRecords: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        validateOnChange: true,
        validateByCell: true,
        // canSort: false,
        fields: [
            {
                name: "question",
                title: "<spring:message code='question'/>",
                validators: [
                    {
                        type: "lengthRange",
                        max: 1000,
                        errorMessage: "<spring:message code="class.preCourseTestQuestion.length.limit"/>"
                    },
                    {type: "required", errorMessage: "<spring:message code="msg.field.is.required"/>"}
                ],
            }
        ],
        rowDoubleClick: function () {
            questionsLG_Edit_PCTQ();
        },
        <%--editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid) {--%>
        <%--    // questionsLG_PCTQ.data.some(r => newValue.equals(r.question))--%>
        <%--    if (questionsLG_PCTQ.data.map(r => r.question).contains(newValue)) {--%>
        <%--        &lt;%&ndash;questionsLG_PCTQ.setRowErrors (rowNum, "<spring:message code="msg.record.duplicate"/>");&ndash;%&gt;--%>
        <%--        // alert(rowNum);--%>
        <%--        questionsLG_PCTQ.setRowErrors(rowNum, "<spring:message code="msg.record.duplicate"/>");--%>
        <%--        questionsLG_PCTQ.setFieldError (rowNum, "question", "<spring:message code="msg.record.duplicate"/>");--%>
        <%--        // grid.startEditing(rowNum);--%>
        <%--        &lt;%&ndash;alert("<spring:message code="msg.record.duplicate"/>");&ndash;%&gt;--%>
        <%--        &lt;%&ndash;createDialog("info", "<spring:message code="msg.record.duplicate"/>");&ndash;%&gt;--%>
        <%--        // questionsLG_PCTQ.startEditing(rowNum);--%>
        <%--        // alert(record.question);--%>
        <%--        // questionsLG_Edit_PCTQ(record);--%>
        <%--        // return;--%>
        <%--    }--%>
        <%--    else--%>
        <%--        questionsLG_PCTQ.clearFieldError(rowNum, "question");--%>
        <%--    // this.Super("editorExit", arguments);--%>
        <%--}--%>
    });

    ToolStripButton_Refresh_PCTQ = isc.ToolStripButtonRefresh.create({
        click: function () {
            loadPage_preCourseTestQuestions(classId_PCTQ);
        }
    });

    ToolStripButton_Edit_PCTQ = isc.ToolStripButtonEdit.create({
        click: function () {
            questionsLG_Edit_PCTQ();
        }
    });
    ToolStripButton_Add_PCTQ = isc.ToolStripButtonCreate.create({
        click: function () {
            questionsLG_PCTQ.startEditingNew();
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
        members: [ToolStrip_Actions_PCTQ, questionsLG_PCTQ, HLayout_SaveOrExit_PCTQ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    // function questionsLG_Add_PCTQ() {
    //     method_PCTQ = "POST";
    //     saveActionUrl_PCTQ = classUrl + "/" + classId_PCTQ;
    //     questionsDF_PCTQ.clearValues();
    //     Window_PCTQ.show();
    // }

    function questionsLG_Edit_PCTQ() {
        let record = questionsLG_PCTQ.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        questionsLG_PCTQ.startEditing(questionsLG_PCTQ.getRowNum(record));
    }

    function questionsLG_Remove_PCTQ() {
        let records = questionsLG_PCTQ.getSelectedRecords();
        if (records.isEmpty()) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        questionsLG_PCTQ.data.removeAll(records);
    }

    function questionsLG_Save_Result_PCTQ(resp) {
        wait_PCTQ.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            loadPage_preCourseTestQuestions(classId_PCTQ);
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    <%--function questionsLG_Remove_Result_PCTQ(resp) {--%>
    <%--    wait_PCTQ.close();--%>
    <%--    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--        refreshLG(questionsLG_PCTQ);--%>
    <%--        let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");--%>
    <%--        setTimeout(function () {--%>
    <%--            OK.close();--%>
    <%--        }, 3000);--%>
    <%--    } else {--%>
    <%--        let respText = resp.httpResponseText;--%>
    <%--        if (resp.httpResponseCode === 406 && respText === "NotDeletable") {--%>
    <%--            createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");--%>
    <%--        } else {--%>
    <%--            createDialog("info", "<spring:message code="msg.operation.error"/>");--%>
    <%--        }--%>
    <%--    }--%>
    <%--}--%>

    function setQuestionsLGData_PCTQ(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            let questions = (JSON.parse(resp.data));
            questions_PCTQ = (JSON.parse(resp.data)).map(q =>{});
            questionsLG_PCTQ.setData(questions_PCTQ);
        } else {

        }
    }

    function loadPage_preCourseTestQuestions(id) {
        if (id != null) {
            classId_PCTQ = id;
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "preCourse-test-questions/" + classId_PCTQ, "GET", null, setQuestionsLGData_PCTQ));
        }
        else{
            classId_PCTQ = null;
            questionsLG_PCTQ.setData([]);
        }
    }

    function clear_preCourseTestQuestions() {
        questionsLG_PCTQ.clear();
    }

    //</script>