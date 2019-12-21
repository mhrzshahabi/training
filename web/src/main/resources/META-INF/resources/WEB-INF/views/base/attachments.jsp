<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    let objectTypeAttachment = null;
    let objectIdAttachment = null;
    let methodAttachment = "GET";
    let saveActionUrlAttachment;
    let attachmentWait;

    RestDataSource_Attachments_JspAttachments = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "fileName", title: "<spring:message code='attach.file.name'/>", filterOperator: "iContains"},
            {name: "fileTypeId", title: "<spring:message code='attach.file.format'/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains"}
        ]
    });

    DynamicForm_JspAttachments = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        fields: [
            {name: "id", hidden: true},
            {
                name: "fileName",
                title: "<spring:message code="attach.file.name"/>",
                required: true
            },
            {
                name: "fileTypeId",
                type: "IntegerItem",
                title: "<spring:message code='attach.file.format'/>",
                required: true,
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Enum_JspTeacher,
                pickListProperties: {
                    showFilterEditor: false
                },
                filterOperator: "iContains",
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}
                ]
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
                required: true,
                maxFileSize: 31457280,
                <%--maxFileSizeExceededMessage: "<spring:message code="file.size.hint"/>",--%>
                <%--maxFileSizeExceeded: "<spring:message code="file.size.hint"/>",--%>
                // accept: ".png,.gif,.jpg, .jpeg",
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name === "file") {
                let fileName = newValue.split("\\");
                fileName = fileName[fileName.getLength() - 1];
                if (this.getItem("fileName").value === undefined) {
                    this.getItem("fileName").setValue(fileName);
                }
            }
        }
    });

    IButton_Save_JspAttachments = isc.IButtonSave.create({
        top: 260,
        click: function () {
            DynamicForm_JspAttachments.validate();
            if (DynamicForm_JspAttachments.hasErrors()) {
                return;
            }
            if (methodAttachment === "POST") {
                let formData1 = new FormData();
                let fileBrowserId = document.getElementById(window.file.uploadItem.getElement().id);
                let file = fileBrowserId.files[0];

                formData1.append("file", file);
                formData1.append("objectType", objectTypeAttachment);
                formData1.append("objectId", objectIdAttachment);
                formData1.append("fileName", DynamicForm_JspAttachments.getValue("fileName"));
                formData1.append("fileTypeId", DynamicForm_JspAttachments.getValue("fileTypeId"));
                formData1.append("description", DynamicForm_JspAttachments.getValue("description"));
                TrnXmlHttpRequest(formData1, saveActionUrlAttachment, methodAttachment, save_result_Attachments);
            } else if (methodAttachment === "PUT") {
                let data = DynamicForm_JspAttachments.getValues();
                isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlAttachment,
                    methodAttachment, JSON.stringify(data), save_result_Attachments));
            }
        }
    });

    IButton_Cancel_JspAttachments = isc.IButtonCancel.create({
        prompt: "",
        width: 100,
        orientation: "vertical",
        click: function () {
            DynamicForm_JspAttachments.clearValues();
            Window_JspAttachments.close();
        }
    });

    HLayout_SaveOrExit_JspAttachments = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspAttachments, IButton_Cancel_JspAttachments]
    });

    Window_JspAttachments = isc.Window.create({
        width: "300",
        align: "center",
        border: "1px solid gray",
        canDragResize: false,
        showMaximizeButton: false,
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspAttachments, HLayout_SaveOrExit_JspAttachments]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_ListGrid_JspAttachments = isc.Menu.create({
        // width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_Attachments_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_Attachments_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_Attachments_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_Attachments_Remove();
            }
        }, {
            title: "<spring:message code='download'/>", click: function () {
                Show_Attachment_Attachments(ListGrid_JspAttachment.getSelectedRecord());
            }
        }
        ]
    });

    ListGrid_JspAttachment = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Attachments_JspAttachments,
        contextMenu: Menu_ListGrid_JspAttachments,
        selectionType: "single",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showRollOver: true,
        fields: [
            {
                name: "fileName"
            },
            {
                name: "fileTypeId",
                type: "IntegerItem",
                title: "<spring:message code='attach.file.format'/>",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Enum_JspTeacher,
                pickListProperties: {
                    showFilterEditor: false
                },
                filterOperator: "iContains",
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}
                ]
            },
            {
                name: "description"
            }
        ],
        recordDoubleClick: function (viewer, record) {
            Show_Attachment_Attachments(record);
        }
    });

    ToolStripButton_Refresh_JspAttachment = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Attachments_refresh();
        }
    });

    ToolStripButton_Edit_JspAttachment = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_Attachments_Edit();
        }
    });
    ToolStripButton_Add_JspAttachment = isc.ToolStripButtonAdd.create({
        click: function () {
            ListGrid_Attachments_Add();
        }
    });
    ToolStripButton_Remove_JspAttachment = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_Attachments_Remove();
        }
    });

    ToolStrip_Actions_JspAttachment = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspAttachment,
                ToolStripButton_Edit_JspAttachment,
                ToolStripButton_Remove_JspAttachment,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspAttachment
                    ]
                })
            ]
    });

    HLayout_Actions_JspAttachment = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspAttachment]
    });

    HLayout_Grid_JspAttachment = isc.TrHLayout.create({
        members: [ListGrid_JspAttachment]
    });

    VLayout_Body_JspAttachment = isc.TrVLayout.create({
        members: [HLayout_Actions_JspAttachment,
            HLayout_Grid_JspAttachment
        ]
    });

    ///////////////////////////////////////////////////////functions///////////////////////////////////////

    function ListGrid_Attachments_refresh() {
        ListGrid_JspAttachment.invalidateCache();
        ListGrid_JspAttachment.filterByEditor();
    }

    function ListGrid_Attachments_Edit() {
        let record = ListGrid_JspAttachment.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodAttachment = "PUT";
            saveActionUrlAttachment = attachmentUrl + "/" + record.id;
            DynamicForm_JspAttachments.clearValues();
            DynamicForm_JspAttachments.editRecord(record);
            DynamicForm_JspAttachments.getItem("file").hide();
            Window_JspAttachments.show();
        }
    }

    function ListGrid_Attachments_Add() {
        methodAttachment = "POST";
        saveActionUrlAttachment = attachmentUrl + "/upload";
        DynamicForm_JspAttachments.clearValues();
        DynamicForm_JspAttachments.getItem("file").show();
        Window_JspAttachments.show();
    }

    function save_result_Attachments(resp) {
        let stat;
        let respText;
        if (methodAttachment === "POST") {
            stat = resp.status;
            respText = resp.responseText;
        } else {
            stat = resp.httpResponseCode;
            respText = resp.httpResponseText;
        }
        if (stat === 200 || stat === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_Attachments_refresh();
            Window_JspAttachments.close();
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

    function ListGrid_Attachments_Remove() {
        let record = ListGrid_JspAttachment.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        attachmentWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(attachmentUrl + "/delete/" + record.id, "DELETE", null,
                            "callback: remove_result_Attachments(rpcResponse)"));
                    }
                }
            });
        }
    }

    function remove_result_Attachments(resp) {
        attachmentWait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Attachments_refresh();
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
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

    function Show_Attachment_Attachments(record) {
        let downloadForm = isc.DynamicForm.create({
            method: "GET",
            action: "attachment/download/" + record.id,
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

    function loadPage_attachment(inputObjectType, inputObjectId, inputTitleAttachment, RestDataSource_EAttachmentType) {
        objectTypeAttachment = inputObjectType;
        objectIdAttachment = inputObjectId;
        RestDataSource_Attachments_JspAttachments.fetchDataURL = attachmentUrl + "/iscList/";
        if (objectTypeAttachment != null)
            RestDataSource_Attachments_JspAttachments.fetchDataURL += objectTypeAttachment;
        RestDataSource_Attachments_JspAttachments.fetchDataURL += ",";
        if (objectTypeAttachment != null)
            RestDataSource_Attachments_JspAttachments.fetchDataURL += objectIdAttachment;

        ListGrid_JspAttachment.getField("fileTypeId").setOptionDataSource(RestDataSource_EAttachmentType);
        DynamicForm_JspAttachments.getField("fileTypeId").setOptionDataSource(RestDataSource_EAttachmentType);

        Window_JspAttachments.title = inputTitleAttachment;
        ListGrid_JspAttachment.fetchData();
        ListGrid_Attachments_refresh();
    }

    function clear_Attachments() {
        ListGrid_JspAttachment.clear();
    }

    //</script>