<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>

    var methodEducationLevel = "GET";
    
    //////////////////////////////////////////////////////////
    ///////////////////////DataSource/////////////////////////
    /////////////////////////////////////////////////////////
    
    var RestDataSourceEducationLevel = isc.MyRestDataSource.create({
        fields: [{name: "id",primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        fetchDataURL: educationLevelUrl + "spec-list"});
    
    var RestDataSourceEducationMajor = isc.MyRestDataSource.create({
        fields: [{name: "id",primaryKey: true}, {name: "titleFa"}, {name: "titleEn"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        fetchDataURL: educationMajorUrl + "spec-list"});
    
    var RestDataSourceEducationOrientation = isc.MyRestDataSource.create({
        fields: [{name: "id",primaryKey: true}, {name: "titleFa"}, {name: "titleEn"},{name:"educationLevel"}, {name:"educationMajor"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        fetchDataURL: educationOrientationUrl + "spec-list"});


    //////////////////////////////////////////////////////////
    ///////////////////Education Orientation//////////////////
    /////////////////////////////////////////////////////////
    


    //////////////////////////////////////////////////////////
    ///////////////////Education Major////////////////////////
    /////////////////////////////////////////////////////////

var ListGrid_EducationLevel = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSourceEducationLevel,
        // contextMenu: Menu_ListGrid_EducationLevel,
        doubleClick: function () {
            ListGrid_EducationLevel_Edit();
        },
        fields: [
            {name: "id", title: "شماره",hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین ", align: "center"}
        ],
        // selectionType: "multiple",
        selectionChanged: function (record, state) {
        },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });
    
    var DynamicForm_EducationLevel = isc.MyDynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                length: "100",
                readonly: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|a-z|A-Z|0-9 ]",
                validators: [MyValidators.NotEmpty]
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'text',
                length: "100",
                keyPressFilter: "[a-z|A-Z|0-9 ]",
            }
        ],
    });
    
    var ToolStripButton_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "<spring:message code="refresh"/> ",
    
        click: function () {
            ListGrid_EducationLevel_refresh();
        }
    });
    
    var ToolStripButton_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/> ",
        click: function () {
            DynamicForm_EducationLevel.clearValues();
            ListGrid_EducationLevel_Edit()
        }
    });
    var ToolStripButton_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code="create"/>",
        click: function () {
            ListGrid_EducationLevel_Add();
        }
    });
    var ToolStripButton_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/> ",
        click: function () {
            ListGrid_EducationLevel_Remove();
        }
    });
    var ToolStripButton_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            // print_EducationLevel("pdf");
        }
    });
    var ToolStrip_Actions_EducationMajor = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print]
    });
    
    
    <%--var IButton_EducationLevel_Save = isc.IButton.create({--%>
    <%--    top: 260, title: "ذخیره",--%>
    <%--    icon: "pieces/16/save.png",--%>
    <%--    click: function () {--%>
    <%--        DynamicForm_EducationLevel.validate();--%>
    <%--        if (DynamicForm_EducationLevel.hasErrors()) {--%>
    <%--            return;--%>
    <%--        }--%>
    <%--        var data = DynamicForm_EducationLevel.getValues();--%>
    <%--        isc.RPCManager.sendRequest({--%>
    <%--            actionURL: urlEducationLevel,--%>
    <%--            httpMethod: methodEducationLevel,--%>
    <%--            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},--%>
    <%--            useSimpleHttp: true,--%>
    <%--            contentType: "application/json; charset=utf-8",--%>
    <%--            showPrompt: false,--%>
    <%--            data: JSON.stringify(data),--%>
    <%--            serverOutputAsString: false,--%>
    <%--            callback: function (resp) {--%>
    <%--                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {--%>
    <%--                    var responseID = JSON.parse(resp.data).id;--%>
    <%--                    var gridState = "[{id:" + responseID + "}]";--%>
    <%--                    simpleDialog("انجام فرمان", "عملیات با موفقیت انجام شد.", "3000", "say");--%>
    <%--                    ListGrid_EducationLevel_refresh();--%>
    <%--                    setTimeout(function () {--%>
    <%--                        ListGrid_EducationLevel.setSelectedState(gridState);--%>
    <%--                    }, 1000);--%>
    <%--                    Window_EducationLevel.close();--%>
    <%--                } else {--%>
    <%--                    simpleDialog("پیغام", "اجرای عملیات با مشکل مواجه شده است!", "3000", "error")--%>
    <%--                }--%>
    
    <%--            }--%>
    <%--        });--%>
    
    <%--    }--%>
    <%--});--%>
    // var Hlayout_EducationLevel_SaveOrExit = isc.MyHLayoutButtons.create({
    //     layoutMargin: 5,
    //     showEdges: false,
    //     edgeImage: "",
    //     width: "100%",
    //     align: "center",
    //     padding: 10,
    //     membersMargin: 10,
    //     members: [IButton_EducationLevel_Save, isc.IButton.create({
    //         ID: "IButton_EducationLevel_Exit",
    //         title: "لغو",
    //         prompt: "",
    //         width: 100,
    //         icon: "pieces/16/icon_delete.png",
    //         orientation: "vertical",
    //         click: function () {
    //             DynamicForm_EducationLevel.clearValues();
    //             Window_EducationLevel.close();
    //         }
    //     })]
    // });
    // var Window_EducationLevel = isc.MyWindow.create({
    //     autoSize: true,
    //     autoCenter: true,
    //     isModal: true,
    //     showModalMask: true,
    //     align: "center",
    //     autoDraw: false,
    //     dismissOnEscape: false,
    //     border: "1px solid gray",
    //     closeClick: function () {
    //         this.Super("closeClick", arguments);
    //     },
    //     items: [isc.VLayout.create({
    //         width: "300",
    //         height: "120",
    //         members: [DynamicForm_EducationLevel, Hlayout_EducationLevel_SaveOrExit]
    //     })]
    // });

    var HLayout_Actions_EducationMajor = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_EducationMajor]
    });


    var HLayout_Grid_EducationMajor = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_EducationMajor]
    });
    
    var VLayout_Body_EducationMajor = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_EducationMajor,
                    HLayout_Grid_EducationMajor
                ]
    });
    
    //////////////////////////////////////////////////////////
    ///////////////////Education Level////////////////////////
    /////////////////////////////////////////////////////////


    var ListGrid_EducationLevel = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSourceEducationLevel,
        // contextMenu: Menu_ListGrid_EducationLevel,
        doubleClick: function () {
            ListGrid_EducationLevel_Edit();
        },
        fields: [
            {name: "id", title: "شماره",hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین ", align: "center"}
        ],
        // selectionType: "multiple",
        selectionChanged: function (record, state) {
        },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });
    
    var DynamicForm_EducationLevel = isc.MyDynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                length: "100",
                readonly: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|a-z|A-Z|0-9 ]",
                validators: [MyValidators.NotEmpty]
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'text',
                length: "100",
                keyPressFilter: "[a-z|A-Z|0-9 ]",
            }
        ],
    });
    
    var ToolStripButton_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "<spring:message code="refresh"/> ",
    
        click: function () {
            ListGrid_EducationLevel_refresh();
        }
    });
    
    var ToolStripButton_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/> ",
        click: function () {
            DynamicForm_EducationLevel.clearValues();
            ListGrid_EducationLevel_Edit()
        }
    });
    var ToolStripButton_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code="create"/>",
        click: function () {
            ListGrid_EducationLevel_Add();
        }
    });
    var ToolStripButton_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/> ",
        click: function () {
            ListGrid_EducationLevel_Remove();
        }
    });
    var ToolStripButton_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            // print_EducationLevel("pdf");
        }
    });
    var ToolStrip_Actions_EducationLevel = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print]
    });
    
    
    var IButton_EducationLevel_Save = isc.IButton.create({
        top: 260, title: "ذخیره",
        icon: "pieces/16/save.png",
        click: function () {
            DynamicForm_EducationLevel.validate();
            if (DynamicForm_EducationLevel.hasErrors()) {
                return;
            }
            var data = DynamicForm_EducationLevel.getValues();
            isc.RPCManager.sendRequest({
                actionURL: urlEducationLevel,
                httpMethod: methodEducationLevel,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var responseID = JSON.parse(resp.data).id;
                        var gridState = "[{id:" + responseID + "}]";
                        simpleDialog("انجام فرمان", "عملیات با موفقیت انجام شد.", "3000", "say");
                        ListGrid_EducationLevel_refresh();
                        setTimeout(function () {
                            ListGrid_EducationLevel.setSelectedState(gridState);
                        }, 1000);
                        Window_EducationLevel.close();
                    } else {
                        simpleDialog("پیغام", "اجرای عملیات با مشکل مواجه شده است!", "3000", "error")
                    }
    
                }
            });
    
        }
    });
    var Hlayout_EducationLevel_SaveOrExit = isc.MyHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_EducationLevel_Save, isc.IButton.create({
            ID: "IButton_EducationLevel_Exit",
            title: "لغو",
            prompt: "",
            width: 100,
            icon: "pieces/16/icon_delete.png",
            orientation: "vertical",
            click: function () {
                DynamicForm_EducationLevel.clearValues();
                Window_EducationLevel.close();
            }
        })]
    });
    var Window_EducationLevel = isc.MyWindow.create({
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
            width: "300",
            height: "120",
            members: [DynamicForm_EducationLevel, Hlayout_EducationLevel_SaveOrExit]
        })]
    });

    var HLayout_Actions_EducationLevel = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_EducationLevel]
    });


    var HLayout_Grid_EducationLevel = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_EducationLevel]
    });
    
    var VLayout_Body_EducationLevel = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_EducationLevel,
                    HLayout_Grid_EducationLevel
                ]
    });
 
    
    //////////////////////////////////////////////////////////
    ///////////////////Main Layout////////////////////////////
    /////////////////////////////////////////////////////////

    var VLayout_Tabset_Education = isc.TabSet.create({
    tabBarPosition: "top",
    // tabBarAlign: "center",
    width: "100%",
    height: "100%",
    tabs: [
        {title: "مقطع", pane:VLayout_Body_EducationLevel},
        {title: "رشته"},
        {title: "گرایش"}
    ]
    });

    var VLayout_Tab_Education = isc.VLayout.create({
        width: "100%",
        height: "100%",
        border: "2px solid blue",
        members: [VLayout_Tabset_Education]
    });
    
    var VLayout_Body_Education = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [VLayout_Tab_Education]
    });

    //////////////////////////////////////////////////////////
    ///////////////////function//////////////////////////////
    /////////////////////////////////////////////////////////

    function ListGrid_EducationLevel_Remove() {
        var record = ListGrid_EducationLevel.getSelectedRecord();
        // console.log(record);
        if (record == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.record.not.selected'/> !",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "با حذف هدف مذکور، این هدف از کلیه دوره ها حذف خواهد شد.",
                icon: "[SKIN]ask.png",
                title: "اخطار",
                buttons: [isc.Button.create({title: "موافقم"}), isc.Button.create({
                    title: "مخالفم"
                })],
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        var wait = isc.Dialog.create({
                            message: "<spring:message code='msg.waiting'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='message'/>"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: educationLevelUrl + "delete/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_EducationLevel.invalidateCache();
                                    simpleDialog("<spring:message code='msg.command.done'/>", "<spring:message
        code="msg.operation.successful"/>", 3000, "say");
                                } else {
                                    simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                                }
                            }
                        });
                    }
                }
            });
            ListGrid_Syllabus_EducationLevel_refresh();
        }
    };
    
    function ListGrid_EducationLevel_Edit() {
        var record = ListGrid_EducationLevel.getSelectedRecord();
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
            methodEducationLevel = "PUT";
            urlEducationLevel = educationLevelUrl + record.id;
            DynamicForm_EducationLevel.clearValues();
            DynamicForm_EducationLevel.editRecord(record);
            Window_EducationLevel.setTitle("ویرایش مقطع تحصیلی");
            Window_EducationLevel.show();
        }
    };
    
    function ListGrid_EducationLevel_refresh() {
        var record = ListGrid_EducationLevel.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_EducationLevel.selectRecord(record);
        }
        ListGrid_EducationLevel.invalidateCache();
    };
    
    function ListGrid_EducationLevel_Add() {
            methodEducationLevel = "POST";
            urlEducationLevel = educationLevelUrl + "create/";
            DynamicForm_EducationLevel.clearValues();
            Window_EducationLevel.setTitle("ایجاد مقطع تحصیلی");
            Window_EducationLevel.show();
    
    };
