<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
                name: "text",
                title: "متن درخواست",
                canEdit: false,
                editorType: "textArea",
                width: "100%",
                height: 200,
                colSpan: 4
            },
            {
                name: "response",
                title: "پاسخ",
                required: true,
                editorType: "textArea",
                width: "100%",
                height: 200,
                colSpan: 4
            }
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
                title: "<spring:message code="attachments"/>",
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
            {name: "reference", hidden: true}
        ],
        selectionUpdated: function (record) {
            loadRequestAttachment();
        },

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

    // </script>