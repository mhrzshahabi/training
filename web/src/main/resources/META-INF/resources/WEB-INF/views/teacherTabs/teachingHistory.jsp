<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var methodTeachingHistory = "GET";
    var saveActionUrlTeachingHistory;
    var waitTeachingHistory;
    var teacherIdTeachingHistory = null;
    var isCategoriesChanged_JspTeachingHistory = false;
    var startDateCheck_JSPTeachHistory= true;
    var endDateCheck_JSPTeachHistory= true;
    var dateCheck_Order_JSPTeachHistory= true;

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspTeachingHistory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "courseTitle", filterOperator: "iContains"},
            {name: "educationLevel.titleFa", filterOperator: "equals"},
            {name: "duration"},
            {name: "categories"},
            {name: "subCategories"},
            {name: "categoriesIds", filterOperator: "inSet"},
            {name: "subCategoriesIds", filterOperator: "inSet"},
            {name: "studentsLevel.title"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "companyName", filterOperator: "iContains"}
        ]
    });

    RestDataSource_Category_JspTeachingHistory = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_SubCategory_JspTeachingHistory = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    RestDataSource_EducationLevel_JspTeachingHistory = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: educationLevelUrl + "spec-list-by-id"
    });

    RestDataSource_Students_Level_JspTeachingHistory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/StudentsLevel"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspTeachingHistory = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "courseTitle",
                title: "<spring:message code='course.title'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                validators: [
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    }]
            },
            {
                name: "companyName",
                title: "<spring:message code='company.name'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                validators: [
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    }]
            },
            {
                name: "educationLevelId",
                title: "<spring:message code='education.level'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_EducationLevel_JspTeachingHistory,
                autoFetchData: false,
                filterFields: ["titleFa","titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%"
                    }
                ]
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspTeachingHistory,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                required: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                changed: function () {
                    isCategoriesChanged_JspTeachingHistory = true;
                    var subCategoryField = DynamicForm_JspTeachingHistory.getField("subCategories");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    var categoryIds = this.getValue();
                    var SubCats = [];
                    for (var i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    SubCats = SubCats.isEmpty() ? null : SubCats;
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "subCategories",
                title: "<spring:message code='subcategory'/>",
                type: "SelectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                required: true,
                optionDataSource: RestDataSource_SubCategory_JspTeachingHistory,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                focus: function () {
                    if (isCategoriesChanged_JspTeachingHistory) {
                        isCategoriesChanged_JspTeachingHistory = false;
                        var ids = DynamicForm_JspTeachingHistory.getField("categories").getValue();
                        if (ids == null || ids.isEmpty()) {
                            RestDataSource_SubCategory_JspTeachingHistory.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspTeachingHistory.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
                }
            },
            {
                name: "studentsLevelId",
                editorType: "ComboBoxItem",
                title: "سطح فراگیران",
                optionDataSource: RestDataSource_Students_Level_JspTeachingHistory,
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {
                name: "duration",
                title: "<spring:message code='duration'/>",
                type: "IntegerItem",
                keyPressFilter: "[0-9]",
                hint: "<spring:message code='hour'/>",
                showHintInField: true,
                length: 3,
                editorExit: function (form, item, value) {
                    var newValue = parseInt(value);
                    item.setValue(newValue);
                }
            },
            {
                name: "startDate",
                ID: "teachingHistories_startDate_JspTeachingHistory",
                title: "<spring:message code='start.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('teachingHistories_startDate_JspTeachingHistory', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    var dateCheck;
                    var endDate = form.getValue("endDate");
                    dateCheck = checkBirthDate(value);
                    if (dateCheck === false) {
                        startDateCheck_JSPTeachHistory = false;
                        dateCheck_Order_JSPTeachHistory = true;
                        form.clearFieldErrors("startDate", true);
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        if (DynamicForm_JspTeachingHistory.getValue("endDate") == undefined) {
                            DynamicForm_JspTeachingHistory.getField("endDate").setValue(todayDate);
                        }
                        dateCheck_Order_JSPTeachHistory = false;
                        startDateCheck_JSPTeachHistory = true;
                        form.clearFieldErrors("startDate", true);
                        form.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        if (DynamicForm_JspTeachingHistory.getValue("endDate") == undefined) {
                            DynamicForm_JspTeachingHistory.getField("endDate").setValue(todayDate);
                        }
                        startDateCheck_JSPTeachHistory = true;
                        dateCheck_Order_JSPTeachHistory = true;
                        form.clearFieldErrors("startDate", true);
                    }
                }
            },
            {
                name: "endDate",
                ID: "teachingHistories_endDate_JspTeachingHistory",
                title: "<spring:message code='end.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        if (!(form.getValue("startDate"))) {
                            dialogTeacher = isc.MyOkDialog.create({
                                message: "ابتدا تاریخ شروع را انتخاب کنید"
                            });
                            dialogTeacher.addProperties({
                                buttonClick: function () {
                                    this.close();
                                    form.getItem("startDate").selectValue();
                                }
                            });
                        } else {
                            closeCalendarWindow();
                            displayDatePicker('teachingHistories_endDate_JspTeachingHistory', this, 'ymd', '/');
                        }
                    }
                }],
                editorExit: function (form, item, value) {
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate");
                    if (dateCheck === false) {
                        endDateCheck_JSPTeachHistory = false;
                        dateCheck_Order_JSPTeachHistory = true;
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (value < startDate) {
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDateCheck_JSPTeachHistory = true;
                        dateCheck_Order_JSPTeachHistory = false;
                    } else {
                        form.clearFieldErrors("endDate", true);
                        endDateCheck_JSPTeachHistory = true;
                        dateCheck_Order_JSPTeachHistory = true;
                    }
                }
            }
        ]
    });

    IButton_Save_JspTeachingHistory = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_JspTeachingHistory.validate();
            if (!DynamicForm_JspTeachingHistory.valuesHaveChanged() ||
                !DynamicForm_JspTeachingHistory.validate() ||
                dateCheck_Order_JSPTeachHistory == false ||
                dateCheck_Order_JSPTeachHistory == false ||
                endDateCheck_JSPTeachHistory == false ||
                startDateCheck_JSPTeachHistory == false) {

                if (dateCheck_Order_JSPTeachHistory == false){
                    DynamicForm_JspTeachingHistory.clearFieldErrors("endDate", true);
                    DynamicForm_JspTeachingHistory.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (dateCheck_Order_JSPTeachHistory == false){
                    DynamicForm_JspTeachingHistory.clearFieldErrors("startDate", true);
                    DynamicForm_JspTeachingHistory.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (endDateCheck_JSPTeachHistory == false){
                    DynamicForm_JspTeachingHistory.clearFieldErrors("endDate", true);
                    DynamicForm_JspTeachingHistory.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                }
                if (startDateCheck_JSPTeachHistory == false){
                    DynamicForm_JspTeachingHistory.clearFieldErrors("startDate", true);
                    DynamicForm_JspTeachingHistory.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                }
                return;
            }

            if (DynamicForm_JspTeachingHistory.getValue("startDate") != undefined && DynamicForm_JspTeachingHistory.getValue("endDate") == undefined) {
                DynamicForm_JspTeachingHistory.clearFieldErrors("endDate", true);
                DynamicForm_JspTeachingHistory.getField("endDate").setValue(todayDate);
            }

            waitTeachingHistory = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlTeachingHistory,
                methodTeachingHistory,
                JSON.stringify(DynamicForm_JspTeachingHistory.getValues()),
                "callback: TeachingHistory_save_result(rpcResponse)"));
        }
    });

    IButton_Cancel_JspTeachingHistory = isc.TrCancelBtn.create({
        click: function () {
            DynamicForm_JspTeachingHistory.clearValues();
            Window_JspTeachingHistory.close();
        }
    });

    HLayout_SaveOrExit_JspTeachingHistory = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspTeachingHistory, IButton_Cancel_JspTeachingHistory]
    });

    Window_JspTeachingHistory = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='teachingHistory'/>",
        close : function(){closeCalendarWindow(); Window_JspTeachingHistory.hide()},
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspTeachingHistory, HLayout_SaveOrExit_JspTeachingHistory]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspTeachingHistory = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_TeachingHistory_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_TeachingHistory_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_TeachingHistory_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_TeachingHistory_Remove();
            }
        }
        ]
    });

    ListGrid_JspTeachingHistory = isc.TrLG.create({
        dataSource: RestDataSource_JspTeachingHistory,
        contextMenu: Menu_JspTeachingHistory,
        fields: [
            {
                name: "courseTitle",
                title: "<spring:message code='course.title'/>",
            },
            {
                name: "companyName",
                title: "<spring:message code='company.name'/>",
            },
            {
                name: "educationLevel.titleFa",
                title: "<spring:message code='education.level'/>"
            },
            {
                name: "categoriesIds",
                title: "<spring:message code='category'/>",
                type: "SelectItem",
                optionDataSource: RestDataSource_Category_JspTeachingHistory,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                canSort: false,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_Category_JspTeachingHistory,
                    valueField: "id",
                    displayField: "titleFa",
                    autoFetchData: true,
                    filterFields: ["titleFa","titleFa"],
                    textMatchStyle: "substring",
                    generateExactMatchCriteria: true,
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    },
                    pickListFields: [
                        {name: "titleFa"}
                    ]
                }
            },
            {
                name: "subCategoriesIds",
                title: "<spring:message code='subcategory'/>",
                type: "ComboBoxItem",
                optionDataSource: RestDataSource_SubCategory_JspTeachingHistory,
                valueField: "id",
                displayField: "titleFa",
                canSort: false,
                filterOnKeypress: true,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_SubCategory_JspTeachingHistory,
                    valueField: "id",
                    displayField: "titleFa",
                    autoFetchData: true,
                    filterFields: ["titleFa","titleFa"],
                    textMatchStyle: "substring",
                    generateExactMatchCriteria: true,
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    },
                    pickListFields: [
                        {name: "titleFa"}
                    ]
                }
            },
            {
                name: "studentsLevel.title",
                title: "سطح فراگیران"
            },
            {
                name: "duration",
                title: "<spring:message code='duration'/>",
                filterOperator: "equals",
                type: "integer",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            }
        ],
        doubleClick: function () {
            ListGrid_TeachingHistory_Edit();
        },
        filterEditorSubmit: function () {
            ListGrid_JspTeachingHistory.invalidateCache();
        },
        align: "center",
        filterOperator: "iContains",
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    ToolStripButton_Refresh_JspTeachingHistory = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_TeachingHistory_refresh();
        }
    });

    ToolStripButton_Edit_JspTeachingHistory = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_TeachingHistory_Edit();
        }
    });
    ToolStripButton_Add_JspTeachingHistory = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_TeachingHistory_Add();
        }
    });
    ToolStripButton_Remove_JspTeachingHistory = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_TeachingHistory_Remove();
        }
    });

    ToolStrip_Actions_JspTeachingHistory = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspTeachingHistory,
                ToolStripButton_Edit_JspTeachingHistory,
                ToolStripButton_Remove_JspTeachingHistory,
                isc.ToolStripButtonExcel.create({
                    click: function () {
                        ExportToFile.downloadExcelRestUrl(null, ListGrid_JspTeachingHistory, teachingHistoryUrl + "/iscList/" + teacherIdTeachingHistory, 0,null, '', "استاد - اطلاعات پايه - سوابق تدريس خارجي", ListGrid_JspTeachingHistory.getCriteria(), null)
                    }
                }),
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspTeachingHistory
                    ]
                })
            ]
    });

    VLayout_Body_JspTeachingHistory = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspTeachingHistory,
            ListGrid_JspTeachingHistory
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_TeachingHistory_refresh() {
        ListGrid_JspTeachingHistory.invalidateCache();
        ListGrid_JspTeachingHistory.filterByEditor();
    }

    function ListGrid_TeachingHistory_Add() {
        methodTeachingHistory = "POST";
        saveActionUrlTeachingHistory = teachingHistoryUrl + "/" + teacherIdTeachingHistory;
        DynamicForm_JspTeachingHistory.clearValues();
        RestDataSource_SubCategory_JspTeachingHistory.implicitCriteria = null;
        DynamicForm_JspTeachingHistory.getField("subCategories").disable();
        Window_JspTeachingHistory.show();
    }

    function ListGrid_TeachingHistory_Edit() {
        var record = ListGrid_JspTeachingHistory.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodTeachingHistory = "PUT";
            saveActionUrlTeachingHistory = teachingHistoryUrl + "/" + record.id;
            DynamicForm_JspTeachingHistory.clearValues();
            var clonedRecord = Object.assign({}, record);
            clonedRecord.categories = null;
            clonedRecord.subCategories = null;
            DynamicForm_JspTeachingHistory.editRecord(clonedRecord);
            if (record.categories == null || record.categories.isEmpty())
                DynamicForm_JspTeachingHistory.getField("subCategories").disable();
            else {
                DynamicForm_JspTeachingHistory.getField("subCategories").enable();
                var catIds = [];
                for (var i = 0; i < record.categories.length; i++)
                    catIds.add(record.categories[i].id);
                DynamicForm_JspTeachingHistory.getField("categories").setValue(catIds);
                isCategoriesChanged_JspTeachingHistory = true;
                DynamicForm_JspTeachingHistory.getField("subCategories").focus(null, null);
            }
            if (record.subCategories != null && !record.subCategories.isEmpty()) {
                var subCatIds = [];
                for (var i = 0; i < record.subCategories.length; i++)
                    subCatIds.add(record.subCategories[i].id);
                DynamicForm_JspTeachingHistory.getField("subCategories").setValue(subCatIds);
            }
            Window_JspTeachingHistory.show();
        }
    }

    function ListGrid_TeachingHistory_Remove() {
        var record = ListGrid_JspTeachingHistory.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitTeachingHistory = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(teachingHistoryUrl +
                            "/" +
                            teacherIdTeachingHistory +
                            "," +
                            ListGrid_JspTeachingHistory.getSelectedRecord().id,
                            "DELETE",
                            null,
                            "callback: TeachingHistory_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function TeachingHistory_save_result(resp) {
        waitTeachingHistory.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_TeachingHistory_refresh();
            Window_JspTeachingHistory.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>",
                    "<spring:message code="message"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>",
                    "<spring:message code="message"/>");
            }
        }
    }

    function TeachingHistory_remove_result(resp) {
        waitTeachingHistory.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_TeachingHistory_refresh();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            var respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function loadPage_TeachingHistory(id) {
        if (teacherIdTeachingHistory !== id) {
            teacherIdTeachingHistory = id;
            RestDataSource_JspTeachingHistory.fetchDataURL = teachingHistoryUrl + "/iscList/" + teacherIdTeachingHistory;
            ListGrid_JspTeachingHistory.fetchData();
            ListGrid_TeachingHistory_refresh();
        }
    }

    function clear_TeachingHistory() {
        ListGrid_JspTeachingHistory.clear();
    }

    //</script>