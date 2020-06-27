<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var RestDataSource_Attachments_JspClassDocuments = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "fileName", title: "<spring:message code='attach.file.name'/>", filterOperator: "iContains"},
            {name: "fileTypeId", title: "<spring:message code='attach.file.format'/>", filterOperator: "equals"},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains"}
        ]
    });

    DynamicForm_JspClassDocuments = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        fields: [
            {name: "id", hidden: true},
            {
                name: "fileName",
                title: "فیلد مرجع",
                required: true,
                type: "SelectItem",
                defaultValue: "3",
                valueMap: {
                    "1": "پرداخت شده",
                    "2": "پرداخت نشده",
                    "3": "همه"
                },
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                name: "fileName",
                title: "نوع نامه",
                required: true,
                type: "SelectItem",
                defaultValue: "3",
                valueMap: {
                    "1": "پرداخت شده",
                    "2": "پرداخت نشده",
                    "3": "همه"
                },
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                name: "description",
                title: "شماره نامه",
                required: true,
                length: 50,
                keyPressFilter: /^((?![/\\?%*:|"<>.]).)*$/
            }
        ]
    });

    IButton_Save_JspClassDocuments = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspClassDocuments.validate()) {
                return;
            }
            if (methodAttachment === "POST") {
                if (!isAttachedAttachment || document.getElementById('file_JspClassDocuments').files.length === 0) {
                    createDialog("info", "<spring:message code='file.not.uploaded'/>");
                    return;
                }
                if (document.getElementById('file_JspClassDocuments').files[0].size > maxFileSizeAttachment) {
                    createDialog("info", "<spring:message code='file.size.hint'/>");
                    return;
                }
                attachmentWait = createDialog("wait");
                let formData1 = new FormData();
                let file = document.getElementById('file_JspClassDocuments').files[0];
                let fileName = DynamicForm_JspClassDocuments.getValue("fileName");
                if (file.name.split('.').length > 1)
                    fileName += "." + file.name.split('.')[1];
                formData1.append("file", file);
                formData1.append("objectType", objectTypeAttachment);
                formData1.append("objectId", objectIdAttachment);
                formData1.append("fileName", fileName);
                formData1.append("fileTypeId", DynamicForm_JspClassDocuments.getValue("fileTypeId"));
                formData1.append("description", DynamicForm_JspClassDocuments.getValue("description"));
                TrnXmlHttpRequest(formData1, saveActionUrlAttachment, methodAttachment, save_result_Attachments);
            } else if (methodAttachment === "PUT") {
                attachmentWait = createDialog("wait");
                let data = DynamicForm_JspClassDocuments.getValues();
                if (ListGrid_JspClassDocuments.getSelectedRecord().fileName.split('.').length > 1)
                    data.fileName += "." + ListGrid_JspClassDocuments.getSelectedRecord().fileName.split('.')[1];
                isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlAttachment,
                    methodAttachment, JSON.stringify(data), save_result_Attachments));
            }
        }
    });

    IButton_Cancel_JspClassDocuments = isc.IButtonCancel.create({
        click: function () {
            DynamicForm_JspClassDocuments.clearValues();
            Window_JspClassDocuments.close();
        }
    });

    HLayout_SaveOrExit_JspClassDocuments = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspClassDocuments, IButton_Cancel_JspClassDocuments]
    });

    VLayOut_Photo_JspClassDocuments = isc.TrVLayout.create({
        showEdges: false,
        edgeImage: "",
        align: "top",
        layoutMargin: 5,
        members: [
            DynamicForm_JspClassDocuments]
    });

    Window_JspClassDocuments = isc.Window.create({
        width: "400",
        align: "center",
        border: "1px solid gray",
        canDragResize: false,
        showMaximizeButton: false,
        items: [isc.TrVLayout.create({
            members: [VLayOut_Photo_JspClassDocuments, HLayout_SaveOrExit_JspClassDocuments]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_JspClassDocuments = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Attachments_JspClassDocuments,
        <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_R','TclassAttachmentsTab_classStatus')">
        contextMenu: Menu_ListGrid_JspClassDocuments,
        </sec:authorize>
        selectionType: "single",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showRollOver: true,
        fields: [
            {
                name: "fileName",
                title: "شماره نامه"
            },
            {
                name: "fileTypeId",
                title: "نوع نامه",
                filterOnKeypress: true,
                editorType: "SelectItem"
            }
        ],
        recordDoubleClick: function (viewer, record) {
            Show_Attachment_Attachments(record);
        }
    });

    ToolStripButton_Refresh_JspClassDocuments = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Attachments_refresh();
        }
    });

    ToolStripButton_Edit_JspClassDocuments = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_Attachments_Edit();
        }
    });

    ToolStripButton_Add_JspClassDocuments = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_Attachments_Add();
        }
    });

    ToolStripButton_Remove_JspClassDocuments = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_Attachments_Remove();
        }
    });

    ToolStrip_Actions_JspClassDocuments = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_C','TclassAttachmentsTab_classStatus')">
                ToolStripButton_Add_JspClassDocuments,
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_U','TclassAttachmentsTab_classStatus')">
                ToolStripButton_Edit_JspClassDocuments,
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_D','TclassAttachmentsTab_classStatus')">
                ToolStripButton_Remove_JspClassDocuments,
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_R','TclassAttachmentsTab_classStatus')">
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspClassDocuments
                    ]
                })
                </sec:authorize>

            ]
    });

    var HLayout_Actions_JspClassDocuments = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspClassDocuments]
    });

    var HLayout_Grid_JspClassDocuments = isc.TrHLayout.create({
        members: [ListGrid_JspClassDocuments]
    });

    var VLayout_Body_JspClassDocuments = isc.TrVLayout.create({
        members: [HLayout_Actions_JspClassDocuments,
            HLayout_Grid_JspClassDocuments
        ]
    });

    ///////////////////////////////////////////////////////functions///////////////////////////////////////

    function ListGrid_Attachments_refresh() {
        ListGrid_JspClassDocuments.invalidateCache();
        ListGrid_JspClassDocuments.filterByEditor();
    }

    function ListGrid_Attachments_Edit() {
        let record = ListGrid_JspClassDocuments.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodAttachment = "PUT";
            saveActionUrlAttachment = attachmentUrl + "/" + record.id;
            DynamicForm_JspClassDocuments.clearValues();
            DynamicForm_JspClassDocuments.editRecord(record);
            DynamicForm_JspClassDocuments.setValue("fileName", record.fileName.split('.')[0]);
            Button_Upload_JspClassDocuments.hide();
            Label_FileUploadSize_JspClassDocuments.hide();
            Window_JspClassDocuments.show();
        }
    }

    function ListGrid_Attachments_Add() {
        isAttachedAttachment = false;
        methodAttachment = "POST";
        saveActionUrlAttachment = attachmentUrl + "/upload";
        DynamicForm_JspClassDocuments.clearValues();
        Button_Upload_JspClassDocuments.show();
        Label_FileUploadSize_JspClassDocuments.show();
        Window_JspClassDocuments.show();
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
            Window_JspClassDocuments.close();
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
        let record = ListGrid_JspClassDocuments.getSelectedRecord();
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

    function Upload_Changed_JspClassDocuments() {
        if (document.getElementById('file_JspClassDocuments').files.length === 0)
            return;
        if (document.getElementById('file_JspClassDocuments').files[0].size > maxFileSizeAttachment) {
            createDialog("info", "<spring:message code='file.size.hint'/>");
            DynamicForm_JspClassDocuments.getItem("fileName").setValue("");
            return;
        }
        isAttachedAttachment = true;
        let fileName = document.getElementById('file_JspClassDocuments').files[0].name;
        if (DynamicForm_JspClassDocuments.getValue("fileName") === undefined) {
            DynamicForm_JspClassDocuments.getItem("fileName").setValue(fileName.split('.')[0]);
        }
    }

    function loadPage_attachment(inputObjectType, inputObjectId, inputTitleAttachment, valueMap_EAttachmentType, readOnly = false, criteria = null) {
        var  classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        VLayout_Body_JspClassDocuments.redraw();
        objectTypeAttachment = inputObjectType;
        objectIdAttachment = inputObjectId;
        RestDataSource_Attachments_JspClassDocuments.fetchDataURL = attachmentUrl + "/iscList/";
        if (objectTypeAttachment != null)
            RestDataSource_Attachments_JspClassDocuments.fetchDataURL += objectTypeAttachment;
        RestDataSource_Attachments_JspClassDocuments.fetchDataURL += ",";
        if (objectTypeAttachment != null)
            RestDataSource_Attachments_JspClassDocuments.fetchDataURL += objectIdAttachment;
        ListGrid_JspClassDocuments.getField("fileTypeId").valueMap = valueMap_EAttachmentType;
        DynamicForm_JspClassDocuments.getField("fileTypeId").valueMap = valueMap_EAttachmentType;
        Window_JspClassDocuments.title = inputTitleAttachment;
        ListGrid_JspClassDocuments.setImplicitCriteria(criteria);
        ListGrid_JspClassDocuments.fetchData(criteria);
        ListGrid_Attachments_refresh();
        if(classRecord.classStatus === "3")
        {
            <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_C','TclassAttachmentsTab_R','TclassAttachmentsTab_U','TclassAttachmentsTab_D')">
            ToolStrip_Actions_JspClassDocuments.setVisibility(false)
            ListGrid_JspClassDocuments.contextMenu = null;
            </sec:authorize>
        }
        else
        {
            <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_C','TclassAttachmentsTab_R','TclassAttachmentsTab_U','TclassAttachmentsTab_D')">
            ToolStrip_Actions_JspClassDocuments.setVisibility(true)
            ListGrid_JspClassDocuments.contextMenu = Menu_ListGrid_JspClassDocuments;
            </sec:authorize>
        }
        if (classRecord.classStatus === "3")
        {
            <sec:authorize access="hasAuthority('TclassAttachmentsTab_classStatus')">
            ToolStrip_Actions_JspClassDocuments.setVisibility(true)
            ListGrid_JspClassDocuments.contextMenu = Menu_ListGrid_JspClassDocuments;
            </sec:authorize>
        }
    }

    function clear_Attachments() {
        ListGrid_JspClassDocuments.clear();
    }

    //</script>