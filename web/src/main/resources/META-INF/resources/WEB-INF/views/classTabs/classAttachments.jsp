<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    let entityName = "class";
    let methodClassAttachment = "GET";
    let saveActionUrlClassAttachment;
    let attachmentWait;

    var RestDataSource_Class_Attachments_JspClassAttachments = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "fileName", title: "<spring:message code='attach.file.name'/>"},
            {name: "fileType", title: "<spring:message code='attach.file.format'/>"},
            {name: "description", title: "<spring:message code='description'/>"}
        ]
    });

    var DynamicForm_JspClassAttachments = isc.DynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "fileName",
                title: "<spring:message code="attach.file.name"/>",
                required: true
            },
            {
                name: "fileType",
                title: "<spring:message code="attach.file.format"/>",
                required: true
            },
            {
                name: "description",
                title: "<spring:message code="description"/>"
            },
            {
                name: "file",
                ID: "file",
                title: "<spring:message code="file.choose"/>",
                type: "file",
                multiple: false,
                hint: "<spring:message code="file.size.hint"/>",
                required: true
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name === "file") {
                var filePath = newValue.split("\\");
                filePath = filePath[filePath.getLength() - 1];
                this.getItem("fileType").setValue(filePath.split(".")[1]);
                if (this.getItem("fileName").value === undefined) {
                    this.getItem("fileName").setValue(filePath.split(".")[0]);
                }
            }
        }
    });

    var IButton_Save_JspClassAttachments = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_JspClassAttachments.validate();
            if (DynamicForm_JspClassAttachments.hasErrors()) {
                return;
            }
            if (methodClassAttachment === "POST") {
                var formData1 = new FormData();
                var fileBrowserId = document.getElementById(window.file.uploadItem.getElement().id);
                var file = fileBrowserId.files[0];

                formData1.append("file", file);
                formData1.append("entityName", entityName);
                formData1.append("objectId", selectedClassId);
                formData1.append("fileName", DynamicForm_JspClassAttachments.getValue("fileName"));
                formData1.append("fileType", DynamicForm_JspClassAttachments.getValue("fileType"));
                formData1.append("description", DynamicForm_JspClassAttachments.getValue("description"));
                TrnXmlHttpRequest(formData1, saveActionUrlClassAttachment, methodClassAttachment, save_result_ClassAttachments);
            } else if (methodClassAttachment === "PUT") {
                var data = DynamicForm_JspClassAttachments.getValues();
                isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlClassAttachment,
                    methodClassAttachment, JSON.stringify(data), save_result_ClassAttachments));
            }
        }
    });

    var IButton_Cancel_JspClassAttachments = isc.TrCancelBtn.create({
        prompt: "",
        width: 100,
        icon: "<spring:url value="remove.png"/>",
        orientation: "vertical",
        click: function () {
            DynamicForm_JspClassAttachments.clearValues();
            Window_JspClassAttachments.close();
        }
    });

    var HLayout_SaveOrExit_JspClassAttachments = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspClassAttachments, IButton_Cancel_JspClassAttachments]
    });

    var Window_JspClassAttachments = isc.Window.create({
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            width: "300",
            height: "120",
            members: [DynamicForm_JspClassAttachments, HLayout_SaveOrExit_JspClassAttachments]
        })]
    });

    var ListGrid_JspClassAttachment = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Class_Attachments_JspClassAttachments,
        <%--contextMenu: Menu_ListGrid_EducationLevel,--%>
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showRollOver: true,
        recordDoubleClick: function (viewer, record) {
            Show_Attachment_ClassAttachments(record.id);
        }
    });

    var ToolStripButton_Refresh_JspClassAttachment = isc.TrRefreshBtn.create({
        click: function () {
            ListGrid_ClassAttachments_refresh();
        }
    });

    var ToolStripButton_Edit_JspClassAttachment = isc.TrEditBtn.create({
        click: function () {
            ListGrid_ClassAttachments_Edit();
        }
    });
    var ToolStripButton_Add_JspClassAttachment = isc.TrCreateBtn.create({
        click: function () {
            ListGrid_ClassAttachments_Add();
        }
    });
    var ToolStripButton_Remove_JspClassAttachment = isc.TrRemoveBtn.create({
        click: function () {
            ListGrid_ClassAttachments_Remove();
        }
    });

    var ToolStrip_Actions_JspClassAttachment = isc.ToolStrip.create({
        width: "100%",
        members:
            [
                ToolStripButton_Refresh_JspClassAttachment,
                ToolStripButton_Add_JspClassAttachment,
                ToolStripButton_Edit_JspClassAttachment,
                ToolStripButton_Remove_JspClassAttachment
            ]
    });

    var HLayout_Actions_JspClassAttachment = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspClassAttachment]
    });

    var HLayout_Grid_JspClassAttachment = isc.TrHLayout.create({
        members: [ListGrid_JspClassAttachment]
    });

    var VLayout_Body_JspClassAttachment = isc.TrVLayout.create({
        members: [HLayout_Actions_JspClassAttachment,
            HLayout_Grid_JspClassAttachment
        ]
    });

    ///////////////////////////////////////////////////////functions///////////////////////////////////////

    function changeSelectedId(record) {
        RestDataSource_Class_Attachments_JspClassAttachments.fetchDataURL = attachmentUrl + "spec-list/" + entityName + ":" + selectedClassId;
        ListGrid_JspClassAttachment.fetchData();
        ListGrid_JspClassAttachment.invalidateCache();
    }

    function ListGrid_ClassAttachments_refresh() {
        var record = ListGrid_JspClassAttachment.getSelectedRecord();
        if (record != null && record.id != null) {
            ListGrid_JspClassAttachment.selectRecord(record);
        }
        ListGrid_JspClassAttachment.invalidateCache();
        ListGrid_JspClassAttachment.filterByEditor();
    }

    function ListGrid_ClassAttachments_Edit() {
        var record = ListGrid_JspClassAttachment.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            methodClassAttachment = "PUT";
            saveActionUrlClassAttachment = attachmentUrl + record.id;
            DynamicForm_JspClassAttachments.clearValues();
            DynamicForm_JspClassAttachments.editRecord(record);
            Window_JspClassAttachments.setTitle("<spring:message code="global.form.edit"/>");
            DynamicForm_JspClassAttachments.getItem("file").hide();
            DynamicForm_JspClassAttachments.getItem("fileType").disable();
            Window_JspClassAttachments.show();
        }
    }

    function ListGrid_ClassAttachments_Add() {
        methodClassAttachment = "POST";
        saveActionUrlClassAttachment = attachmentUrl + "upload";
        DynamicForm_JspClassAttachments.clearValues();
        Window_JspClassAttachments.setTitle("<spring:message code="global.form.new"/>");
        DynamicForm_JspClassAttachments.getItem("file").show();
        DynamicForm_JspClassAttachments.getItem("fileType").disable();
        Window_JspClassAttachments.show();
    }

    function save_result_ClassAttachments(resp) {
        var stat;
        var respText;
        if (methodClassAttachment === "POST") {
            stat = resp.status;
            respText = resp.responseText;
        } else {
            stat = resp.httpResponseCode;
            respText = resp.httpResponseText;
        }
        if (stat === 200 || stat === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_ClassAttachments_refresh();
            Window_JspClassAttachments.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (stat === 406 && respText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>",
                    "<spring:message code="message"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>",
                    "<spring:message code="message"/>");
            }
        }
    }

    function ListGrid_ClassAttachments_Remove() {
        var record = ListGrid_JspClassAttachment.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        attachmentWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(attachmentUrl + "delete/" + record.id, "DELETE", null,
                            "callback: remove_result_ClassAttachments(rpcResponse)"));
                    }
                }
            });
        }
    }

    function remove_result_ClassAttachments(resp) {
        attachmentWait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_ClassAttachments_refresh();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
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

    function Show_Attachment_ClassAttachments(id) {
        var downloadForm = isc.DynamicForm.create({
            method: "GET",
            action: "attachment/download/" + id,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "myToken", type: "hidden"}
                ]
        });
        downloadForm.setValue("myToken", "<%=accessToken%>");
        downloadForm.show();
        downloadForm.submitForm();
    }

    //</script>