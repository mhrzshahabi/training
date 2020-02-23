<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    let maxFileSizeAttachment = 31457280;
    let objectTypeAttachment = null;
    let objectIdAttachment = null;
    let methodAttachment = "GET";
    let saveActionUrlAttachment;
    let attachmentWait;

    var RestDataSource_Attachments_JspAttachments = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "fileName", title: "<spring:message code='attach.file.name'/>", filterOperator: "iContains"},
            {name: "fileTypeId", title: "<spring:message code='attach.file.format'/>", filterOperator: "equals"},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains"}
        ]
    });

    Label_FileUploadSize_JspAttachments = isc.Label.create({
        height: "100%",
        align: "center",
        contents: "<spring:message code='file.size.hint'/>"
    });

    Button_Upload_JspAttachments = isc.HTMLFlow.create({
        align: "center",
        contents: "<form class=\"uploadButton\" method=\"POST\" id=\"form_file_JspAttachments\" action=\"\" enctype=\"multipart/form-data\"><label for=\"file_JspAttachments\" class=\"custom-file-upload\"><i class=\"fa fa-cloud-upload\"></i><spring:message code='file.upload'/></label><input id=\"file_JspAttachments\" type=\"file\" name=\"file[]\" name=\"file\" onchange=\"Upload_Changed_JspAttachments()\" /></form>"
    });

    DynamicForm_JspAttachments = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        fields: [
            {name: "id", hidden: true},
            {
                name: "fileName",
                title: "<spring:message code="attach.file.name"/>",
                required: true,
                length: 50,
                keyPressFilter: /^((?![/\\?%*:|"<>.]).)*$/
            },
            {
                name: "fileTypeId",
                type: "IntegerItem",
                title: "<spring:message code='attach.file.format'/>",
                required: true,
                filterOnKeypress: true,
                editorType: "ComboBoxItem",
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                textAlign: "center",
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
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
                title: "<spring:message code="description"/>",
                length: 255
            }
        ]
    });

    IButton_Save_JspAttachments = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspAttachments.validate()) {
                return;
            }
            if (methodAttachment === "POST") {
                if (document.getElementById('file_JspAttachments').files.length === 0) {
                    createDialog("info", "<spring:message code='file.not.uploaded'/>");
                    return;
                }
                if (document.getElementById('file_JspAttachments').files[0].size > maxFileSizeAttachment) {
                    createDialog("info", "<spring:message code='file.size.hint'/>");
                    return;
                }
                attachmentWait = createDialog("wait");
                let formData1 = new FormData();
                let file = document.getElementById('file_JspAttachments').files[0];
                let fileName = DynamicForm_JspAttachments.getValue("fileName");
                if (file.name.split('.').length > 1)
                    fileName += "." + file.name.split('.')[1];
                formData1.append("file", file);
                formData1.append("objectType", objectTypeAttachment);
                formData1.append("objectId", objectIdAttachment);
                formData1.append("fileName", fileName);
                formData1.append("fileTypeId", DynamicForm_JspAttachments.getValue("fileTypeId"));
                formData1.append("description", DynamicForm_JspAttachments.getValue("description"));
                TrnXmlHttpRequest(formData1, saveActionUrlAttachment, methodAttachment, save_result_Attachments);
            } else if (methodAttachment === "PUT") {
                attachmentWait = createDialog("wait");
                let data = DynamicForm_JspAttachments.getValues();
                if (ListGrid_JspAttachment.getSelectedRecord().fileName.split('.').length > 1)
                    data.fileName += "." + ListGrid_JspAttachment.getSelectedRecord().fileName.split('.')[1];
                isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlAttachment,
                    methodAttachment, JSON.stringify(data), save_result_Attachments));
            }
        }
    });

    IButton_Cancel_JspAttachments = isc.IButtonCancel.create({
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

    VLayOut_Photo_JspAttachments = isc.TrVLayout.create({
        showEdges: false,
        edgeImage: "",
        align: "top",
        layoutMargin: 5,
        members: [
            DynamicForm_JspAttachments, Button_Upload_JspAttachments, Label_FileUploadSize_JspAttachments]
    });


    Window_JspAttachments = isc.Window.create({
        width: "400",
        align: "center",
        border: "1px solid gray",
        canDragResize: false,
        showMaximizeButton: false,
        items: [isc.TrVLayout.create({
            members: [VLayOut_Photo_JspAttachments, HLayout_SaveOrExit_JspAttachments]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_ListGrid_JspAttachments = isc.Menu.create({
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

    Menu_ListGrid_ReadOnly_JspAttachments = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_Attachments_refresh();
            }
        }, {
            title: "<spring:message code='download'/>", click: function () {
                Show_Attachment_Attachments(ListGrid_JspAttachment.getSelectedRecord());
            }
        }
        ]
    });

    var ListGrid_JspAttachment = isc.TrLG.create({
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
                title: "<spring:message code='attach.file.format'/>",
                filterOnKeypress: true,
                editorType: "SelectItem"
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
    ToolStripButton_Add_JspAttachment = isc.ToolStripButtonCreate.create({
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

    var HLayout_Actions_JspAttachment = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspAttachment]
    });

    var HLayout_Grid_JspAttachment = isc.TrHLayout.create({
        members: [ListGrid_JspAttachment]
    });

    var VLayout_Body_JspAttachment = isc.TrVLayout.create({
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
            DynamicForm_JspAttachments.setValue("fileName", record.fileName.split('.')[0]);
            Button_Upload_JspAttachments.hide();
            Label_FileUploadSize_JspAttachments.hide();
            Window_JspAttachments.show();
        }
    }

    function ListGrid_Attachments_Add() {
        methodAttachment = "POST";
        saveActionUrlAttachment = attachmentUrl + "/upload";
        DynamicForm_JspAttachments.clearValues();
        Button_Upload_JspAttachments.show();
        Label_FileUploadSize_JspAttachments.show();
        Window_JspAttachments.show();
    }

    function save_result_Attachments(resp) {
        let stat;
        let respText;
        attachmentWait.close();
        if (methodAttachment === "POST") {
            stat = resp.status;
            respText = resp.responseText;
        } else {
            stat = resp.httpResponseCode;
            respText = resp.httpResponseText;
        }
        if (stat === 200 || stat === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            ListGrid_Attachments_refresh();
            Window_JspAttachments.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (stat === 406 && respText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
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

    function Upload_Changed_JspAttachments() {
        if (document.getElementById('file_JspAttachments').files[0].size > maxFileSizeAttachment) {
            createDialog("info", "<spring:message code='file.size.hint'/>");
            DynamicForm_JspAttachments.getItem("fileName").setValue("");
            return;
        }
        let fileName = document.getElementById('file_JspAttachments').files[0].name;
        if (DynamicForm_JspAttachments.getValue("fileName") === undefined) {
            DynamicForm_JspAttachments.getItem("fileName").setValue(fileName.split('.')[0]);
        }
    }

    function loadPage_attachment(inputObjectType, inputObjectId, inputTitleAttachment, valueMap_EAttachmentType, readOnly = false, criteria = null) {
        VLayout_Body_JspAttachment.redraw();
        objectTypeAttachment = inputObjectType;
        objectIdAttachment = inputObjectId;
        RestDataSource_Attachments_JspAttachments.fetchDataURL = attachmentUrl + "/iscList/";
        if (objectTypeAttachment != null)
            RestDataSource_Attachments_JspAttachments.fetchDataURL += objectTypeAttachment;
        RestDataSource_Attachments_JspAttachments.fetchDataURL += ",";
        if (objectTypeAttachment != null)
            RestDataSource_Attachments_JspAttachments.fetchDataURL += objectIdAttachment;
        ListGrid_JspAttachment.getField("fileTypeId").valueMap = valueMap_EAttachmentType;
        DynamicForm_JspAttachments.getField("fileTypeId").valueMap = valueMap_EAttachmentType;
        Window_JspAttachments.title = inputTitleAttachment;
        ListGrid_JspAttachment.setImplicitCriteria(criteria);
        ListGrid_JspAttachment.fetchData(criteria);
        ListGrid_Attachments_refresh();
        if (readOnly) {
            ToolStripButton_Edit_JspAttachment.hide();
            ToolStripButton_Add_JspAttachment.hide();
            ToolStripButton_Remove_JspAttachment.hide();
            ListGrid_JspAttachment.contextMenu = Menu_ListGrid_ReadOnly_JspAttachments;
        } else {
            ToolStripButton_Edit_JspAttachment.show();
            ToolStripButton_Add_JspAttachment.show();
            ToolStripButton_Remove_JspAttachment.show();
            ListGrid_JspAttachment.contextMenu = Menu_ListGrid_JspAttachments;
        }
    }

    function clear_Attachments() {
        ListGrid_JspAttachment.clear();
    }

    //</script>