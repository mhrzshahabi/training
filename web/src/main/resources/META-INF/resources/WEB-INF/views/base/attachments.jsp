<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="application/javascript;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    loadAttachments = function loadAttachments() {
        me=this;
        this.maxFileSizeAttachment = 31457280;
        objectTypeAttachment = null;
        objectIdAttachment = null;
        this.methodAttachment = "GET";
        this.saveActionUrlAttachment;
        let attachmentWait;
        isAttachedAttachment = false;

        this.RestDataSource_Attachments_JspAttachments = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "fileName", title: "<spring:message code='attach.file.name'/>", filterOperator: "iContains"},
                {name: "fileTypeId", title: "<spring:message code='attach.file.format'/>", filterOperator: "equals"},
                {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains"},
                {name: "key", title: "<spring:message code='description'/>", filterOperator: "iContains"},
                {name: "group_id", title: "<spring:message code='description'/>", filterOperator: "iContains"}
            ]
        });

        this.Label_FileUploadSize_JspAttachments = isc.Label.create({
            height: "100%",
            align: "center",
            contents: "<spring:message code='file.size.hint'/>"
        });

        this.Button_Upload_JspAttachments = isc.HTMLFlow.create({
            align: "center",
            contents: "<form class=\"uploadButton\" method=\"POST\" id=\"form_file_JspAttachments\" action=\"\" enctype=\"multipart/form-data\"><label for=\"file_JspAttachments\" class=\"custom-file-upload\"><i class=\"fa fa-cloud-upload\"></i><spring:message code='file.upload'/></label><input id=\"file_JspAttachments\" type=\"file\" name=\"file[]\" name=\"file\" onchange=(function(){me.Upload_Changed_JspAttachments()})() /></form>"
        });

        this.DynamicForm_JspAttachments = isc.DynamicForm.create({
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
                    title: "<spring:message code='attach.file.format'/>",
                    required: true,
                    filterOnKeypress: true,
                    type: "ComboBoxItem",
                    defaultToFirstOption: true,
                    displayField: "titleFa",
                    valueField: "id",
                    addUnknownValues: false,
                    cachePickListResults: false,
                    useClientFiltering: true,
                    textAlign: "center",
                    filterFields: ["titleFa"],
                    sortField: ["id"],
                    textMatchStyle: "substring",
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

        this.IButton_Save_JspAttachments = isc.IButtonSave.create({
            top: 260,
            click: function () {
                if (!this.DynamicForm_JspAttachments.validate()) {
                    return;
                }
                if (this.methodAttachment === "POST") {
                    if (!isAttachedAttachment || document.getElementById('file_JspAttachments').files.length === 0) {
                        createDialog("info", "<spring:message code='file.not.uploaded'/>");
                        return;
                    }
                    if (document.getElementById('file_JspAttachments').files[0].size > this.maxFileSizeAttachment) {
                        createDialog("info", "<spring:message code='file.size.hint'/>");
                        return;
                    }
                    attachmentWait = createDialog("wait");
                      let formData1 = new FormData();

                let file = document.getElementById('file_JspAttachments').files[0];
                     formData1.append("file", file);

                         isc.RPCManager.sendRequest(TrDSRequest(getFmsConfig, "Get",  null, function (resp) {
                            let data= JSON.parse(resp.data)
                             MinIoUploadHttpRequest(formData1, data.url, data.groupId, me.save_result_Attachments_minIo);

                         }));
                } else if (this.methodAttachment === "PUT") {
                    attachmentWait = createDialog("wait");
                    let data = this.DynamicForm_JspAttachments.getValues();
                    if (this.ListGrid_JspAttachment.getSelectedRecord().fileName.split('.').length > 1)
                        data.fileName += "." + this.ListGrid_JspAttachment.getSelectedRecord().fileName.split('.')[1];
                    isc.RPCManager.sendRequest(TrDSRequest(this.saveActionUrlAttachment,
                        this.methodAttachment, JSON.stringify(data), this.save_result_Attachments));
                }
            }.bind(this)
        });

        this.IButton_Cancel_JspAttachments = isc.IButtonCancel.create({
            click: function () {
                this.DynamicForm_JspAttachments.clearValues();
                this.Window_JspAttachments.close();
            }.bind(this)
        });

        this.HLayout_SaveOrExit_JspAttachments = isc.TrHLayoutButtons.create({
            layoutMargin: 5,
            showEdges: false,
            edgeImage: "",
            padding: 10,
            members: [this.IButton_Save_JspAttachments, this.IButton_Cancel_JspAttachments]
        });

        this.VLayOut_Photo_JspAttachments = isc.TrVLayout.create({
            showEdges: false,
            edgeImage: "",
            align: "top",
            layoutMargin: 5,
            members: [
                this.DynamicForm_JspAttachments, this.Button_Upload_JspAttachments, this.Label_FileUploadSize_JspAttachments]
        });


        this.Window_JspAttachments = isc.Window.create({
            width: "400",
            align: "center",
            border: "1px solid gray",
            canDragResize: false,
            showMaximizeButton: false,
            items: [isc.TrVLayout.create({
                members: [this.VLayOut_Photo_JspAttachments, this.HLayout_SaveOrExit_JspAttachments]
            })]
        });

        //--------------------------------------------------------------------------------------------------------------------//
        /*Menu*/
        //--------------------------------------------------------------------------------------------------------------------//

        this.Menu_ListGrid_JspAttachments = isc.Menu.create({
            data: [
                <%--<sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_R','TclassAttachmentsTab_classStatus')">--%>
                <%--{--%>
                    <%--title: "<spring:message code='refresh'/>", click: function () {--%>
                        <%--this.ListGrid_Attachments_refresh();--%>
                    <%--}.bind(this)--%>
                <%--},--%>
                <%--</sec:authorize>--%>

                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_C','TclassAttachmentsTab_classStatus')">
                {
                    title: "<spring:message code='create'/>", click: function () {
                        if (objectIdAttachment == null) {
                            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                        }else
                        this.ListGrid_Attachments_Add();
                        }.bind(this)
                },
                </sec:authorize>


                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_U','TclassAttachmentsTab_classStatus')">
                {
                    title: "<spring:message code='edit'/>", click: function () {
                        this.ListGrid_Attachments_Edit();
                    }.bind(this)
                },
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_D','TclassAttachmentsTab_classStatus')">
                {
                    title: "<spring:message code='remove'/>", click: function () {
                        this.ListGrid_Attachments_Remove();
                    }.bind(this)
                },
                </sec:authorize>

                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_Download','TclassAttachmentsTab_classStatus')">
                {
                    title: "<spring:message code='download'/>", click: function () {
                        this.Show_Attachment_Attachments(this.ListGrid_JspAttachment.getSelectedRecord());
                    }.bind(this)
                }
                </sec:authorize>
            ]
        });

        this.Menu_ListGrid_ReadOnly_JspAttachments = isc.Menu.create({
            data: [{
                title: "<spring:message code='refresh'/>", click: function () {
                    this.ListGrid_Attachments_refresh();
                }.bind(this)
            }, {
                title: "<spring:message code='download'/>", click: function () {
                    this.Show_Attachment_Attachments(this.ListGrid_JspAttachment.getSelectedRecord());
                }.bind(this)
            }
            ]
        });

        this.ListGrid_JspAttachment = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource:this.RestDataSource_Attachments_JspAttachments,
            <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_R','TclassAttachmentsTab_classStatus')">
            contextMenu: this.Menu_ListGrid_JspAttachments,
            </sec:authorize>
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
                },
                {
                    hidden:true,
                    name: "key"
                }  ,
                {
                    hidden:true,
                    name: "group_id"
                }
            ],
            recordDoubleClick: function (viewer, record) {
                this.Show_Attachment_Attachments(record);
            }.bind(this)
        });


        this.ToolStripButton_Refresh_JspAttachment = isc.ToolStripButtonRefresh.create({
            click: function () {
                this.ListGrid_Attachments_refresh();
            }.bind(this)
        });


        this.ToolStripButton_Edit_JspAttachment = isc.ToolStripButtonEdit.create({
            click: function () {
                this.ListGrid_Attachments_Edit();
            }.bind(this)
        });


        this.ToolStripButton_Add_JspAttachment = isc.ToolStripButtonCreate.create({
            click: function () {
                if (objectIdAttachment == null) {
                    createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                }else
                this.ListGrid_Attachments_Add();
            }.bind(this)
        });


        this.ToolStripButton_Remove_JspAttachment = isc.ToolStripButtonRemove.create({
            click: function () {
                this.ListGrid_Attachments_Remove();
            }.bind(this)
        });


        this.ToolStrip_Actions_JspAttachment = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
            members:
                [
                    <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_C','TclassAttachmentsTab_classStatus')">
                    this.ToolStripButton_Add_JspAttachment,
                    </sec:authorize>

                    <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_U','TclassAttachmentsTab_classStatus')">
                    this.ToolStripButton_Edit_JspAttachment,
                    </sec:authorize>

                    <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_D','TclassAttachmentsTab_classStatus')">
                    this.ToolStripButton_Remove_JspAttachment,
                    </sec:authorize>

                    isc.ToolStripButtonExcel.create({
                        click: function () {

                            if (!(objectIdAttachment === undefined || objectIdAttachment == null)) {

                                let url= attachmentUrl + "/iscList/";

                                if (objectTypeAttachment != null)
                                    url += objectTypeAttachment;

                                url += ",";

                                if (objectTypeAttachment != null)
                                    url += objectIdAttachment;

                                ExportToFile.downloadExcelRestUrl(null, this.ListGrid_JspAttachment, url, 0, null, '', "پيوست ها", this.ListGrid_JspAttachment.getCriteria(), null);
                            }
                        }.bind(this)
                    }),

                    <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_R','TclassAttachmentsTab_classStatus')">
                    isc.ToolStrip.create({
                        width: "100%",
                        align: "left",
                        border: '0px',
                        members: [
                          //  this.ToolStripButton_Refresh_JspAttachment
                        ]
                    })
                    </sec:authorize>

                ]
        });

        this.HLayout_Actions_JspAttachment = isc.HLayout.create({
            width: "100%",
            members: [this.ToolStrip_Actions_JspAttachment]
        });

        this.HLayout_Grid_JspAttachment = isc.TrHLayout.create({
            members: [this.ListGrid_JspAttachment]
        });

        this.VLayout_Body_JspAttachment = isc.TrVLayout.create({
            members: [this.HLayout_Actions_JspAttachment,
                this.HLayout_Grid_JspAttachment
            ]
        });

        ///////////////////////////////////////////////////////functions///////////////////////////////////////

        this.ListGrid_Attachments_refresh = function ListGrid_Attachments_refresh() {
            this.ListGrid_JspAttachment.invalidateCache();
            this.ListGrid_JspAttachment.filterByEditor();
        }.bind(this)

        this.ListGrid_Attachments_Edit=function ListGrid_Attachments_Edit() {
            let record = this.ListGrid_JspAttachment.getSelectedRecord();
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {
                this.methodAttachment = "PUT";
                this.saveActionUrlAttachment = attachmentUrl + "/" + record.id;
                this.DynamicForm_JspAttachments.clearValues();
                this.DynamicForm_JspAttachments.editRecord(record);
                this.DynamicForm_JspAttachments.setValue("fileName", record.fileName.split('.')[0]);
                this.Button_Upload_JspAttachments.hide();
                this.Label_FileUploadSize_JspAttachments.hide();
                this.Window_JspAttachments.show();
            }
        }.bind(this)

        this.ListGrid_Attachments_Add=function ListGrid_Attachments_Add() {
            isAttachedAttachment = false;
            this.methodAttachment = "POST";
            this.saveActionUrlAttachment = attachmentUrl + "/upload";
            this.DynamicForm_JspAttachments.clearValues();
            this.Button_Upload_JspAttachments.show();
            this.Label_FileUploadSize_JspAttachments.show();
            this.Window_JspAttachments.show();
        }.bind(this)

        this.save_result_Attachments=function save_result_Attachments(resp) {
            let stat;
            let respText;
            attachmentWait.close();
            if (this.methodAttachment === "POST") {
                stat = resp.status;
                respText = resp.responseText;
            } else {
                stat = resp.httpResponseCode;
                respText = resp.httpResponseText;
            }
            if (stat === 200 || stat === 201) {
                let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
                this.ListGrid_Attachments_refresh();
                this.Window_JspAttachments.close();
                setTimeout(function () {
                    OK.close();
                }, 3000);
            } else {
                if (stat === 406 && respText === "DuplicateRecord") {
                    createDialog("info", "<spring:message code="msg.record.duplicate"/>");
                } else {
                    createDialog("info", "<spring:message code="msg.record.duplicate"/>");
                    <%--createDialog("info", "<spring:message code="msg.operation.error"/>");--%>
                }
            }
        }.bind(this)
        this.save_result_Attachments_minIo=function save_result_Attachments_minIo(resp) {
          let response=  JSON.parse(resp.response);
            if (response.status === 200) {

                let fileName = this.DynamicForm_JspAttachments.getValue("fileName");
                let file = document.getElementById('file_JspAttachments').files[0];

                if (file.name.split('.').length > 1)
                    fileName += "." + file.name.split('.')[1];

                let data = {};
                data.fileKey= response.key;
                data.objectType= objectTypeAttachment;
                data.objectId= objectIdAttachment;
                data.name= fileName;
                data.type= this.DynamicForm_JspAttachments.getValue("fileTypeId");
                data.description= this.DynamicForm_JspAttachments.getValue("description");
                 isc.RPCManager.sendRequest(TrDSRequest(uploadFms, "POST",  JSON.stringify(data), function (resp) {
                     attachmentWait.close();
                     responseStatus = JSON.parse(resp.httpResponseText).status;
                                if (responseStatus === 200 || responseStatus === 201) {
                let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");

                                    me.ListGrid_Attachments_refresh();
                                    me.Window_JspAttachments.close();
                setTimeout(function () {
                    OK.close();
                }, 3000);
                                } else {
                                    if (responseStatus === 404)
                                    {
                                        createDialog("info", "<spring:message code="upload.failed.duplicate"/>");
                                    }
                                    else
                                    {
                                        createDialog("info", "<spring:message code="upload.failed"/>");
                                    }
                                }
                            }));
            } else {
                attachmentWait.close();
                    createDialog("info", "<spring:message code="upload.failed"/>");
            }
        }.bind(this)

        this.ListGrid_Attachments_Remove=function ListGrid_Attachments_Remove() {
            let record = this.ListGrid_JspAttachment.getSelectedRecord();
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
                                "callback: me.remove_result_Attachments(rpcResponse)"));
                        }
                    }
                });
            }
        }.bind(this)

        this.remove_result_Attachments=function remove_result_Attachments(resp) {
            attachmentWait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                this.ListGrid_Attachments_refresh();
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
        }.bind(this)

        this.Show_Attachment_Attachments=function Show_Attachment_Attachments(record) {
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

        this.Upload_Changed_JspAttachments=function Upload_Changed_JspAttachments() {
            if (document.getElementById('file_JspAttachments').files.length === 0)
                return;
            if (document.getElementById('file_JspAttachments').files[0].size > this.maxFileSizeAttachment) {
                createDialog("info", "<spring:message code='file.size.hint'/>");
                this.DynamicForm_JspAttachments.getItem("fileName").setValue("");
                return;
            }
            isAttachedAttachment = true;
            let fileName = document.getElementById('file_JspAttachments').files[0].name;
            if (this.DynamicForm_JspAttachments.getValue("fileName") === undefined) {
                this.DynamicForm_JspAttachments.getItem("fileName").setValue(fileName.split('.')[0]);
            }
        }

        this.loadPage_attachment=function loadPage_attachment(inputObjectType, inputObjectId, inputTitleAttachment, valueMap_EAttachmentType, readOnly = false, criteria = null) {

             let classRecord = inputObjectId;
            //me.VLayout_Body_JspAttachment.redraw();
            objectTypeAttachment = inputObjectType;
            objectIdAttachment = inputObjectId;
            this.RestDataSource_Attachments_JspAttachments.fetchDataURL = attachmentUrl + "/iscList/";

            if (objectTypeAttachment != null)
                this.RestDataSource_Attachments_JspAttachments.fetchDataURL += objectTypeAttachment;

            this.RestDataSource_Attachments_JspAttachments.fetchDataURL += ",";

            if (objectTypeAttachment != null)
                this.RestDataSource_Attachments_JspAttachments.fetchDataURL += objectIdAttachment;

            this.ListGrid_JspAttachment.getField("fileTypeId").valueMap = valueMap_EAttachmentType;
            this.DynamicForm_JspAttachments.getField("fileTypeId").valueMap = valueMap_EAttachmentType;
            this.Window_JspAttachments.title = inputTitleAttachment;
            this.ListGrid_JspAttachment.setImplicitCriteria(criteria);
            this.ListGrid_JspAttachment.fetchData(criteria);
            this.ListGrid_Attachments_refresh();
            // if (readOnly) {
            //     ToolStripButton_Edit_JspAttachment.hide();
            //     ToolStripButton_Add_JspAttachment.hide();
            //     ToolStripButton_Remove_JspAttachment.hide();
            //     ListGrid_JspAttachment.contextMenu = Menu_ListGrid_ReadOnly_JspAttachments;
            // } else {
            //     ToolStripButton_Edit_JspAttachment.show();
            //     ToolStripButton_Add_JspAttachment.show();
            //     ToolStripButton_Remove_JspAttachment.show();
            //     ListGrid_JspAttachment.contextMenu = Menu_ListGrid_JspAttachments;
            // }
            if (classRecord.classStatus === "3") {
                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_C','TclassAttachmentsTab_R','TclassAttachmentsTab_U','TclassAttachmentsTab_D')">
                this.ToolStrip_Actions_JspAttachment.setVisibility(false)
                this.ListGrid_JspAttachment.contextMenu = null;
                </sec:authorize>
            } else {
                <sec:authorize access="hasAnyAuthority('TclassAttachmentsTab_C','TclassAttachmentsTab_R','TclassAttachmentsTab_U','TclassAttachmentsTab_D')">
                this.ToolStrip_Actions_JspAttachment.setVisibility(true)
                this.ListGrid_JspAttachment.contextMenu = this.Menu_ListGrid_JspAttachments;
                </sec:authorize>
            }
            if (classRecord.classStatus === "3") {
                <sec:authorize access="hasAuthority('TclassAttachmentsTab_classStatus')">
                this.ToolStrip_Actions_JspAttachment.setVisibility(true)
                this.ListGrid_JspAttachment.contextMenu = this.Menu_ListGrid_JspAttachments;
                </sec:authorize>
            }
        }.bind(this)

        this.loadPage_attachment_Job=function loadPage_attachment(inputObjectType, inputObjectId, inputTitleAttachment, valueMap_EAttachmentType, readOnly = false, criteria = null) {
            this.VLayout_Body_JspAttachment.redraw();
            objectTypeAttachment = inputObjectType;
            objectIdAttachment = inputObjectId;
            this.RestDataSource_Attachments_JspAttachments.fetchDataURL = attachmentUrl + "/iscList/";
            if (inputObjectType != null)
            this.RestDataSource_Attachments_JspAttachments.fetchDataURL += inputObjectType;
            this.RestDataSource_Attachments_JspAttachments.fetchDataURL += ",";
            if (inputObjectType != null)
                this.RestDataSource_Attachments_JspAttachments.fetchDataURL += objectIdAttachment;
            this.ListGrid_JspAttachment.getField("fileTypeId").valueMap = valueMap_EAttachmentType;
            this.DynamicForm_JspAttachments.getField("fileTypeId").valueMap = valueMap_EAttachmentType;
            this.Window_JspAttachments.title = inputTitleAttachment;
            this.ListGrid_JspAttachment.setImplicitCriteria(criteria);
            this.ListGrid_JspAttachment.fetchData(criteria);
            this.ListGrid_Attachments_refresh();

        }.bind(this)

        this.clear_Attachments=function clear_Attachments() {
            this.ListGrid_JspAttachment.clear();
        }.bind(this)


        function test() {

           let downloadForm = isc.DynamicForm.create({
                    method: "GET",
                    action: "attachment/download/" + 5,
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

    }

    //</script>