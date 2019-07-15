<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>
    var methodGoal = "GET";
    var urlGoal = "http://localhost:9090/api/goal";
    var methodSyllabus = "GET";
    var urlSyllabus = "http://localhost:9090/api/syllabus";
    var selectedRecord = 0;

    var RestDataSourceGoalEDomainType = isc.RestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "http://localhost:9090"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "http://localhost:9090/api/enum/eDomainType"
    });
    var RestDataSource_GoalAll = isc.RestDataSource.create({
        ID: "goalDS",
        fields: [
            {name: "id", primaryKey: "true", hidden: "true"}, {name: "titleFa"}, {name: "titleEn"},
            {name: "code"}, {name: "description"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "http://localhost:9090"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "http://localhost:9090/api/course/goal/" + courseId.id
    });
    var RestDataSource_Syllabus_JspGoal = isc.RestDataSource.create({
        fields: [
            {name: "id", hidden: "true"},
            {name: "titleFa", title: "سرفصل ها"},
            {name: "titleEn", title: "نام انگلیسی", hidden: "true"},
            {name: "edomainType.titleFa", title: "حیطه"},
            {name: "code", hidden: "true"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "http://localhost:9090"
            };
            return this.Super("transformRequest", arguments);
        },
    });

    var DynamicForm_Goal = isc.MyDynamicForm.create({
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
                keyPressFilter: "[a-z|A-Z|0-9 ]"
            }
        ]
    });
    var DynamicForm_Syllabus = isc.MyDynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "goalId",
                title: "شماره هدف",
                required: true,
                type: 'text',
                readonly: true,
                keyPressFilter: "[0-9]",
                length: "200",
                width: "150",
                hidden: true,
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    stopOnError: true,
                    errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
                }]
            },
            {
                name: "code",
                title: "کد",
                type: 'text',
                required: true,
                hidden: true,
                length: "7"
            },
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                readonly: true,
                hint: "Persian/فارسی",
                showHintInField: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|a-z|A-Z|0-9 ]",
                length: "200",
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    stopOnError: true,
                    errorMessage: "نام مجاز حداکثر دویست کاراکتر است"
                }]
            },
            {
                name: "edomainType.id",
                value: "",
                type: "IntegerItem",
                title: "حیطه",
                width: "95%",
                required: true,
                textAlign: "center",
                editorType: "ComboBoxItem",
                pickListWidth: 100,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSourceGoalEDomainType,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                length: "200",
                hint: "Latin",
                showHintInField: true,
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 3,
                    max: 200,
                    stopOnError: true,
                    errorMessage: "نام مجاز بين سه تا دویست کاراکتر است"
                }]
            },
            {name: "practicalDuration", title: "مدت زمان اجرا", type: "text", keyPressFilter: "[0-9]", length: "3"}]
    });

    var IButton_Goal_Save = isc.IButton.create({
        top: 260, title: "ذخیره",
        icon: "pieces/16/save.png",
        click: function () {
            DynamicForm_Goal.validate();
            if (DynamicForm_Goal.hasErrors()) {
                return;
            }
            var data = DynamicForm_Goal.getValues();
            isc.RPCManager.sendRequest({
                actionURL: urlGoal,
                httpMethod: methodGoal,
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
                        ListGrid_Goal_refresh();
                        Window_Goal.close();
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
    var IButton_Syllabus_Save = isc.IButton.create({
        top: 260, title: "ذخیره",
        icon: "pieces/16/save.png",
        click: function () {
            DynamicForm_Syllabus.validate();
            if (DynamicForm_Syllabus.hasErrors()) {
                return;
            }
            var data = DynamicForm_Syllabus.getValues();
            isc.RPCManager.sendRequest({
                actionURL: urlSyllabus,
                httpMethod: methodSyllabus,
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
                        ListGrid_Syllabus_Goal.invalidateCache();
                        Window_Syllabus.close();
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

    var Hlayout_Goal_SaveOrExit = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        align:"center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Goal_Save, isc.IButton.create({
            ID: "IButton_Goal_Exit",
            title: "لغو",
            prompt: "",
            width: 100,
            icon: "pieces/16/icon_delete.png",
            orientation: "vertical",
            click: function () {
                DynamicForm_Goal.clearValues();
                Window_Goal.close();
            }
        })]
    });

    var Hlayout_Syllabus_SaveOrExit = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        align:"center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Syllabus_Save, isc.IButton.create({
            ID: "IButton_Syllabus_Exit",
            title: "لغو",
            prompt: "",
            width: 100,
            icon: "pieces/16/icon_delete.png",
            orientation: "vertical",
            click: function () {
                Window_Syllabus.close();
            }
        })]
    });

    var Window_Syllabus = isc.Window.create({
        title: "سرفصل",
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
            width: "350",
            height: "150",
            members: [DynamicForm_Syllabus, Hlayout_Syllabus_SaveOrExit]
        })]
    });

    var Window_Goal = isc.Window.create({
        title: "هدف",
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
            members: [DynamicForm_Goal, Hlayout_Goal_SaveOrExit]
        })]
    });

    var Menu_ListGrid_Syllabus_Goal = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Syllabus_Goal_refresh();
            }
        }, {
            title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_Syllabus_Goal_Add()
            }
        }, {
            title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {

                ListGrid_Syllabus_Goal_Edit();

            }
        }, {
            title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_Syllabus_Goal_Remove();
            }
        }, {isSeparator: true}, {
            title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {
                window.open("<spring:url value="/syllabus/print/pdf"/>");
            }
        }, {
            title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
                window.open("<spring:url value="/syllabus/print/excel"/>");
            }
        }, {
            title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
                window.open("<spring:url value="/syllabus/print/html"/>");
            }
        }]
    });
    var Menu_ListGrid_Goal = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Goal_refresh();
            }
        }, {
            title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
                methodGoal = "POST";
                urlGoal = "http://localhost:9090/api/goal";
                DynamicForm_Goal.clearValues();
                Window_Goal.show();
            }
        }, {
            title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {

                ListGrid_Goal_Edit();

            }
        }, {
            title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_Goal_Remove();
            }
        }, {isSeparator: true}, {
            title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {
                window.open("<spring:url value="/goal/print/pdf"/>");
            }
        }, {
            title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
                window.open("<spring:url value="/goal/print/exel"/>");
            }
        }, {
            title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
                window.open("<spring:url value="/goal/print/html"/>");
            }
        }]
    });

    var ListGrid_Goal = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_CourseGoal,
        contextMenu: Menu_ListGrid_Goal,
        doubleClick: function () {
            ListGrid_Goal_Edit();
        },
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام فارسی هدف", align: "center"},
            {name: "titleEn", title: "نام لاتین هدف ", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "multiple",
        selectionChanged: function (record, state) {
            selectedRecord = record.id;
            ListGrid_Syllabus_Goal.invalidateCache();
        },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
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
    var ListGrid_Syllabus_Goal = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Syllabus,
        contextMenu: Menu_ListGrid_Syllabus_Goal,
        doubleClick: function () {
            ListGrid_Syllabus_Goal_Edit();
        },
        getCellCSSText: function (record, rowNum, colNum) {
            if (record.goalId == selectedRecord && ListGrid_Goal.getSelectedRecord() != null) {
                return "color:red;";
            }
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد سرفصل", align: "center", hidden: true},
            {name: "titleFa", title: "نام فارسی سرفصل", align: "center"},
            {name: "titleEn", title: "نام لاتین سرفصل", align: "center"},
            {name: "edomainType.titleFa", title: "حیطه", align: "center"},
            {name: "practicalDuration", title: "مدت زمان اجرا", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: "goalId",
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
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
    var ListGrid_GoalAll = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        alternateRecordStyles: true,
        expansionFieldImageShowSelected: true,
        canExpandRecords: true,
        expansionMode: "related",
        detailDS: RestDataSource_Syllabus_JspGoal,
        expansionRelatedProperties: {
            border: "1px solid inherit",
            margin: 5
        },
        dataSource: RestDataSource_GoalAll,
        doubleClick: function () {
            /*ListGrid_CourseGoal_Goal_Edit();*/
        },
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "كل اهداف", align: "center"},
            {name: "titleEn", title: "نام لاتین هدف ", align: "center", hidden: true},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "multiple",
        selectionChanged: function (record, state) {
            RestDataSource_Syllabus_JspGoal.fetchDataURL = "http://localhost:9090/api/goal/" + record.id + "/syllabus";
        },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });
    var ListGrid_CourseGoal_Goal = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_CourseGoal,
        doubleClick: function () {
            /*ListGrid_CourseGoal_Goal_Edit();*/
        },
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "اهداف دوره", align: "center"},
            {name: "titleEn", title: "نام لاتین هدف", align: "center", hidden: true},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "multiple",
        recordClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
            // RestDataSource_Syllabus.fetchDataURL = "http://localhost:9090/api/goal/" + record.id + "/syllabus";
            // ListGrid_CourseSyllabus.fetchData();
            // ListGrid_CourseSyllabus.invalidateCache();
            // ListGrid_GoalAll.deselectAllRecords();
        },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
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
    var ToolStripButton_Syllabus_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش سرفصل",
        click: function () {
            ListGrid_Syllabus_Goal_Edit();
        }
    });
    var ToolStripButton_Syllabus_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد سرفصل",
        click: function () {
            ListGrid_Syllabus_Goal_Add();
        }
    });
    var ToolStripButton_Syllabus_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف سرفصل",
        click: function () {
            ListGrid_Syllabus_Goal_Remove();
        }
    });
    var ToolStripButton_Syllabus_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "چاپ",
        click: function () {
            window.open("<spring:url value="/syllabus/print/pdf"/>");
        }
    });
    var ToolStrip_Actions_Syllabus = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Syllabus_Add, ToolStripButton_Syllabus_Edit, ToolStripButton_Syllabus_Remove, ToolStripButton_Syllabus_Print]
    });

    var ToolStripButton_Goal_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "بازخوانی اطلاعات",
        click: function () {
            ListGrid_Goal_refresh();
            RestDataSource_Syllabus.fetchDataURL = "http://localhost:9090/api/syllabus/course/" + courseId.id;
            ListGrid_Syllabus_Goal.invalidateCache();
        }
    });
    var ToolStripButton_Goal_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش هدف",
        prompt: "اخطار<br/>ویرایش هدف در تمامی دوره های ارضا کننده هدف نیز اعمال خواهد شد.",
        hoverWidth: 320,
        click: function () {
            ListGrid_Goal_Edit();
        }
    });
    var ToolStripButton_Goal_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد هدف",
        prompt: "تعریف هدف جدید برای دوره مذکور",
        hoverWidth: 160,
        click: function () {
            ListGrid_Goal_Add();
        }
    });
    var ToolStripButton_Goal_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف هدف",
        prompt: "اخطار<br/>هدف انتخاب شده از تمامی دوره های موجود حذف خواهد شد.",
        hoverWidth: 280,
        click: function () {
            ListGrid_Goal_Remove();
        }
    });
    var ToolStripButton_Goal_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/plus.png",
        prompt: "تخصیص هدف موجود به دوره مذکور",
        hoverWidth: 160,
        title: "افزودن هدف",
        click: function () {
            Window_AddGoal.setTitle("افزودن هدف به دوره " + courseId.titleFa);
            Window_AddGoal.show();
            ListGrid_CourseGoal_Goal.invalidateCache();
            RestDataSource_GoalAll.fetchDataURL = "http://localhost:9090/api/course/goal/" + courseId.id;
            ListGrid_GoalAll.invalidateCache();
            <%--window.open("<spring:url value="/goal/print/pdf"/>");--%>
        }
    });
    var ToolStripButton_Add_Vertical = isc.ToolStripButton.create({
        icon: "pieces/512/left-arrow.png",
        title: "",
        prompt: "افزودن اهداف انتخاب شده به اهداف دوره مذکور",
        click: function () {
            if (courseId == "" || courseId.id == null) {
                isc.Dialog.create({
                    message: "دوره اي انتخاب نشده است.",
                    icon: "[SKIN]ask.png",
                    title: "پیغام",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                var goalRecord = ListGrid_GoalAll.getSelectedRecords();
                if (goalRecord.length == 0) {
                    isc.Dialog.create({
                        message: "هدفي انتخاب نشده است.",
                        icon: "[SKIN]ask.png",
                        title: "پیغام",
                        buttons: [isc.Button.create({title: "تائید"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                } else {
                    var goalList = new Array();
                    for (var i = 0; i < goalRecord.length; i++) {
                        goalList.add(goalRecord[i].id);
                    }
                    isc.RPCManager.sendRequest({
                        actionURL: "http://localhost:9090/api/course/" + courseId.id + "/" + goalList.toString(),
                        httpMethod: "GET",
                        httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                        useSimpleHttp: true,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: false,
                        serverOutputAsString: false,
                        callback: function (resp) {
                            if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                ListGrid_GoalAll.invalidateCache();
                                ListGrid_CourseGoal_Goal.invalidateCache();
                                ListGrid_Goal.invalidateCache();
                                ListGrid_Syllabus_Goal.invalidateCache();


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
            }
        }
    });
    var ToolStripButton_Remove_Vertical = isc.ToolStripButton.create({
        icon: "pieces/512/right-arrow.png",
        title: "",
        prompt: "حذف اهداف انتخاب شده از دوره مذکور",
        click: function () {
            if (courseId == "" || courseId.id == null) {
                isc.Dialog.create({
                    message: "دوره اي انتخاب نشده است.",
                    icon: "[SKIN]ask.png",
                    title: "پیغام",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                var goalrRecord = ListGrid_CourseGoal_Goal.getSelectedRecords();
                if (goalrRecord.length == 0) {
                    isc.Dialog.create({
                        message: "هدفي انتخاب نشده است.",
                        icon: "[SKIN]ask.png",
                        title: "پیغام",
                        buttons: [isc.Button.create({title: "تائید"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                } else {
                    var arryRecord = new Array();
                    for (var i = 0; i < goalrRecord.length; i++) {
                        arryRecord.add(goalrRecord[i].id)

                    }
                    isc.RPCManager.sendRequest({

                        actionURL: "http://localhost:9090/api/course/remove/" + courseId.id + "/" + arryRecord.toString(),
                        httpMethod: "GET",
                        httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                        useSimpleHttp: true,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: false,
                        // data: JSON.stringify(vsRecord,goalRecord),
                        serverOutputAsString: false,
                        callback: function (resp) {
                            if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                                ListGrid_GoalAll.invalidateCache();
                                ListGrid_CourseGoal_Goal.invalidateCache();
                                ListGrid_Goal.invalidateCache();
                                ListGrid_Syllabus_Goal.invalidateCache();

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
            }
        }
    });
    var ToolStrip_Actions_Goal = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Goal_Refresh, ToolStripButton_Goal_Add, ToolStripButton_Goal_Edit, ToolStripButton_Goal_Remove, ToolStripButton_Goal_Print]
    });
    var ToolStrip_Vertical_Goals = isc.ToolStrip.create({
        width: "100%",
        height: "100%",
        align: "center",
        vertical: "center",
        members: [ToolStripButton_Add_Vertical, ToolStripButton_Remove_Vertical]
    });

    var VLayout_Grid_GoalAll = isc.VLayout.create({
        width: "40%",
        height: "100%",
        members: [ListGrid_GoalAll]
    });
    var VLayout_Actions_Goals = isc.VLayout.create({
        width: "20",
        height: "100%",
        members: [ToolStrip_Vertical_Goals]
    });
    var VLayout_Grid_Goal_JspGoal = isc.VLayout.create({
        width: "40%",
        height: "100%",
        members: [ListGrid_CourseGoal_Goal]
    });
    var HLayOut_Goal_JspGoal = isc.HLayout.create({
        width: "100%",
        height: 600,
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            VLayout_Grid_GoalAll,
            VLayout_Actions_Goals,
            VLayout_Grid_Goal_JspGoal
        ]
    });

    var Window_AddGoal = isc.Window.create({
        title: "افزودن هدف",
        width: 900,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        closeClick: function () {
            this.hide();
        },
        items: [
            HLayOut_Goal_JspGoal
        ]
    });

    var HLayout_Action_Goal = isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_Goal]
    });
    var HLayout_Grid_Goal = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Goal]
    });
    var VLayout_Body_Goal = isc.VLayout.create({
        width: "30%",
        height: "100%",
        members: [HLayout_Action_Goal, HLayout_Grid_Goal]
    });
    var HLayout_Action_Syllabus = isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_Syllabus]
    });
    var HLayout_Grid_Syllabus = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [ListGrid_Syllabus_Goal]
    });
    var VLayout_Body_Syllabus = isc.VLayout.create({
        width: "70%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [HLayout_Action_Syllabus, HLayout_Grid_Syllabus]
    });
    var HLayout_Body_All_Goal = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [VLayout_Body_Goal, VLayout_Body_Syllabus]
    });

    function ListGrid_Goal_Remove() {
        var record = ListGrid_Goal.getSelectedRecord();
        console.log(record);
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
                            actionURL: "http://localhost:9090/api/goal/delete/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Goal.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code='msg.operation.successful'/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code='msg.command.done'/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "<spring:message code='msg.record.cannot.deleted'/>",
                                        icon: "[SKIN]stop.png",
                                        title: "<spring:message code='message'/>"
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
            ListGrid_Syllabus_Goal_refresh();
        }
    };

    function ListGrid_Goal_Edit() {
        var record = ListGrid_Goal.getSelectedRecord();
        selectedRecord = ListGrid_Goal.getRowNum(record);
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
        }
        else {
            methodGoal = "PUT";
            urlGoal = "http://localhost:9090/api/goal/" + record.id;
            DynamicForm_Goal.clearValues();
            DynamicForm_Goal.editRecord(record);
            Window_Goal.show();
        }
    };

    function ListGrid_Goal_refresh() {
        var record = ListGrid_Goal.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_Goal.selectRecord(record);
        }
        ListGrid_Goal.invalidateCache();
    };

    function ListGrid_Goal_Add() {
        if (courseId == null || courseId.id == null) {
            isc.Dialog.create({
                message: "دوره اي انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            methodGoal = "POST";
            urlGoal = "http://localhost:9090/api/goal/create/" + courseId.id;
            DynamicForm_Goal.clearValues();
            Window_Goal.show();
        }
    };

    function ListGrid_Syllabus_Goal_Remove() {
        var record = ListGrid_Syllabus_Goal.getSelectedRecord();
        console.log(record);
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
                message: "<spring:message code='msg.record.remove.ask'/>",
                icon: "[SKIN]ask.png",
                title: "هشدار",
                buttons: [isc.Button.create({title: "<spring:message code='global.yes'/>"}), isc.Button.create({
                    title: "<spring:message
		code='global.no'/>"
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
                            actionURL: "http://localhost:9090/api/syllabus/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Syllabus_Goal.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code='global.form.request.successful'/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code='global.form.command.done'/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "<spring:message code='global.grid.record.cannot.deleted'/>",
                                        icon: "[SKIN]stop.png",
                                        title: "<spring:message code='global.message'/>"
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

    function ListGrid_Syllabus_Goal_Add() {
        var gRecord = ListGrid_Goal.getSelectedRecord();
        if (gRecord == null || gRecord.id == null) {
            isc.Dialog.create({
                message: "هدف مرتبط انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            selectedGoalId = gRecord.id;
            methodSyllabus = "POST";
            urlSyllabus = "http://localhost:9090/api/syllabus";
            // DynamicForm_Syllabus.clearValues();
            DynamicForm_Syllabus.getItem("goalId").setValue(gRecord.id);
            Window_Syllabus.show();
        }
    };

    function ListGrid_Syllabus_Goal_Edit() {
        var sRecord = ListGrid_Syllabus_Goal.getSelectedRecord();
        if (sRecord == null || sRecord.id == null) {
            isc.Dialog.create({
                message: "سرفصلی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            methodSyllabus = "PUT";
            urlSyllabus = "http://localhost:9090/api/syllabus/" + sRecord.id;
            DynamicForm_Syllabus.clearValues();
            DynamicForm_Syllabus.editRecord(sRecord);
            Window_Syllabus.show();
        }
    };

    function ListGrid_Syllabus_Goal_refresh() {
        var record = ListGrid_Syllabus_Goal.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_Syllabus_Goal.selectRecord(record);
        }
        ListGrid_Syllabus_Goal.invalidateCache();
    };