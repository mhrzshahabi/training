<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

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
            {name: "id", hidden: true},
            {name: "name"},
            {name: "nationalCode"},
            {name: "type"},
            {name: "status"},
            {name: "text"},
            {name: "response"},
            {name: "fmsReference", hidden: true},
            {name: "groupId", hidden: true},
            {name: "reference", hidden: true}
        ]
    });

    VLayout_Body_ULR = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_Request,
            ListGrid_Request
        ]
    });

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

    // </script>