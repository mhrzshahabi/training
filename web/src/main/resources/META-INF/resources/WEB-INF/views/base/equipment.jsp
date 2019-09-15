<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    <%
        final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    %>

    var equipmentMethod = "get";
    var equipmentHomeUrl = rootUrl + "/equipment";
    var equipmentActionUrl = equipmentHomeUrl;
    var Menu_ListGrid_Equipment = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Equipment_refresh();
            }
        }, {
            title: "ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Equipment_Add();
            }
        }, {
            title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_Equipment_edit();
            }
        }, {
            title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {
                ListGrid_Equipment_remove();
            }
        },]
    });
    var RestDataSource_Equipment = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "code"}, {name: "titleFa"}, {name: "titleEn"},
            {name: "description"}
        ],

        fetchDataURL: equipmentHomeUrl + "/spec-list"
    });
    var ListGrid_Equipment = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Equipment,
        contextMenu: Menu_ListGrid_Equipment,
        doubleClick: function () {
            ListGrid_Equipment_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد", align: "center"},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین ", align: "center"}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
    });
    var DynamicForm_Equipment = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        setMethod: equipmentMethod,
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: true,
        showErrorStyle: true,
        errorOrientation: "right",
        colWidths: ["30%", "*"],
        titleAlign: "right",
        requiredMessage: "فیلد اجباری است.",
        numCols: 2,
        margin: 10,
        newPadding: 5,
        fields: [{name: "id", hidden: true},
            {
                name: "code",
                title: "کد",
                type: 'text',
                hint: "Persian/فارسی",
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                length: "20",
                width:"300"
            },
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                hint: "Persian/فارسی",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|a-z|A-Z ]",
                length: "255",
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 1,
                    max: 255,
                    stopOnError: true,
                    errorMessage: "تعداد کاراکتر مجاز بین 1 تا 250 می باشد. "
                }],
                width:"300"
            },

            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                length: "255",
                hint: "Latin",
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 0,
                    max: 250,
                    stopOnError: true,
                    errorMessage: "تعداد کاراکتر مجاز بین 0 تا 250 می باشد. "
                }],
                width:"300"
            },
            {
                name: "description",
                showHintInField: true,
                title: "توضيحات",
                length: "500",
                width:"300",
                type: 'areaText'
            }
        ]
    });

    var IButton_Equipment_Save = isc.IButton.create({
        top: 260, title: "ذخیره", icon: "pieces/16/save.png", click: function () {

            DynamicForm_Equipment.validate();
            if (DynamicForm_Equipment.hasErrors()) {
                return;
            }
            var data = DynamicForm_Equipment.getValues();
            isc.RPCManager.sendRequest({
                actionURL: equipmentActionUrl,
                httpMethod: equipmentMethod,
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var OK = isc.Dialog.create({
                            message: "عملیات با موفقیت انجام شد.",
                            icon: "[SKIN]say.png",
                            title: "انجام فرمان"
                        });
                        setTimeout(function () {
                            OK.close();
                        }, 2000);
                        ListGrid_Equipment_refresh();
                        Window_Equipment.close();
                    } else {
                        var ERROR = isc.Dialog.create({
                            message: ("اجرای عملیات با مشکل مواجه شده است!"),
                            icon: "[SKIN]stop.png",
                            title: "توجه"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 2000);
                    }
                }
            });
        }
    });
    var EquipmentSaveOrExitHlayout = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Equipment_Save, isc.IButton.create({
            ID: "courseEditExitIButton",
            title: "لغو",
            prompt: "",
            width: 100,
            icon: "<spring:url value="remove.png"/>",
            orientation: "vertical",
            click: function () {
                Window_Equipment.close();
            }
        })]
    });
    var Window_Equipment = isc.Window.create({
        title: "سطح استاندارد مهارت",
        width: 500,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Equipment, EquipmentSaveOrExitHlayout]
        })]
    });

    function ListGrid_Equipment_refresh() {
        var record = ListGrid_Equipment.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_Equipment.selectRecord(record);
        }
        ListGrid_Equipment.invalidateCache();
    };
    function ListGrid_Equipment_remove() {


        var record = ListGrid_Equipment.getSelectedRecord();
//console.log(record);
        if (record == null) {
            isc.Dialog.create({
                message: "هیچ تجهیز کمک آموزشی برای حذف انتخاب نشده است!",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين تجهیز کمک آموزشی حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "هشدار",
                buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
                    title: "خير"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        var wait = isc.Dialog.create({
                            message: "<spring:message code='global.form.do.operation'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='global.message'/>"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: equipmentHomeUrl + "/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.data == "true") {
                                    ListGrid_Equipment.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "تجهیز کمک آموزشی با موفقيت حذف گرديد",
                                        icon: "[SKIN]say.png",
                                        title: "انجام شد"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 2000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "ركورد مورد نظر قابل حذف نيست",
                                        icon: "[SKIN]stop.png",
                                        title: "خطا"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 2000);
                                }
                            }
                        });
                    }
                }
            });
        }


    };
    function ListGrid_Equipment_Add() {
        equipmentMethod = "POST";
        equipmentActionUrl = equipmentHomeUrl;
        DynamicForm_Equipment.clearValues();
        Window_Equipment.setTitle("ایجاد تجهیز کمک آموزشی جدید");
        Window_Equipment.show();
    };
    function ListGrid_Equipment_edit() {
        var record = ListGrid_Equipment.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            equipmentMethod = "PUT";
            equipmentActionUrl = equipmentHomeUrl + "/" + record.id;
            DynamicForm_Equipment.editRecord(record);
            Window_Equipment.setTitle("ویرایش تجهیز کمک آموزشی '" + record.titleFa + "'");
            Window_Equipment.show();
        }
    };

    var ToolStripButton_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {
            ListGrid_Equipment_refresh();
        }
    });
    var ToolStripButton_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {
            ListGrid_Equipment_edit();
        }
    });
    var ToolStripButton_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {
            ListGrid_Equipment_Add();
        }
    });
    var ToolStripButton_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            ListGrid_Equipment_remove();
        }
    });
    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove]
    });
    var HLayout_Actions = isc.HLayout.create({width: "100%", members: [ToolStrip_Actions]});
    var HLayout_Grid = isc.HLayout.create({width: "100%", height: "100%", members: [ListGrid_Equipment]});
    var VLayout_Body = isc.VLayout.create({width: "100%", height: "100%", members: [HLayout_Actions, HLayout_Grid]});