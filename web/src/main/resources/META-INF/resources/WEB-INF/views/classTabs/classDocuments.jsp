<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

var tclassId;
var methodClassDocument;
var saveActionUrlClassDocument;
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
            {name: "referenceId"},
            {name: "description"}
        ]
    });

    DynamicForm_JspClassDocuments = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        fields: [
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
            },
            {
                name: "description",
                showHintInField: true,
                title: "<spring:message code='description'/>",
                height: "40",
                length: "350", width: "*",
                type: 'areaText'
            },
            {
                name: "classId",
                hidden: true
            }
        ]
    });

    IButton_Save_JspClassDocuments = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspClassDocuments.validate()) {
                return;
            }
            else if (methodClassDocument === "POST") {
                DynamicForm_JspClassDocuments.getField("classId").setValue(tclassId);
                let data = DynamicForm_JspClassDocuments.getValues();
                isc.RPCManager.sendRequest(TrDSRequest(classDocumentUrl + "checkLetterNum/" + tclassId + "/" + data.letterNum, "GET", null, function (resp) {

                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        let canAttach = JSON.parse(resp.httpResponseText);
                        if (canAttach === false) {
                            createDialog("info", "این شماره نامه پیش تر ثبت شده است");
                            return;
                        } else {
                            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlClassDocument,
                                methodClassDocument, JSON.stringify(data), function (resp) {
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        var OK = isc.Dialog.create({
                                            message: "عملیات با موفقیت انجام شد.",
                                            icon: "[SKIN]say.png",
                                            title: "انجام فرمان"
                                        });
                                        setTimeout(function () {
                                            OK.close();
                                        }, 3000);
                                        Window_JspClassDocuments.close();
                                        ListGrid_JspClassDocuments.invalidateCache();
                                    } else {
                                        var ERROR = isc.Dialog.create({
                                            message: ("خطا در ایجاد مستند کلاس"),
                                            icon: "[SKIN]stop.png",
                                            title: "توجه"
                                        });
                                        setTimeout(function () {
                                            ERROR.close();
                                        }, 3000);
                                    }
                                }));
                        }
                    } else {
                        createDialog("info", "خطایی رخ داده است");
                    }
                }));
            }
            else if (methodClassDocument === "PUT") {
                let data = DynamicForm_JspClassDocuments.getValues();
                if (ListGrid_JspClassDocuments.getSelectedRecord().letterNum === data.letterNum) {
                    isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlClassDocument,
                        methodClassDocument, JSON.stringify(data), function (resp) {

                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                var OK = isc.Dialog.create({
                                    message: "عملیات با موفقیت انجام شد.",
                                    icon: "[SKIN]say.png",
                                    title: "انجام فرمان"
                                });
                                setTimeout(function () {
                                    OK.close();
                                }, 3000);
                                Window_JspClassDocuments.close();
                                ListGrid_JspClassDocuments.invalidateCache();
                            }
                            else {
                                var ERROR = isc.Dialog.create({
                                    message: ("خطا در ویرایش مستند کلاس"),
                                    icon: "[SKIN]stop.png",
                                    title: "توجه"
                                });
                                setTimeout(function () {
                                    ERROR.close();
                                }, 3000);
                            }

                        }));
                } else {

                    isc.RPCManager.sendRequest(TrDSRequest(classDocumentUrl + "checkLetterNum/" + tclassId + "/" + data.letterNum, "GET", null, function (resp) {

                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            let canAttach = JSON.parse(resp.httpResponseText);
                            if (canAttach === false) {
                                createDialog("info", "این شماره نامه پیش تر ثبت شده است");
                                return;
                            } else {
                                isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlClassDocument,
                                    methodClassDocument, JSON.stringify(data), function (resp) {

                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                            var OK = isc.Dialog.create({
                                                message: "عملیات با موفقیت انجام شد.",
                                                icon: "[SKIN]say.png",
                                                title: "انجام فرمان"
                                            });
                                            setTimeout(function () {
                                                OK.close();
                                            }, 3000);
                                            Window_JspClassDocuments.close();
                                            ListGrid_JspClassDocuments.invalidateCache();
                                        }
                                        else {
                                            var ERROR = isc.Dialog.create({
                                                message: ("خطا در ویرایش مستند کلاس"),
                                                icon: "[SKIN]stop.png",
                                                title: "توجه"
                                            });
                                            setTimeout(function () {
                                                ERROR.close();
                                            }, 3000);
                                        }
                                }));
                            }
                        } else {
                            createDialog("info", "خطایی رخ داده است");
                        }
                    }));
                }
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

    VLayOut_Form_JspClassDocuments = isc.TrVLayout.create({
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
        title: "مستندات کلاس",
        items: [isc.TrVLayout.create({
            members: [VLayOut_Form_JspClassDocuments, HLayout_SaveOrExit_JspClassDocuments]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_JspClassDocuments = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Document_JspClassDocuments,
        selectionType: "single",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showRollOver: true,
        filterOnKeypress: true,
        fields: [
            {name: "id", hidden: true},
            {
                name: "referenceId",
                title: "فیلد مرجع",
                type: "SelectItem",
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },
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
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },
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
            },
            {
                name: "description",
                title: "<spring:message code='description'/>",
                filterOperator: "iContains"
            },
            {
                name: "classId",
                hidden: true
            }
        ]
    });

    ToolStripButton_Refresh_JspClassDocuments = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_JspClassDocuments.invalidateCache();
            ListGrid_JspClassDocuments.filterByEditor();
        }
    });

    ToolStripButton_Edit_JspClassDocuments = isc.ToolStripButtonEdit.create({
        click: function () {
            let record = ListGrid_JspClassDocuments.getSelectedRecord();
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {
                methodClassDocument = "PUT";
                saveActionUrlClassDocument = classDocumentUrl + record.id;
                DynamicForm_JspClassDocuments.clearValues();
                DynamicForm_JspClassDocuments.editRecord(record);
                Window_JspClassDocuments.show();
            }
        }
    });

    ToolStripButton_Add_JspClassDocuments = isc.ToolStripButtonCreate.create({
        click: function () {
            methodClassDocument = "POST";
            saveActionUrlClassDocument = classDocumentUrl;
            DynamicForm_JspClassDocuments.clearValues();
            Window_JspClassDocuments.show();
        }
    });

    ToolStripButton_Remove_JspClassDocuments = isc.ToolStripButtonRemove.create({
        click: function () {
            let record = ListGrid_JspClassDocuments.getSelectedRecord();
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {
                let Dialog_Class_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                    "<spring:message code="verify.delete"/>");
                Dialog_Class_remove.addProperties({
                    buttonClick: function (button, index) {
                        this.close();
                        if (index === 0) {
                            methodClassDocument = "DELETE";
                            saveActionUrlClassDocument = classDocumentUrl + record.id;
                            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlClassDocument,
                                methodClassDocument, null, function (resp) {
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        var OK = isc.Dialog.create({
                                            message: "ركورد با موفقيت حذف گرديد",
                                            icon: "[SKIN]say.png",
                                            title: "انجام فرمان"
                                        });
                                        setTimeout(function () {
                                            OK.close();
                                        }, 3000);
                                        Window_JspClassDocuments.close();
                                        ListGrid_JspClassDocuments.invalidateCache();
                                    }
                                    else {
                                        var ERROR = isc.Dialog.create({
                                            message: ("خطا در حذف مستند کلاس"),
                                            icon: "[SKIN]stop.png",
                                            title: "توجه"
                                        });
                                        setTimeout(function () {
                                            ERROR.close();
                                        }, 3000);
                                    }

                                }));
                        }
                    }
                });
            }
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
                isc.ToolStripButtonExcel.create({
                    click: function () {

                        let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                        if (!(classRecord === undefined || classRecord == null)) {
                            ExportToFile.downloadExcelRestUrl(null, ListGrid_JspClassDocuments, classDocumentUrl  + "iscList/" + classRecord.id, 0, ListGrid_Class_JspClass, '', "کلاس - مستندات کلاس", ListGrid_JspClassDocuments.getCriteria(), null);
                        }
                    }
                }),
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
        members: [
            HLayout_Actions_JspClassDocuments,
            HLayout_Grid_JspClassDocuments
        ]
    });

    ///////////////////////////////////////////////////////functions///////////////////////////////////////
    function loadPage_classDocuments(classId){
        RestDataSource_Document_JspClassDocuments.fetchDataURL = classDocumentUrl  + "iscList/" + classId;
        ListGrid_JspClassDocuments.invalidateCache();
        ListGrid_JspClassDocuments.fetchData();
        tclassId = classId;
    }

    function clear_ClassDocuments() {
        ListGrid_JspClassDocuments.clear();
    }

    //</script>