<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let reportCriteria_ULR = null;
    let helpFileMethod = "POST";
    let maxFileSizeUpload = 31457280;
    let isFileAttached = false;

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Help_Files = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "fileName", title: "<spring:message code="file.name"/>", filterOperator: "iContains"},
            {name: "fileLabels", title: "<spring:message code="file.label"/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
            {name: "group_id", title: "groupId", hidden: true},
            {name: "key", title: "key", hidden: true}
        ],
        fetchDataURL: helpFilesUrl + "/list"
    });

    RestDataSource_File_Labels = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "labelName", title: "<spring:message code="file.label"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: fileLabelUrl + "/list"
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    ToolStripButton_Help_Files_Add = isc.ToolStripButtonCreate.create({
        click: function () {
            Help_Files_Add();
        }
    });
    ToolStripButton_Help_Files_Edit = isc.ToolStripButtonEdit.create({
        click: function () {
            Help_Files_Edit();
        }
    });
    ToolStripButton_Help_Files_Remove = isc.ToolStripButtonRemove.create({
        click: function () {
            Help_Files_Remove();
        }
    });
    ToolStripButton_Help_Files_Label = isc.ToolStripButton.create({
        title: "مدیریت برچسب ها",
        click: function () {
            File_Label_Manage();
        }
    });
    ToolStripButton_Help_Files_Download = isc.IButton.create({
        title: "دانلود فایل",
        click: function () {
            Help_Files_Download();
        }
    });
    ToolStripButton_Help_Files_Label_Filter = isc.IButton.create({
        title: "فیلتر برچسب ها",
        click: function () {
            Help_Files_Label_Filter();
        }
    });
    ToolStripButton_Help_Files_Label_Clear_Filter = isc.IButton.create({
        title: "پاک کردن فیلتر",
        click: function () {
            Help_Files_Label_Clear_Filter();
        }
    });
    ToolStripButton_Help_Files_Refresh = isc.ToolStripButtonRefresh.create({
        click: function () {
            Help_Files_Refresh();
        }
    });
    ToolStrip_Actions_Help_Files = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                <sec:authorize access="hasAuthority('HelpFiles_C')">
                ToolStripButton_Help_Files_Add,
                </sec:authorize>
                <sec:authorize access="hasAuthority('HelpFiles_U')">
                ToolStripButton_Help_Files_Edit,
                </sec:authorize>
                <sec:authorize access="hasAuthority('HelpFiles_D')">
                ToolStripButton_Help_Files_Remove,
                </sec:authorize>
                <sec:authorize access="hasAuthority('FileLabel_C')">
                ToolStripButton_Help_Files_Label,
                </sec:authorize>
                <sec:authorize access="hasAuthority('HelpFiles_Download')">
                ToolStripButton_Help_Files_Download,
                </sec:authorize>
                <sec:authorize access="hasAuthority('HelpFiles_R')">
                ToolStripButton_Help_Files_Label_Filter,
                ToolStripButton_Help_Files_Label_Clear_Filter,
                </sec:authorize>
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        <sec:authorize access="hasAuthority('HelpFiles_R')">
                        ToolStripButton_Help_Files_Refresh
                        </sec:authorize>
                    ]
                })
            ]
    });

    ListGrid_Help_Files = isc.TrLG.create({
        height: "90%",
        autoFetchData: true,
        showFilterEditor: true,
        filterOnKeypress: false,
        <sec:authorize access="hasAuthority('HelpFiles_R')">
        dataSource: RestDataSource_Help_Files,
        </sec:authorize>
        gridComponents: ["filterEditor", "header", "body"],
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {name: "id", hidden: true},
            {name: "fileName"},
            {
                name: "fileLabels",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        return value.map(q => q.labelName);
                    }
                }
            },
            {name: "description"},
            {name: "group_id", hidden: true},
            {name: "key", hidden: true}
        ]
    });

    DynamicForm_Help_Files = isc.DynamicForm.create({
        width: "100%",
        height: 200,
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        numCols: 2,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 2,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "fileName",
                title: "<spring:message code="file.name"/>",
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    }],
                required: true
            },
            {
                name: "fileLabelIds",
                title: "<spring:message code="file.label"/>",
                required: true,
                type: "selectItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_File_Labels,
                displayField: "labelName",
                valueField: "id",
                multiple: true,
                filterFields: ["labelName"],
                pickListProperties: {
                    showFilterEditor: false
                },
                click: function (form, item) {
                    item.fetchData();
                }
            },
            {
                name: "description",
                title: "<spring:message code="description"/>",
                type: "textArea",
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    }],
                height: "*",
            },
            {name: "group_id", hidden: true},
            {name: "key", hidden: true},
        ]
    });
    Upload_Button_Help_Files = isc.HTMLFlow.create({
        align: "center",
        contents: "<form class=\"uploadButton\" method=\"POST\" id=\"form_file_JspHelpFile\" action=\"\" enctype=\"multipart/form-data\"><label for=\"file_JspHelps\" class=\"custom-file-upload\"><i class=\"fa fa-cloud-upload\"></i><spring:message code='file.upload'/></label><input id=\"file_JspHelps\" type=\"file\" name=\"file[]\" name=\"file\" onchange=(function(){Help_Files_Upload_Changed()})() /></form>"
    });

    Label_FileUploadSize_Help_Files = isc.Label.create({
        height: "100%",
        align: "center",
        contents: "<spring:message code='file.size.hint'/>"
    });

    IButton_Help_Files_Save = isc.IButtonSave.create({
        title: "<spring:message code='save'/>",
        align: "center",
        click: function () {

            DynamicForm_Help_Files.validate();
            if (DynamicForm_Help_Files.hasErrors())
                return;
            let data = DynamicForm_Help_Files.getValues();

            if (helpFileMethod === "POST") {
                if (!isFileAttached) {
                    createDialog("info", "فایلی آپلود نشده است");
                    return;
                }
                if (document.getElementById('file_JspHelps').files[0].size > this.maxFileSizeUpload) {
                    createDialog("info", "<spring:message code='file.size.hint'/>");
                    return;
                }
                let file = document.getElementById('file_JspHelps').files[0];
                let formData = new FormData();
                formData.append("file", file);

                let request = new XMLHttpRequest();
                request.open("Post", '${uploadMinioUrl}'+ "/"+ '${groupId}', true);
                request.setRequestHeader("contentType", "application/json; charset=utf-8");
                request.setRequestHeader("Authorization", "Bearer <%= accessToken %>");
                request.setRequestHeader("user-id", "Bearer <%= accessToken %>");
                request.setRequestHeader("app-id", "Training");
                request.send(formData);
                request.onreadystatechange = function () {

                    if (request.readyState === XMLHttpRequest.DONE) {
                        if (request.status === 200 || request.status === 201) {
                            let key = JSON.parse(request.response).key;
                            let create = {
                                fileName: data.fileName,
                                description: data.description,
                                group_id: '${groupId}',
                                key: key,
                                fileLabels: data.fileLabelIds
                            };

                            wait.show();
                            isc.RPCManager.sendRequest(TrDSRequest(helpFilesUrl, "POST", JSON.stringify(create), function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    wait.close();
                                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                    Window_Help_Files.close();
                                    ListGrid_Help_Files.invalidateCache();
                                } else {
                                    wait.close();
                                    createDialog("info", "خطایی رخ داده است");
                                    Window_Help_Files.close();
                                }
                            }));
                        } else {
                            createDialog("info", "<spring:message code="upload.failed"/>");
                        }
                    }
                };

            } else if (helpFileMethod === "PUT") {
                let update = {
                    id: data.id,
                    description: data.description,
                    fileLabels: data.fileLabelIds
                };
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(helpFilesUrl + "/" + data.id, "PUT", JSON.stringify(update), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Help_Files.close();
                        ListGrid_Help_Files.invalidateCache();
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                        Window_Help_Files.close();
                    }
                }));
            }
        }
    });

    IButton_Help_Files_Exit = isc.IButtonCancel.create({
        title: "<spring:message code='cancel'/>",
        align: "center",
        click: function () {
            Window_Help_Files.close();
        }
    });

    HLayOut_Help_Files_SaveOrExit = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: 50,
        alignLayout: "center",
        align: "center",
        membersMargin: 10,
        members: [IButton_Help_Files_Save, IButton_Help_Files_Exit]
    });

    Window_Help_Files = isc.Window.create({
        title: "<spring:message code='help.files'/>",
        width: 500,
        height: 250,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [
                DynamicForm_Help_Files,
                Upload_Button_Help_Files,
                Label_FileUploadSize_Help_Files,
                HLayOut_Help_Files_SaveOrExit
            ]
        })]
    });

    VLayout_Body_Help_Files = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_Help_Files,
            ListGrid_Help_Files
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function Help_Files_Add() {

        helpFileMethod = "POST";
        isFileAttached = false;
        DynamicForm_Help_Files.getField("fileName").enable();
        DynamicForm_Help_Files.clearValues();
        DynamicForm_Help_Files.clearErrors();
        Upload_Button_Help_Files.show();
        Label_FileUploadSize_Help_Files.show();
        Window_Help_Files.setTitle("ایجاد فایل آموزشی");
        Window_Help_Files.show();
    }
    function Help_Files_Edit() {

        let record = ListGrid_Help_Files.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "فایل آموزشی برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            helpFileMethod = "PUT";
            DynamicForm_Help_Files.getField("fileName").disable();
            DynamicForm_Help_Files.clearValues();
            DynamicForm_Help_Files.clearErrors();
            DynamicForm_Help_Files.editRecord(record);
            DynamicForm_Help_Files.setValue("fileLabelIds", record.fileLabels.map(q => q.id));
            Upload_Button_Help_Files.hide();
            Label_FileUploadSize_Help_Files.hide();
            Window_Help_Files.setTitle("ویرایش فایل آموزشی");
            Window_Help_Files.show();
        }
    }
    function Help_Files_Remove() {

        let record = ListGrid_Help_Files.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "فایل آموزشی برای حذف انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            let Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين فایل آموزشی حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                    title: "خير"
                })],
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(helpFilesUrl + "/" + record.id, "DELETE", null, function (resp) {
                            wait.close();
                            if (resp.httpResponseCode === 200) {
                                createDialog("info", "<spring:message code='global.grid.record.remove.success'/>");
                                ListGrid_Help_Files.invalidateCache();
                            } else {
                                createDialog("info", "<spring:message code='global.grid.record.remove.failed'/>")
                            }
                        }));
                    }
                }
            });
        }
    }
    function Help_Files_Refresh() {
        RestDataSource_Help_Files.fetchDataURL = helpFilesUrl + "/list";
        ListGrid_Help_Files.clearFilterValues();
        ListGrid_Help_Files.invalidateCache();
    }
    function Help_Files_Download() {

        let record = ListGrid_Help_Files.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let downloadForm = isc.DynamicForm.create({
                method: "GET",
                action: "minIo/downloadFile/" + record.group_id + "/" + record.key + "/" + record.fileName,
                target: "_Blank",
                canSubmit: true,
                fields: [
                    {name: "token", type: "hidden"}
                ]
            });
            downloadForm.setValue("token", "<%=accessToken%>");
            downloadForm.show();
            downloadForm.submitForm();
        }
    }
    function Help_Files_Label_Filter() {

        let ListGrid_File_Labels_Filter = isc.TrLG.create({
            height: 250,
            selection: "multiple",
            selectionAppearance: "checkbox",
            autoFetchData: true,
            showFilterEditor: true,
            filterOnKeypress: false,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            gridComponents: ["filterEditor", "header", "body"],
            dataSource: RestDataSource_File_Labels,
            fields: [
                {name: "id", hidden: true},
                {
                    name: "labelName",
                    width: "10%"
                }
            ]
        });
        let IButton_File_Labels_Filter_Save = isc.ToolStripButtonCreate.create({
            title: "اعمال فیلتر",
            align: "center",
            autoFit: false,
            width: "120",
            height: "30",
            click: function () {
                let records = ListGrid_File_Labels_Filter.getSelectedRecords();
                if (records === null || records.length === 0)
                    createDialog("info", "<spring:message code='msg.not.selected.record'/>");
                else {
                    let labelIds = records.map(q => q.id);
                    RestDataSource_Help_Files.fetchDataURL = helpFilesUrl + "/filter/" + labelIds;
                    ListGrid_Help_Files.fetchData();
                    ListGrid_Help_Files.invalidateCache();
                    Window_File_Labels_Filter.close();
                }
            }
        });
        let IButton_File_Labels_Filter_Exit = isc.IButtonCancel.create({
            title: "<spring:message code='cancel'/>",
            align: "center",
            autoFit: false,
            width: "120",
            height: "30",
            click: function () {
                Window_File_Labels_Filter.close();
            }
        });
        let HLayOut_File_Labels_Filter_SaveOrExit = isc.HLayout.create({
            layoutMargin: 5,
            showEdges: false,
            edgeImage: "",
            width: "100%",
            height: 50,
            alignLayout: "center",
            align: "center",
            membersMargin: 10,
            members: [IButton_File_Labels_Filter_Save, IButton_File_Labels_Filter_Exit]
        });
        let Window_File_Labels_Filter = isc.Window.create({
            title: "فیلتر براساس",
            width: 500,
            height: 300,
            showModalMask: true,
            align: "center",
            autoDraw: false,
            dismissOnEscape: false,
            border: "1px solid gray",
            items: [isc.VLayout.create({
                width: "100%",
                height: "100%",
                members: [ListGrid_File_Labels_Filter, HLayOut_File_Labels_Filter_SaveOrExit]
            })]
        });
        Window_File_Labels_Filter.show();
    }
    function Help_Files_Label_Clear_Filter() {
        Help_Files_Refresh();
    }

    function File_Label_Manage() {

        let ListGrid_File_Labels = isc.TrLG.create({
            height: 250,
            filterOnKeypress: false,
            showFilterEditor: true,
            autoFetchData: true,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            gridComponents: ["filterEditor", "header", "body"],
            dataSource: RestDataSource_File_Labels,
            fields: [
                {name: "id", hidden: true},
                {
                    name: "labelName",
                    width: "10%",
                },
                {
                    name: "removeIcon",
                    width: "4%",
                    align: "center",
                    showTitle: false,
                    canFilter: false,
                    canEdit: false
                }
            ],
            createRecordComponent: function (record, colNum) {

                let fieldName = this.getFieldName(colNum);
                if (fieldName === "removeIcon") {
                    let removeImg = isc.ImgButton.create({
                        showDown: false,
                        showRollOver: false,
                        layoutAlign: "center",
                        src: "[SKIN]/actions/remove.png",
                        prompt: "حذف",
                        height: 16,
                        width: 16,
                        grid: this,
                        click: function () {
                            ListGrid_File_Labels.selectSingleRecord(record);
                            File_Labels_Remove(record.id, ListGrid_File_Labels);
                        }
                    });
                    return removeImg;
                } else {
                    return null;
                }
            },
            rowEditorExit: function (editCompletionEvent, record, newValues, rowNum) {

                if (editCompletionEvent === "enter") {

                    if (newValues.labelName === undefined) {
                        ListGrid_File_Labels.cancelEditing();
                    } else {
                        ListGrid_File_Labels.cancelEditing();
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(fileLabelUrl, "POST", JSON.stringify(newValues), function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                ListGrid_File_Labels.invalidateCache();
                            } else {
                                wait.close();
                                createDialog("info", "خطایی رخ داده است");
                            }
                        }));
                    }
                }
            }
        });

        let IButton_File_Labels_Save = isc.ToolStripButtonCreate.create({
            title: "ایجاد برچسب جدید",
            align: "center",
            click: function () {
                ListGrid_File_Labels.startEditingNew();
            }
        });
        let IButton_File_Labels_Exit = isc.IButtonCancel.create({
            title: "<spring:message code='close'/>",
            align: "center",
            click: function () {
                Window_File_Labels.close();
            }
        });
        let HLayOut_File_Labels_SaveOrExit = isc.HLayout.create({
            layoutMargin: 5,
            showEdges: false,
            edgeImage: "",
            width: "100%",
            height: 50,
            alignLayout: "center",
            align: "center",
            membersMargin: 10,
            members: [IButton_File_Labels_Save, IButton_File_Labels_Exit]
        });

        let Window_File_Labels = isc.Window.create({
            title: "مدیریت برچسب ها",
            width: 500,
            height: 300,
            showModalMask: true,
            align: "center",
            autoDraw: false,
            dismissOnEscape: false,
            border: "1px solid gray",
            items: [isc.VLayout.create({
                width: "100%",
                height: "100%",
                members: [ListGrid_File_Labels, HLayOut_File_Labels_SaveOrExit]
            })]
        });

        Window_File_Labels.show();
    }
    function File_Labels_Remove(id, grid) {
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(fileLabelUrl + "/" + id, "DELETE", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                grid.invalidateCache();
            } else if (resp.httpResponseCode === 406) {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }));
    }
    function Help_Files_Upload_Changed() {
        if (document.getElementById('file_JspHelps').files.length !== 0)
            isFileAttached = true;
    }

    // </script>