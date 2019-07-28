<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

    var category_BaseUrl = "${restApiUrl}/api/category";
    var category_SubCategoryDummyUrl = "${restApiUrl}/api/category/sub-categories/dummy"
    var category_SubCategoryUrl = "${restApiUrl}/api/sub-category"
    var method = "GET";
    var url = "${restApiUrl}/api/category";
    var selectedCategoryId = -1;

    var DynamicForm_Category = isc.DynamicForm.create({
        width: "500",
        height: "180",
        setMethod: method,
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        numCols: "2",
        showErrorText: true,
        focusField: "code",
        showErrorStyle: true,
        errorOrientation: "right",
        colWidths: ["80", "*"],
        titleAlign: "right",
        requiredMessage: "فیلد اجباری است.",
        <%--margin: "10",--%>
        <%--newPadding: "300",--%>
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                required: true,
                title: "کد",
                type: 'text',
                keyPressFilter: "[A-Z]",
                width: "33%",
                height: "30",
                length: 2,
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 2,
                    max: 2,
                    stopOnError: true,
                    errorMessage: "کد شامل 2 حرف بزرگ لاتین می باشد"
                }
                ]


            },
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                // default:"125",
                //readonly: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|a-z|A-Z]",
                length: "200",
                width: "100%",
                height: 30,
                //paddingTop:9,
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 1,
                    max: 200,
                    stopOnError: true,
                    errorMessage: "حداکثر تعداد کاراکتر مجاز 200 می باشد. "
                }]
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                length: "200",
                width: "100%",
                height: 30,
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 0,
                    max: 200,
                    stopOnError: true,
                    errorMessage: "حداکثر تعداد کاراکتر مجاز 200 می باشد. "
                }]
            },
            {
                name: "description",
                title: "توضيحات",
                length: "200",
                width: "100%",
                height: 30,
                //paddingTop:9,
                type: 'text'
            }
        ]
    });

    var IButton_Category_Save = isc.IButton.create({
        top: 260, title: "ذخیره",
        icon: "pieces/16/save.png",
        click: function () {
            DynamicForm_Category.validate();
            if (DynamicForm_Category.hasErrors()) {
                return;
            }
            var data = DynamicForm_Category.getValues();

            isc.RPCManager.sendRequest({
                actionURL: category_BaseUrl,
                httpMethod: method,
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
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
                        }, 3000);
                        ListGrid_Category_refresh();
                        Window_Category.close();
                    } else {
                        var ERROR = isc.Dialog.create({
                            message: ("اجرای عملیات با مشکل مواجه شده است!"),
                            icon: "[SKIN]stop.png",
                            title: "پیغام"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 3000);
                    }

                }
            });

        }
    });


    var Hlayout_Category_SaveOrExit = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Category_Save, isc.IButton.create({
            ID: "IButton_Category_Exit",
            title: "لغو",
            prompt: "",
            width: 100,
            icon: "pieces/16/icon_delete.png",
            orientation: "vertical",
            click: function () {
                Window_Category.close();
            }
        })]
    });

    var Window_Category = isc.Window.create({
        title: "گروه بندی آموزشی",
        width: "500",
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
            members: [DynamicForm_Category, Hlayout_Category_SaveOrExit]
        })]
    });

    var DynamicForm_Sub_Category = isc.DynamicForm.create({
        width: "500",
        height: "170",
        setMethod: method,
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        numCols: "2",
        showErrorText: true,
        showErrorStyle: true,
        errorOrientation: "right",
        colWidths: ["80", "*"],
        titleAlign: "right",
        requiredMessage: "فیلد اجباری است.",
        <%--margin: "10",--%>
        <%--newPadding: "300",--%>
        fields: [
            {name: "id", hidden: true},
            {
                name: "categoryId",
                title: "گروه مرتبط",
                hidden: true,

            },
            {
                name: "categoryCode",
                title: "کد گروه مرتبط",
                required: true,
                type: 'staticText',
                readonly: true,
                width: "150",
                height: 30
            },
            {
                name: "codeNumber",
                title: "کد",
                type: 'text',

                keyPressFilter: "[A-Z|1-9]",
                required: true,
                length: 1,
                width: "33%",
                height: 30,
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 1,
                    max: 200,
                    stopOnError: true,
                    errorMessage: "کد شامل یک عدد یا یک حرف می باشد"
                }]
            },
            {
                name: "code",
                title: "کد",
                type: 'staticText',
                readonly: true,
                width: "150",
                height: 30
            },
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                height: 30,
                //readonly: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|a-z|A-Z ]",
                length: "200",
                width: "100%",
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 1,
                    max: 200,
                    stopOnError: true,
                    errorMessage: "حداکثر تعداد کاراکتر مجاز 200 می باشد. "
                }]
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                length: "200",
                height: 30,
                width: "100%",
                validators: [{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 0,
                    max: 200,
                    stopOnError: true,
                    errorMessage: "حداکثر تعداد کاراکتر مجاز 200 می باشد. "
                }]
            }
        ]
    });

    var IButton_Sub_Category_Save = isc.IButton.create({
        top: 260, title: "ذخیره",
        icon: "pieces/16/save.png",
        click: function () {
            if (method == "POST") {
                DynamicForm_Sub_Category.getItem("code").setValue(DynamicForm_Sub_Category.getItem("categoryCode").getValue() + DynamicForm_Sub_Category.getItem("codeNumber").getValue());
            }

            DynamicForm_Sub_Category.validate();
            if (DynamicForm_Sub_Category.hasErrors()) {
                return;
            }

            var data = DynamicForm_Sub_Category.getValues();
            crecord = ListGrid_Category.getSelectedRecord();
            //  alert(substring(data.code,1,2));


            if (data.code.substr(0, 2) == crecord.code) {
                isc.RPCManager.sendRequest({
                    actionURL: url,
                    httpMethod: method,
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    showPrompt: false,
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
                            }, 3000);
                            ListGrid_Sub_Category_refresh();
                            Window_Sub_Category.close();
                        } else {
                            var ERROR = isc.Dialog.create({
                                message: ("اجرای عملیات با مشکل مواجه شده است!"),
                                icon: "[SKIN]stop.png",
                                title: "پیغام"
                            });
                            setTimeout(function () {
                                ERROR.close();
                            }, 3000);
                        }

                    }
                });


            } else {

                isc.Dialog.create({
                    message: ("دو حرف اول کد باید با کد گروه یکی باشد"),
                    icon: "[SKIN]stop.png",
                    title: "پیغام"
                });

            }
        }

    });


    var Hlayout_Sub_Category_SaveOrExit = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Sub_Category_Save, isc.IButton.create({
            ID: "IButton_Sub_Category_Exit",
            title: "لغو",
            prompt: "",
            width: 100,
            icon: "pieces/16/icon_delete.png",
            orientation: "vertical",
            click: function () {
                Window_Sub_Category.close();
            }
        })]
    });

    var Window_Sub_Category = isc.Window.create({
        title: "دسته بندی گرایش های مربوط به گروه",
        width: "600",
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
            members: [DynamicForm_Sub_Category, Hlayout_Sub_Category_SaveOrExit]
        })]
    });


    var RestDataSource_Sub_Category = isc.RestDataSource.create({
        fields: [
            {name: "id"}, {name: "titleFa"}, {name: "titleEn"},
            {name: "code"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: category_SubCategoryDummyUrl
    });

    function ListGrid_Sub_Category_Remove() {
        var record = ListGrid_Sub_Category.getSelectedRecord();
        //console.log(record);
        if (record == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است!",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين ركورد حذف گردد؟",
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
                            actionURL: category_SubCategoryUrl + "/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.data == "true") {
                                    ListGrid_Sub_Category.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "ركورد با موفقيت حذف گرديد",
                                        icon: "[SKIN]say.png",
                                        title: "انجام شد"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "ركورد مورد نظر قابل حذف نيست",
                                        icon: "[SKIN]stop.png",
                                        title: "خطا"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 3000);
                                }
                            }
                        });
                    }
                }
            });
        }
    };

    function ListGrid_Sub_Category_Add() {
        var crecord = ListGrid_Category.getSelectedRecord();
        if (crecord == null || crecord.id == null) {
            isc.Dialog.create({
                message: "گروهی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            //selectedCategoryId=crecord.id;
            // alert(crecord.titleFa);
            method = "POST";
            url = category_SubCategoryUrl;
            DynamicForm_Sub_Category.clearValues();
            DynamicForm_Sub_Category.getItem("categoryId").setValue(crecord.id);
            DynamicForm_Sub_Category.getItem("categoryCode").setValue(crecord.code);
            // DynamicForm_Sub_Category.getItem("categoryId").setValue(getFormulaMessage(crecord.titleFa,"2","red","B"));
            Window_Sub_Category.setTitle(" دسته بندی گرایش های مربوط به گروه:  " + getFormulaMessage(crecord.titleFa, "3", "black", "B"));
//            DynamicForm_Sub_Category.getItem("code").setValue(crecord.code);
            DynamicForm_Sub_Category.getItem("code").visible = false;
            DynamicForm_Sub_Category.getItem("categoryCode").visible = true;
            DynamicForm_Sub_Category.getItem("codeNumber").visible = true;


            // Window_Sub_Category.refresh();
            Window_Sub_Category.show();
        }
    };


    function ListGrid_Sub_Category_Edit() {
        var crecord = ListGrid_Category.getSelectedRecord();
        var record = ListGrid_Sub_Category.getSelectedRecord();

        //  alert(crecord.titleFa);
        if (record == null || crecord == null) {
            isc.Dialog.create({
                message: "گروه یا زیر گروه انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {


            method = "PUT";
            url = category_SubCategoryUrl + "/" + record.id;

            DynamicForm_Sub_Category.getItem("code").visible = true;
            DynamicForm_Sub_Category.getItem("categoryCode").visible = false;
            DynamicForm_Sub_Category.getItem("codeNumber").visible = false;
            DynamicForm_Sub_Category.editRecord(record);
            Window_Sub_Category.clear();

            Window_Sub_Category.setTitle(" دسته بندی گرایش های مربوط به گروه:  " + getFormulaMessage(crecord.titleFa, "3", "black", "B"));
            // DynamicForm_Sub_Category.getItem("categoryId").setValue(crecord.id);
            //  Window_Sub_Category.title= " دسته بندی گرایش های مربوط به گروه:  " +getFormulaMessage(crecord.titleFa,"3","black","B");
            // DynamicForm_Sub_Category.getItem("category").setValue(getFormulaMessage(crecord.titleFa,"2","red","B"));

            Window_Sub_Category.show();
        }
    };

    function ListGrid_Sub_Category_refresh() {
        var crecord = ListGrid_Category.getSelectedRecord();
        if (crecord == null || crecord.id == null) {


        } else {


        }
        ListGrid_Sub_Category.invalidateCache();

    };

    var Menu_ListGrid_Sub_Category = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Sub_Category_refresh();
            }
        }, {
            title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_Sub_Category_Add()
            }
        }, {
            title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {

                ListGrid_Sub_Category_Edit();

            }
        }, {
            title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_Sub_Category_Remove();
            }
        }, {isSeparator: true}, {
            title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {
                window.open("<spring:url value="/sub-category/print/pdf"/>");
            }
        }, {
            title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
                window.open("<spring:url value="/sub-category/print/exel"/>");
            }
        }, {
            title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
                window.open("<spring:url value="/sub-category/print/html"/>");
            }
        }]
    });

    var ListGrid_Sub_Category = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Sub_Category,
        contextMenu: Menu_ListGrid_Sub_Category,
        doubleClick: function () {
            ListGrid_Sub_Category_Edit();
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
        // showFilterEditor: true,
        // filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        // filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });

    var RestDataSource_Category = isc.RestDataSource.create({
        fields: [
            {name: "id"}, {name: "titleFa"}, {name: "titleEn"},
            {name: "code"}, {name: "description"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: category_BaseUrl + "/spec-list"
    });

    function ListGrid_Category_Remove() {

        var record = ListGrid_Category.getSelectedRecord();
        console.log(record);
        if (record == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است!",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين ركورد حذف گردد؟",
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
                            actionURL: category_BaseUrl + "/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.data == "true") {
                                    ListGrid_Category.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "ركورد با موفقيت حذف گرديد",
                                        icon: "[SKIN]say.png",
                                        title: "انجام شد"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "ركورد مورد نظر قابل حذف نيست",
                                        icon: "[SKIN]stop.png",
                                        title: "خطا"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 3000);
                                }
                            }
                        });
                    }
                }
            });
        }
    };

    function ListGrid_Category_Edit() {
        var record = ListGrid_Category.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            method = "PUT";
            url = category_BaseUrl + "/" + record.id;
            DynamicForm_Category.getItem("code").setDisabled(true);
            DynamicForm_Category.editRecord(record);
            Window_Category.show();
        }
    };

    function ListGrid_Category_Add() {
        method = "POST";
        url = category_BaseUrl;
        DynamicForm_Category.clearValues();
        DynamicForm_Category.getItem("code").setDisabled(false);
        Window_Category.show();

    }

    function ListGrid_Category_refresh() {
        var record = ListGrid_Category.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_Category.selectRecord(record);
        }
        ListGrid_Category.invalidateCache();
    };

    var Menu_ListGrid_Category = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Category_refresh();
            }
        }, {
            title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_Category_Add();
            }
        }, {
            title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {

                ListGrid_Category_Edit();

            }
        }, {
            title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_Category_Remove();
            }
        }, {isSeparator: true}, {
            title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {
                window.open("<spring:url value="/category/print/pdf"/>");
            }
        }, {
            title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
                window.open("<spring:url value="/category/print/exel"/>");
            }
        }, {
            title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
                window.open("<spring:url value="/category/print/html"/>");
            }
        }]
    });

    var ListGrid_Category = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Category,
        contextMenu: Menu_ListGrid_Category,
        doubleClick: function () {
            ListGrid_Category_Edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد", align: "center"},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین ", align: "center"},
            {name: "description", title: "توضیحات", align: "center"}
        ],
        selectionType: "single",
        selectionChanged: function (record, state) {
            RestDataSource_Sub_Category.fetchDataURL = category_BaseUrl + "/" + record.id + "/sub-categories";
            selectedCategoryId = record.id;
            <%--RestDataSource_Sub_Category.fetchData();--%>
            ListGrid_Sub_Category.invalidateCache();
        },
        dataArrived: function (startRow, endRow) {
            record = ListGrid_Category.getSelectedRecord();
            if (record == null) {
                RestDataSource_Sub_Category.fetchDataURL = category_SubCategoryDummyUrl;
                selectedCategoryId = -1;
            } else {
                RestDataSource_Sub_Category.fetchDataURL = category_BaseUrl + "/" + record.id + "/sub-categories";
                selectedCategoryId = record.id;
            }
            ListGrid_Sub_Category.invalidateCache();
        },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        // showFilterEditor: true,
        // filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        // filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });

    var ToolStripButton_Sub_Category_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "بازخوانی اطلاعات",
        click: function () {
            ListGrid_Sub_Category_refresh();
        }
    });

    var ToolStripButton_Sub_Category_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {
            ListGrid_Sub_Category_Edit();
        }
    });
    var ToolStripButton_Sub_Category_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {
            ListGrid_Sub_Category_Add();
        }
    });
    var ToolStripButton_Sub_Category_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            ListGrid_Sub_Category_Remove();
        }
    });

    var ToolStrip_Actions_Sub_Category = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Sub_Category_Refresh, ToolStripButton_Sub_Category_Add, ToolStripButton_Sub_Category_Edit, ToolStripButton_Sub_Category_Remove]
    });


    var ToolStripButton_Category_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "بازخوانی اطلاعات",
        click: function () {
            ListGrid_Category_refresh();
        }
    });
    var ToolStripButton_Category_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {
            ListGrid_Category_Edit();
        }
    });
    var ToolStripButton_Category_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {
            ListGrid_Category_Add();
        }
    });
    var ToolStripButton_Category_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            ListGrid_Category_Remove();
        }
    });

    var ToolStrip_Actions_Category = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Category_Refresh, ToolStripButton_Category_Add, ToolStripButton_Category_Edit, ToolStripButton_Category_Remove]
    });


    <%--var HLayout_Actions_Skill_Standard = isc.HLayout.create({--%>
    <%--width: "100%",--%>
    <%--members: [ToolStrip_Actions]--%>
    <%--});--%>

    var HLayout_Action_Category = isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_Category]
    });


    var HLayout_Grid_Category = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [ListGrid_Category]
    });


    var VLayout_Body_Category = isc.VLayout.create({
        width: "50%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [HLayout_Action_Category, HLayout_Grid_Category]
    });

    var HLayout_Action_SubCategory = isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_Sub_Category]
    });

    var HLayout_Grid_SubCategory = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [ListGrid_Sub_Category]
    });

    var VLayout_Body_SubCategory = isc.VLayout.create({
        width: "50%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [HLayout_Action_SubCategory, HLayout_Grid_SubCategory]
    });

    var HLayout_Body_All_Category = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [VLayout_Body_Category, VLayout_Body_SubCategory]
    });


