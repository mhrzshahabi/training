<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken2 = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    let oLoadAttachments_request;
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Request = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "text", title: "متن درخواست", filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملی", filterOperator: "iContains"},
            {name: "name", title: "نام", filterOperator: "iContains"},
            {name: "response", title: "پاسخ", filterOperator: "iContains"},
            {name: "fmsReference", title: "fmsReference", hidden: true},
            {name: "groupId", title: "groupId", hidden: true},
            {name: "type", title: "نوع درخواست", valueMap: {PROTEST: "PROTEST"}},
            {name: "status", title: "وضعیت", valueMap: {ACTIVE: "ACTIVE", PENDING: "PENDING", CLOSED: "CLOSED", PROCESSING: "PROCESSING"}},
            {name: "reference", title: "reference", filterOperator: "iContains"}


        ],
        fetchDataURL: requestUrl + "/list"
    });

    //---------------------------------------------------Request Window-------------------------------------------------
    Save_Button_Add_Response = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            saveRequestResponse();
        }
    });
    Cancel_Button_Add_Response = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_Request.close();
        }
    });
    HLayout_IButtons_Request = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Save_Button_Add_Response,
            Cancel_Button_Add_Response
        ]
    });

    DynamicForm_Request = isc.DynamicForm.create({
        width: 600,
        height: 300,
        numCols: 4,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "name",
                title: "نام",
                canEdit: false
            },
            {
                name: "nationalCode",
                title: "کدملی",
                canEdit: false
            },
            {
                name: "type",
                title: "نوع درخواست",
                canEdit: false,
                valueMap: {
                    PROTEST: "PROTEST"
                }
            },
            {
                name: "status",
                title: "وضعیت",
                canEdit: true,
                valueMap: {
                    ACTIVE: "ACTIVE",
                    PENDING: "PENDING",
                    CLOSED: "CLOSED",
                    PROCESSING: "PROCESSING"
                }
            },

            {
                name: "response",
                title: "پاسخ",
                required: true,
                editorType: "textArea",
                width: "100%",
                height: 200,
                colSpan: 4
            },
            {
                name: "text",
                title: "متن درخواست",
                canEdit: false,
                editorType: "textArea",
                width: "100%",
                height: 200,
                colSpan: 4
            },
        ]
    });
    Window_Request = isc.Window.create({
        title: "پاسخ دهی به درخواست",
        width: 600,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Request,
            HLayout_IButtons_Request
        ]
    });
    //------------------------------------tabSet------------------------------------------------------------------------
    var TabSet_request = isc.TabSet.create({
        enabled: false,
        tabBarPosition: "top",
        tabs: [

            {
                ID: "requestAttachmentsTab",
                name: "requestAttachmentsTab",
                title: "<spring:message code="attachmentAnswer"/>",
            }
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
        }
    });


    //----------------------------------- layOut -----------------------------------------------------------------------
    ToolStripButton_Add_Request = isc.ToolStripButton.create({
        title: "پاسخ دهی به درخواست",
        click: function () {
            responseToRequest();
        }
    });
    ToolStripButton_History_Request = isc.ToolStripButton.create({
        title: "تاریخچه درخواست",
        click: function () {
             historyOfRequest();
        }
    });

    ToolStripButton_Excel_Request = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });
    ToolStripButton_Refresh_Request = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Request.invalidateCache();
        }
    });
    ToolStrip_Actions_Request = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_Request,
                ToolStripButton_History_Request,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_Request,
                        ToolStripButton_Excel_Request
                    ]
                })
            ]
    });

    ListGrid_Request = isc.TrLG.create({
        height: "90%",
        filterOnKeypress: false,
        showFilterEditor: true,
        autoFetchData: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_Request,
        initialSort: [
            {property: "type", direction: "ascending"}
        ],
        fields: [
            {name: "id",primaryKey: true,hidden: true},
            {name: "name"},
            {name: "nationalCode"},
            {name: "type"},
            {name: "status"},
            {name: "text"},
            {name: "response"},
            {name: "fmsReference", hidden: true},
            {name: "groupId", hidden: true},
            {name: "reference", hidden: true},
            {
                name: "requestContent",
                title: "محتوای درخواست",
                align: "center",
                canFilter: false
            }
        ],
        selectionUpdated: function (record) {
            loadRequestAttachment();
        },

        createRecordComponent: function (record, colNum) {

            var fieldName = this.getFieldName(colNum);
            if (record == null || fieldName != "requestContent")
                return null;

            return isc.IButton.create({
                layoutAlign: "center",
                title: "محتوای درخواست",
                width: "120",
                margin: 3,
                click: function () {
                     getRequestContent(record.id);
                }
            });
        }


    });
    let HLayout_Tab_request = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "39%",
        members: [TabSet_request]
    });

    VLayout_Body_ULR = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_Request,
            ListGrid_Request,
            HLayout_Tab_request
        ]
    });
    if (!loadjs.isDefined('load_Attachments')) {
        loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments');
    }

    setTimeout(function () {
        loadjs.ready('load_Attachments', function () {
            oLoadAttachments_request = new loadAttachments();
            TabSet_request.updateTab("requestAttachmentsTab", oLoadAttachments_request.VLayout_Body_JspAttachment)
        });
    }, 0);

    //------------------------------------------------- Functions ------------------------------------------------------

    function responseToRequest() {

        let record = ListGrid_Request.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            DynamicForm_Request.editRecord(record);
            Window_Request.show();
        }
    }
    function historyOfRequest(){
        let record = ListGrid_Request.getSelectedRecord();
        <%--title: "<spring:message code='request.history'/>"--%>
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            if (mainTabSet.getTab("<spring:message code='request.history'/>") != null)
                mainTabSet.removeTab("<spring:message code='request.history'/>")
           createTab("<spring:message code='request.history'/>","<spring:url value="web/requestHistoryReport"/>");
        }



    }


    function saveRequestResponse() {

        if (!DynamicForm_Request.validate()) {
            return;
        } else {

            let record = DynamicForm_Request.getValues();
            let data = {};
            data.reference = record.reference;
            data.response = record.response;
            data.requestStatus = record.status;

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(requestUrl + "/answer" , "POST", JSON.stringify(data), function (resp) {
                wait.close();
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_Request.close();
                    ListGrid_Request.invalidateCache();
                } else {
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }
            }));
        }
    }

    function makeExcelOutput() {

        if (ListGrid_Request.getData().localData.length === 0)
            createDialog("info", "داده ای برای خروجی اکسل وجود ندارد");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Request, requestUrl + "/all", 0, null, '',"گزارش درخواست ها"  , null, null);
    }
    function loadRequestAttachment() {

        let record =  ListGrid_Request.getSelectedRecord();
        let valueMap_AttachmentType;
        if (record === null) {
            TabSet_request.disable();
            oLoadAttachments_request.loadPage_attachment_Job("Request", 0, "<spring:message code="document"/>", {
                1: "درخواست",
            });

            return;
        } else {

            valueMap_AttachmentType = {
                1: "درخواست",
            };

            oLoadAttachments_request.ToolStripButton_Edit_JspAttachment.enable();
            oLoadAttachments_request.ToolStripButton_Add_JspAttachment.enable();
            oLoadAttachments_request.ToolStripButton_Remove_JspAttachment.enable();

        }

        oLoadAttachments_request.ListGrid_JspAttachment.getField("fileTypeId").valueMap = valueMap_AttachmentType;
        oLoadAttachments_request.DynamicForm_JspAttachments.getField("fileTypeId").setValueMap(valueMap_AttachmentType);
        oLoadAttachments_request.loadPage_attachment_Job("Request",ListGrid_Request.getSelectedRecord().id, "<spring:message code="document"/>", valueMap_AttachmentType, false);
        TabSet_request.enable();
    }
    function getRequestContent(requestId) {

        isc.RPCManager.sendRequest(TrDSRequest(attachmentUrl + "/findAllRequest/" + requestId , "GET", null, function (resp) {
            if(resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let content = JSON.parse(resp.httpResponseText);
                showRequestResponseContent(content);

            } else {
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }
        }));
    }
    function downloadRequestContentFile(groupId, key, fileName) {

        let downloadForm = isc.DynamicForm.create({
            method: "GET",
            action: "minIo/downloadFile/" + groupId + "/" + key + "/" + fileName,
            target: "_Blank",
            canSubmit: true,
            fields: [
                {name: "token", type: "hidden"}
            ]
        });
        downloadForm.setValue("token", "<%=accessToken2%>");
        downloadForm.show();
        downloadForm.submitForm();
    }
    // --------------------------------------------- create- request content-------------------------------------------------

    function showRequestResponseContent(content) {
        let RestDataSource_Request_Content = isc.TrDS.create({
            fields: [
                {name: "fileKey", title: "fileKey"},
                {name: "name", title: "name"},
                {name: "type", title: "type"},
                {name: "objectType", title: "objectType"},
                {name: "objectId",title: "objectId"},
                {name: "FmsGroup",title: "FmsGroup"}

            ]
        });

        let ListGrid_Request_Content = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_Request_Content,
            showFilterEditor: false,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            fields: [
                {
                    name: "name",
                    title: "نام فایل",
                    align: "center"
                },
                {
                    name: "download",
                    title: "دریافت فایل",
                    align: "center",
                    canFilter: false
                }
            ],
            createRecordComponent: function (record, colNum) {

                var fieldName = this.getFieldName(colNum);
                if (record == null || fieldName != "download")
                    return null;

                return isc.ToolStripButton.create({
                    icon: "[SKIN]actions/download.png",
                    width: "25",
                    click: function () {

                        if (record == null) {return;}
                        downloadRequestContentFile(record.fileKey, record.FmsGroup, record.name);
                    }
                });
            }
        });

        let Window_Request_Content = isc.Window.create({
            title: "نمایش محتوای درخواست",
            width: "20%",
            height: "40%",
            autoSize: false,
            items: [ListGrid_Request_Content]
        });

        ListGrid_Request_Content.setData(content);
        Window_Request_Content.show();
    }



    // </script>