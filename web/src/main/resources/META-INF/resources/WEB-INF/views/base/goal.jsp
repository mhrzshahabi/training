<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>
    <%--<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>--%>

    var methodGoal = "GET";
    var urlGoal = goalUrl;
    var methodSyllabus = "GET";
    var urlSyllabus = syllabusUrl;
    var selectedRecord = 0;

    var RestDataSourceGoalEDomainType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        fetchDataURL: enumUrl + "eDomainType"
    });
    var RestDataSource_GoalAll = isc.MyRestDataSource.create({
        ID: "goalDS",
        fields: [
            {name: "id", primaryKey: "true", hidden: "true"}, {name: "titleFa"}, {name: "titleEn"},
            {name: "code"}, {name: "description"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        fetchDataURL: courseUrl + "goal/" + courseId.id
    });
    var RestDataSource_Syllabus_JspGoal = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "سرفصل ها", align: "center", width: "60%"},
            {name: "edomainType.titleFa", title: "حیطه", align: "center", width: "20%"},
            {name: "practicalDuration", title: "مدت زمان اجرا", align: "center", width: "20%"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
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
                keyPressFilter: "[a-z|A-Z|0-9 ]",
            }
        ],
    });
    var DynamicForm_Syllabus = isc.MyDynamicForm.create({
        ID: "formSyllabus",
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
            {
                name: "edomainTypeId",
                value: "",
                type: "IntegerItem",
                title: "حیطه",
                width: 220,
                required: true,
                textAlign: "center",
                editorType: "MyComboBoxItem",
                pickListWidth: 210,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSourceGoalEDomainType,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                // filterOnKeypress: true,
                // filterFields: "titleFa",
                sortField: "id",
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "titleFa", width: "30%"}],
            },
            {
                name: "practicalDuration",
                title: "مدت زمان اجرا",
                editorType: "SpinnerItem",
                writeStackedIcons: false,
                defaultValue: 2,
                keyPressFilter: "^[0-9]",
                min: 1,
                max: 300,
                step: 2,
change:function(form, item, value, oldValue) {

                    var sumSyllabus = (ListGrid_CourseSyllabus.getGridSummaryData().get(0).practicalDuration)-(ListGrid_Syllabus_Goal.getSelectedRecord().practicalDuration)+value;
Window_Syllabus.setStatus("طول دوره "+(ListGrid_Course.getSelectedRecord().theoryDuration)+" ساعت"+" و جمع مدت زمان سرفصل ها "+sumSyllabus+" ساعت می باشد.");
// Window_Syllabus.setStatus('<p   style="background-color:Tomato;margin: 0;padding: 0 10px;">Tomato</p  >');
},

            }],

        keyPress: function () {
            if (isc.EventHandler.getKey() == "Enter") {
                DynamicForm_Syllabus.focusInNextTabElement();
            }
        }
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
                        ListGrid_Goal_refresh();
                        setTimeout(function () {
                            ListGrid_Goal.setSelectedState(gridState);
                        }, 1000);
                        Window_Goal.close();
                    } else {
                        simpleDialog("پیغام", "اجرای عملیات با مشکل مواجه شده است!", "3000", "error")
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
            titleFa = DynamicForm_Syllabus.getValue('titleFa')
            titleEn = DynamicForm_Syllabus.getValue('titleEn')
            goalId = DynamicForm_Syllabus.getValue('goalId')
            practicalDuration = DynamicForm_Syllabus.getValue('practicalDuration')
            eDomainType = DynamicForm_Syllabus.getValue('edomainTypeId')
            var data = {
                "titleFa": titleFa,
                "titleEn": titleEn,
                "goalId": goalId,
                "practicalDuration": practicalDuration,
                "eDomainTypeId": eDomainType
            };
            // var data = DynamicForm_Syllabus.getValuesForm();
            isc.RPCManager.sendRequest({
                actionURL: urlSyllabus,
                httpMethod: methodSyllabus,
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
                        simpleDialog("انجام فرمان", "عملیات با موفقیت انجام شد.", "3000", "say")
                        ListGrid_Syllabus_Goal.invalidateCache();
                        setTimeout(function () {
                            ListGrid_Syllabus_Goal.setSelectedState(gridState);
                        }, 1000);
                        Window_Syllabus.close();
                    } else {
                        simpleDialog("پیغام", "اجرای عملیات با مشکل مواجه شده است!", "3000", "error")
                    }

                }
            });
        }
    });

    var Hlayout_Goal_SaveOrExit = isc.MyHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        align: "center",
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

    var Hlayout_Syllabus_SaveOrExit = isc.MyHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        align: "center",
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

    var Window_Syllabus = isc.MyWindow.create({
        title: "سرفصل",
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        showFooter: true,
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "350",
            height: "150",
            members: [DynamicForm_Syllabus, Hlayout_Syllabus_SaveOrExit]
        })]
    });

    var Window_Goal = isc.MyWindow.create({
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
                window.open("/syllabus/print-one-course/" + ListGrid_Course.getSelectedRecord().id + "/pdf");
            }
        }, {
            title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
                window.open("/syllabus/print-one-course/" + ListGrid_Course.getSelectedRecord().id + "/excel")
            }
        }, {
            title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
                window.open("/syllabus/print-one-course/" + ListGrid_Course.getSelectedRecord().id + "/html")
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
                ListGrid_Goal_Add();
            }
        }, {
            title: "افزودن", icon: "pieces/16/icon_add_files.png", click: function () {
                Window_AddGoal.setTitle("افزودن هدف به دوره " + courseId.titleFa);
                Window_AddGoal.show();
                ListGrid_CourseGoal_Goal.invalidateCache();
                RestDataSource_GoalAll.fetchDataURL = courseUrl +"goal/" + courseId.id;
                ListGrid_GoalAll.invalidateCache();
                <%--window.open("<spring:url value="/goal/print/pdf"/>");--%>
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
                window.open("/goal/print-one-course/" + ListGrid_Course.getSelectedRecord().id + "/pdf")
            }
        }, {
            title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
                window.open("/goal/print-one-course/" + ListGrid_Course.getSelectedRecord().id + "/excel")
            }
        }, {
            title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
                window.open("/goal/print-one-course/" + ListGrid_Course.getSelectedRecord().id + "/html")
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
    var ListGrid_Syllabus_Goal = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Syllabus,
        // groupByField:"goal.titleFa", groupStartOpen:"all",
        showGridSummary:true,
        // showGroupSummary:true,
        contextMenu: Menu_ListGrid_Syllabus_Goal,
        doubleClick: function () {
            ListGrid_Syllabus_Goal_Edit();
        },
        getCellCSSText: function (record, rowNum, colNum) {
            if (ListGrid_Goal.getSelectedRecord() != null && record.goalId == selectedRecord) {
                return "color: brown;font-size: 14px;";
            } else {
                return "color:gray;font-size: 10px;";
            }
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد سرفصل", align: "center", hidden: true},
            {name: "titleFa", title: "نام فارسی سرفصل", align: "center"},
            {name: "titleEn", title: "نام لاتین سرفصل", align: "center"},
            {name: "edomainType.titleFa", title: "حیطه", align: "center"},
            {name: "practicalDuration", title: "مدت زمان اجرا", align: "center", summaryFunction:"sum"},
            {name: "version", title: "version", canEdit: false, hidden: true},
            {name: "goal.titleFa",hidden: true}
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
        showHeader: true,
        expansionFieldImageShowSelected: false,
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
            RestDataSource_Syllabus_JspGoal.fetchDataURL = goalUrl + record.id + "/syllabus";
        },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
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
    var ListGrid_CourseGoal_Goal = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        alternateRecordStyles: true,
        expansionFieldImageShowSelected: false,
        canExpandRecords: true,
        expansionMode: "related",
        detailDS: RestDataSource_Syllabus_JspGoal,
        expansionRelatedProperties: {
            border: "1px solid inherit",
            margin: 5
        },
        dataSource: RestDataSource_CourseGoal,
        selectionChanged: function (record, state) {
            RestDataSource_Syllabus_JspGoal.fetchDataURL = goalUrl + record.id + "/syllabus";
        },
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "اهداف دوره", align: "center"},
            {name: "titleEn", title: "نام لاتین هدف", align: "center", hidden: true},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "multiple",
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
        title: "ویرایش",
        click: function () {
            ListGrid_Syllabus_Goal_Edit();
        }
    });
    var ToolStripButton_Syllabus_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {
            ListGrid_Syllabus_Goal_Add();
        }
    });
    var ToolStripButton_Syllabus_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            ListGrid_Syllabus_Goal_Remove();
        }
    });
    var Menu_Print_GoalJsp = isc.Menu.create({
        ID: "menuPalette",
        autoDraw: false,
        showShadow: true,
        shadowDepth: 10
    });
    var ToolStripButton_Syllabus_Print = isc.ToolStripMenuButton.create({
        // icon: "[SKIN]/RichTextEditor/print.png",
        autoDraw: false,
        width: 100,
        title: "چاپ",
        showMenuOnRollOver: true,
        menu: menuPalette,
        mouseMove: function () {
            // ToolStripButton_Syllabus_Print.hideClickMask();
            if (ListGrid_Goal.getSelectedRecord() == null) {
                Menu_Print_GoalJsp.setData([{
                    title: "همه اهداف",
                    click: 'window.open("<spring:url value="goal/print-all/pdf"/>")'
                }, {
                    title: "اهداف دوره " + '"' + ListGrid_Course.getSelectedRecord().titleFa + '"',
                    click: 'window.open("goal/print-one-course/"+ListGrid_Course.getSelectedRecord().id+"/pdf")'
                }, {isSeparator: true}, {
                    title: "همه سرفصل ها",
                    click: 'window.open("<spring:url value="syllabus/print/pdf"/>")'
                }, {
                    title: "سرفصل هاي دوره " + '"' + ListGrid_Course.getSelectedRecord().titleFa + '"',
                    click: 'window.open("syllabus/print-one-course/"+ListGrid_Course.getSelectedRecord().id+"/pdf")'
                }])
            } else {
                Menu_Print_GoalJsp.setData([{
                    title: "همه اهداف",
                    click: 'window.open("<spring:url value="goal/print-all/pdf"/>")'
                }, {
                    title: "اهداف دوره " + '"' + ListGrid_Course.getSelectedRecord().titleFa + '"',
                    click: 'window.open("goal/print-one-course/"+ListGrid_Course.getSelectedRecord().id+"/pdf")'
                }, {isSeparator: true}, {
                    title: "همه سرفصل ها",
                    click: 'window.open("<spring:url value="syllabus/print/pdf"/>")'
                }, {
                    title: "سرفصل هاي دوره " + '"' + ListGrid_Course.getSelectedRecord().titleFa + '"',
                    click: 'window.open("syllabus/print-one-course/"+ListGrid_Course.getSelectedRecord().id+"/pdf")'
                },
                    {
                        title: "سرفصل هاي هدف " + '"' + ListGrid_Goal.getSelectedRecord().titleFa + '"',
                        click: 'window.open("syllabus/print-one-goal/"+ListGrid_Goal.getSelectedRecord().id+"/pdf")'
                    }])
            }
        }
    });
    var ToolStripButton_Goal_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "بازخوانی",
        click: function () {
            ListGrid_Goal_refresh();
            ListGrid_Syllabus_Goal_refresh();
        }
    });
    var ToolStripButton_Goal_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        prompt: "اخطار<br/>ویرایش هدف در تمامی دوره های ارضا کننده هدف نیز اعمال خواهد شد.",
        hoverWidth: 320,
        click: function () {
            ListGrid_Goal_Edit();
        }
    });
    var ToolStripButton_Goal_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        prompt: "تعریف هدف جدید برای دوره مذکور",
        hoverWidth: 160,
        click: function () {
            ListGrid_Goal_Add();
        }
    });
    var ToolStripButton_Goal_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        prompt: "اخطار<br/>هدف انتخاب شده از تمامی دوره های موجود حذف خواهد شد.",
        hoverWidth: 280,
        click: function () {
            ListGrid_Goal_Remove();
        }
    });
    var ToolStripButton_Goal_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/plus.png",
        prompt: "افزودن اهداف انتخاب شده به دوره مذکور و یا گرفتن اهداف انتخاب شده از دوره مذکور",
        hoverWidth: "12%",
        title: "افزودن",
        click: function () {
            Window_AddGoal.setTitle("افزودن هدف به دوره " + courseId.titleFa);
            Window_AddGoal.show();
            ListGrid_CourseGoal_Goal.invalidateCache();
            RestDataSource_GoalAll.fetchDataURL = courseUrl + "goal/" + courseId.id;
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
                        actionURL: courseUrl + courseId.id + "/" + goalList.toString(),
                        httpMethod: "GET",
                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
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
                                simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 3000, "stop");
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

                        actionURL: courseUrl + "remove/" + courseId.id + "/" + arryRecord.toString(),
                        httpMethod: "GET",
                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
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
                                simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                            }

                        }
                    });
                }
            }
        }
    });
    var ToolStrip_Actions_Goal = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Goal_Refresh, "separator", ToolStripButton_Goal_Add, ToolStripButton_Goal_Edit, ToolStripButton_Goal_Remove, ToolStripButton_Goal_Print]
    });
    var ToolStrip_Actions_Syllabus = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Syllabus_Print, "separator", ToolStripButton_Syllabus_Add, ToolStripButton_Syllabus_Edit, ToolStripButton_Syllabus_Remove]
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
        height: "100%",
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
        width: "90%",
        height: "90%",
        canDragReposition: false,
        showShadow: true,
        shadowSoftness: 10,
        shadowOffset: 20,
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
                            actionURL: goalUrl + "delete/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Goal.invalidateCache();
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
            ListGrid_Syllabus_Goal_refresh();
        }
    };

    function ListGrid_Goal_Edit() {
        var record = ListGrid_Goal.getSelectedRecord();
        // selectedRecord = ListGrid_Goal.getRowNum(record);
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
            methodGoal = "PUT";
            urlGoal = goalUrl + record.id;
            DynamicForm_Goal.clearValues();
            DynamicForm_Goal.editRecord(record);
            Window_Goal.setTitle("ویرایش هدف");
            Window_Goal.show();
        }
    };

    function ListGrid_Goal_refresh() {
        // var record = ListGrid_Goal.getSelectedRecord();
        // if (record == null || record.id == null) {
        // } else {
        //     ListGrid_Goal.selectRecord(record);
        // }
        // RestDataSource_CourseGoal.fetchDataURL = courseUrl + ""
        RestDataSource_CourseGoal.fetchDataURL = courseUrl + ListGrid_Course.getSelectedRecord().id + "/goal";
        ListGrid_Goal.invalidateCache();
        ListGrid_Syllabus_Goal.invalidateCache();
    }

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
            urlGoal = goalUrl + "create/" + courseId.id;
            DynamicForm_Goal.clearValues();
            Window_Goal.setTitle("ایجاد هدف");
            Window_Goal.show();
        }
    };

    function ListGrid_Syllabus_Goal_Remove() {
        var record = ListGrid_Syllabus_Goal.getSelectedRecord();
        //console.log(record);
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
                            actionURL: syllabusUrl + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
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
                                    simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
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
            methodSyllabus = "POST";
            urlSyllabus = syllabusUrl;
            DynamicForm_Syllabus.clearValues();
            DynamicForm_Syllabus.getItem("goalId").setValue(gRecord.id);
            Window_Syllabus.setTitle("ایجاد سرفصل");
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
            urlSyllabus = syllabusUrl + sRecord.id;
            DynamicForm_Syllabus.clearValues();
            DynamicForm_Syllabus.editRecord(sRecord);
            Window_Syllabus.setTitle("ویرایش سرفصل");
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

    //</script>