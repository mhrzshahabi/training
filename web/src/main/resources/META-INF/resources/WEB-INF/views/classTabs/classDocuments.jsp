<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var RestDataSource_Refrence_JspClassDocuments  = isc.TrDS.create({
        fields: [{name: "id"}, {name: "title"}
        ],
        fetchDataURL: parameterValueUrl  + "/iscList/338"
    });

    var RestDataSource_LetterType_JspClassDocuments  = isc.TrDS.create({
        fields: [{name: "id"}, {name: "title"}
        ],
        fetchDataURL: parameterValueUrl  + "/iscList/339"
    });

    var RestDataSource_Document_JspClassDocuments = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "classId"},
            {name: "letterNum"},
            {name: "letterTypeId"},
            {name: "referenceId"}
        ]
    });

    DynamicForm_JspClassDocuments = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        fields: [
            {name: "id", hidden: true},
            {
                name: "referenceId",
                title: "فیلد مرجع",
                required: true,
                type: "SelectItem",
                pickListProperties: {
                    showFilterEditor: false
                },
                filterOperator: "equals",
                changeOnKeypress: true,
                displayField: "title",
                valueField: "id",
                defaultValue: 476,
                optionDataSource: RestDataSource_Refrence_JspClassDocuments,
                cachePickListResults: true,
                useClientFiltering: true,
                pickListFields: [
                    {name: "title", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "letterTypeId",
                title: "نوع نامه",
                type: "SelectItem",
                pickListProperties: {
                    showFilterEditor: false
                },
                filterOperator: "equals",
                changeOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: RestDataSource_LetterType_JspClassDocuments,
                cachePickListResults: true,
                useClientFiltering: true,
                pickListFields: [
                    {name: "title", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "letterNum",
                title: "شماره نامه",
                required: true,
                length: 15,
                keyPressFilter:"[0-9 ]"
            }
        ]
    });

    IButton_Save_JspClassDocuments = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspClassDocuments.validate()) {
                return;
            }
            if (methodClassDocument === "POST") {
                if (!isAttachedClassDocument || document.getElementById('file_JspClassDocuments').files.length === 0) {
                    createDialog("info", "<spring:message code='file.not.uploaded'/>");
                    return;
                }
                if (document.getElementById('file_JspClassDocuments').files[0].size > maxFileSizeClassDocument) {
                    createDialog("info", "<spring:message code='file.size.hint'/>");
                    return;
                }
                classDocumentWait = createDialog("wait");
                let formData1 = new FormData();
                let file = document.getElementById('file_JspClassDocuments').files[0];
                let fileName = DynamicForm_JspClassDocuments.getValue("fileName");
                if (file.name.split('.').length > 1)
                    fileName += "." + file.name.split('.')[1];
                formData1.append("file", file);
                formData1.append("objectType", objectTypeClassDocument);
                formData1.append("objectId", objectIdClassDocument);
                formData1.append("fileName", fileName);
                formData1.append("fileTypeId", DynamicForm_JspClassDocuments.getValue("fileTypeId"));
                formData1.append("description", DynamicForm_JspClassDocuments.getValue("description"));
                TrnXmlHttpRequest(formData1, saveActionUrlClassDocument, methodClassDocument, save_result_ClassDocuments);
            } else if (methodClassDocument === "PUT") {
                classDocumentWait = createDialog("wait");
                let data = DynamicForm_JspClassDocuments.getValues();
                if (ListGrid_JspClassDocuments.getSelectedRecord().fileName.split('.').length > 1)
                    data.fileName += "." + ListGrid_JspClassDocuments.getSelectedRecord().fileName.split('.')[1];
                isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlClassDocument,
                    methodClassDocument, JSON.stringify(data), save_result_ClassDocuments));
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
        dataSource:RestDataSource_Document_JspClassDocuments,
        selectionType: "single",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showRollOver: true,
        fields: [
            {name: "id", hidden: true},
            {
                name: "referenceId",
                title: "فیلد مرجع",
                type: "SelectItem",
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }},
                filterOperator: "equals",
                changeOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: RestDataSource_Refrence_JspClassDocuments
            },
            {
                name: "letterTypeId",
                title: "نوع نامه",
                type: "SelectItem",
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }},
                filterOperator: "equals",
                changeOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: RestDataSource_LetterType_JspClassDocuments
            },
            {
                name: "letterNum",
                title: "شماره نامه",
                filterOperator: "iContains"
            }
        ]
    });

    ToolStripButton_Refresh_JspClassDocuments = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_ClassDocuments_refresh();
        }
    });

    ToolStripButton_Edit_JspClassDocuments = isc.ToolStripButtonEdit.create({
        click: function () {
            // ListGrid_ClassDocuments_Edit();
        }
    });

    ToolStripButton_Add_JspClassDocuments = isc.ToolStripButtonCreate.create({
        click: function () {
            // ListGrid_ClassDocuments_Add();
        }
    });

    ToolStripButton_Remove_JspClassDocuments = isc.ToolStripButtonRemove.create({
        click: function () {
            // ListGrid_ClassDocuments_Remove();
        }
    });

    ToolStrip_Actions_JspClassDocuments = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspClassDocuments,
                ToolStripButton_Edit_JspClassDocuments,
                ToolStripButton_Remove_JspClassDocuments,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspClassDocuments
                    ]
                })
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

    function ListGrid_ClassDocuments_refresh() {
        ListGrid_JspClassDocuments.invalidateCache();
        ListGrid_JspClassDocuments.filterByEditor();
    }

    function ListGrid_ClassDocuments_Edit() {
        let record = ListGrid_JspClassDocuments.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodClassDocument = "PUT";
            saveActionUrlClassDocument = classDocumentUrl + "/" + record.id;
            DynamicForm_JspClassDocuments.clearValues();
            DynamicForm_JspClassDocuments.editRecord(record);
            DynamicForm_JspClassDocuments.setValue("fileName", record.fileName.split('.')[0]);
            Window_JspClassDocuments.show();
        }
    }

    function ListGrid_ClassDocuments_Add() {
        isAttachedClassDocument = false;
        methodClassDocument = "POST";
        saveActionUrlClassDocument = classDocumentUrl + "/upload";
        DynamicForm_JspClassDocuments.clearValues();
        Window_JspClassDocuments.show();
    }

    function save_result_ClassDocuments(resp) {
        let stat;
        let respText;
        classDocumentWait.close();
        if (methodClassDocument === "POST") {
            stat = resp.status;
            respText = resp.responseText;
        } else {
            stat = resp.httpResponseCode;
            respText = resp.httpResponseText;
        }
        if (stat === 200 || stat === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            ListGrid_ClassDocuments_refresh();
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

    function ListGrid_ClassDocuments_Remove() {
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
                        classDocumentWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(classDocumentUrl + "/delete/" + record.id, "DELETE", null,
                            "callback: remove_result_ClassDocuments(rpcResponse)"));
                    }
                }
            });
        }
    }

    function remove_result_ClassDocuments(resp) {
        classDocumentWait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_ClassDocuments_refresh();
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

    function Show_ClassDocument_ClassDocuments(record) {
        let downloadForm = isc.DynamicForm.create({
            method: "GET",
            action: "classDocument/download/" + record.id,
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

    function loadPage_classDocuments(classId){
        RestDataSource_Document_JspClassDocuments.fetchDataURL = classDocumentUrl  + "iscList/" + classId;
        ListGrid_JspClassDocuments.invalidateCache();
        ListGrid_JspClassDocuments.fetchData();
    }

    function clear_ClassDocuments() {
        ListGrid_JspClassDocuments.clear();
    }

    //</script>