<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var methodEmploymentHistory = "GET";
    var saveActionUrlEmploymentHistory;
    var waitEmploymentHistory;
    var teacherIdEmploymentHistory = null;
    var isCategoriesChanged_JspEmploymentHistory = false;
    var startDateCheck_JSPEmpHistory = true;
    var endDateCheck_JSPEmpHistory = true;
    var dateCheck_Order_JSPEmpHistory = true;

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspEmploymentHistory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "companyName", filterOperator: "iContains"},
            {name: "jobTitle", filterOperator: "iContains"},
            {name: "categoriesIds", filterOperator: "inSet"},
            {name: "subCategoriesIds", filterOperator: "inSet"},
            {name: "categories"},
            {name: "subCategories"},
            {name: "collaborationDuration"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    RestDataSource_Category_JspEmploymentHistory = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_SubCategory_JspEmploymentHistory = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    RestDataSource_Collaboration_Type_JspEmploymentHistory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/CollaborationType"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspEmploymentHistory = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "jobTitle",
                title: "سمت یا موضوع همکاری",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "companyName",
                title: "نام سازمان / امور",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspEmploymentHistory,
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
                    isCategoriesChanged_JspEmploymentHistory = true;
                    var subCategoryField = DynamicForm_JspEmploymentHistory.getField("subCategories");
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
                optionDataSource: RestDataSource_SubCategory_JspEmploymentHistory,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                focus: function () {
                    if (isCategoriesChanged_JspEmploymentHistory) {
                        isCategoriesChanged_JspEmploymentHistory = false;
                        var ids = DynamicForm_JspEmploymentHistory.getField("categories").getValue();
                        if (ids == null || ids.isEmpty()) {
                            RestDataSource_SubCategory_JspEmploymentHistory.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspEmploymentHistory.implicitCriteria = {
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
                name: "collaborationTypeId",
                editorType: "ComboBoxItem",
                title: "نوع همکاری",
                // pickListWidth: 200,
                optionDataSource: RestDataSource_Collaboration_Type_JspEmploymentHistory,
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                // required: true,
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
                name: "collaborationDuration",
                title: "مدت همکاری (ماه)",
                keyPressFilter: "[0-9]"
            },
            {
                name: "startDate",
                ID: "employmentHistories_startDate_JspEmploymentHistory",
                title: "<spring:message code='start.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('employmentHistories_startDate_JspEmploymentHistory', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    var dateCheck;
                    var endDate = form.getValue("endDate");
                    dateCheck = checkBirthDate(value);
                    if (dateCheck === false) {
                        startDateCheck_JSPEmpHistory = false;
                        dateCheck_Order_JSPEmpHistory = true;
                        form.clearFieldErrors("startDate", true);
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        if (DynamicForm_JspEmploymentHistory.getValue("endDate") == undefined) {
                            DynamicForm_JspEmploymentHistory.getField("endDate").setValue(todayDate);
                        }
                        dateCheck_Order_JSPEmpHistory = false;
                        startDateCheck_JSPEmpHistory = true;
                        form.clearFieldErrors("startDate", true);
                        form.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        if (DynamicForm_JspEmploymentHistory.getValue("endDate") == undefined) {
                            DynamicForm_JspEmploymentHistory.getField("endDate").setValue(todayDate);
                        }
                        startDateCheck_JSPEmpHistory = true;
                        dateCheck_Order_JSPEmpHistory = true;
                        form.clearFieldErrors("startDate", true);
                    }
                }
            },
            {
                name: "endDate",
                ID: "employmentHistories_endDate_JspEmploymentHistory",
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
                                message: "ابتدا تاریخ شروع را انتخاب کنید",
                            });
                            dialogTeacher.addProperties({
                                buttonClick: function () {
                                    this.close();
                                    form.getItem("startDate").selectValue();
                                }
                            });
                        } else {
                            closeCalendarWindow();
                            displayDatePicker('employmentHistories_endDate_JspEmploymentHistory', this, 'ymd', '/');
                        }
                    }
                }],
                editorExit: function (form, item, value) {
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate");
                    if (dateCheck === false) {
                        endDateCheck_JSPEmpHistory = false;
                        dateCheck_Order_JSPEmpHistory = true;
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (value < startDate) {
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDateCheck_JSPEmpHistory = true;
                        dateCheck_Order_JSPEmpHistory = false;
                    } else {
                        form.clearFieldErrors("endDate", true);
                        endDateCheck_JSPEmpHistory = true;
                        dateCheck_Order_JSPEmpHistory = true;
                    }
                }
            }
        ]
    });

    IButton_Save_JspEmploymentHistory = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_JspEmploymentHistory.validate();
            if (!DynamicForm_JspEmploymentHistory.valuesHaveChanged() ||
                !DynamicForm_JspEmploymentHistory.validate() ||
                dateCheck_Order_JSPEmpHistory == false ||
                dateCheck_Order_JSPEmpHistory == false ||
                endDateCheck_JSPEmpHistory == false ||
                startDateCheck_JSPEmpHistory == false) {

                if (dateCheck_Order_JSPEmpHistory == false){
                    DynamicForm_JspEmploymentHistory.clearFieldErrors("endDate", true);
                    DynamicForm_JspEmploymentHistory.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                    }
                if (dateCheck_Order_JSPEmpHistory == false){
                    DynamicForm_JspEmploymentHistory.clearFieldErrors("startDate", true);
                    DynamicForm_JspEmploymentHistory.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (endDateCheck_JSPEmpHistory == false){
                    DynamicForm_JspEmploymentHistory.clearFieldErrors("endDate", true);
                    DynamicForm_JspEmploymentHistory.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                }

                if (startDateCheck_JSPEmpHistory == false){
                    DynamicForm_JspEmploymentHistory.clearFieldErrors("startDate", true);
                    DynamicForm_JspEmploymentHistory.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                }

                return;
            }

            if (DynamicForm_JspEmploymentHistory.getValue("startDate") != undefined && DynamicForm_JspEmploymentHistory.getValue("endDate") == undefined) {
                DynamicForm_JspEmploymentHistory.clearFieldErrors("endDate", true);
                DynamicForm_JspEmploymentHistory.getField("endDate").setValue(todayDate);
            }

            waitEmploymentHistory = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlEmploymentHistory,
                methodEmploymentHistory,
                JSON.stringify(DynamicForm_JspEmploymentHistory.getValues()),
                "callback: EmploymentHistory_save_result(rpcResponse)"));
        }
    });

    IButton_Cancel_JspEmploymentHistory = isc.TrCancelBtn.create({
        click: function () {
            DynamicForm_JspEmploymentHistory.clearValues();
            Window_JspEmploymentHistory.close();
        }
    });

    HLayout_SaveOrExit_JspEmploymentHistory = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspEmploymentHistory, IButton_Cancel_JspEmploymentHistory]
    });

    Window_JspEmploymentHistory = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='employmentHistory'/>",
        close : function(){closeCalendarWindow(); Window_JspEmploymentHistory.hide()},
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspEmploymentHistory, HLayout_SaveOrExit_JspEmploymentHistory]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspEmploymentHistory = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_EmploymentHistory_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_EmploymentHistory_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_EmploymentHistory_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_EmploymentHistory_Remove();
            }
        }
        ]
    });

    ListGrid_JspEmploymentHistory = isc.TrLG.create({
        dataSource: RestDataSource_JspEmploymentHistory,
        contextMenu: Menu_JspEmploymentHistory,
        fields: [
            {
                name: "jobTitle",
                title: "<spring:message code='job.title'/>",
            },
            {
                name: "companyName",
                title: "<spring:message code='company.name'/>",
            },
            {
                name: "categoriesIds",
                title: "<spring:message code='category'/>",
                type: "SelectItem",
                optionDataSource: RestDataSource_Category_JspEmploymentHistory,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                canSort: false,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_Category_JspEmploymentHistory,
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
                optionDataSource: RestDataSource_SubCategory_JspEmploymentHistory,
                valueField: "id",
                displayField: "titleFa",
                canSort: false,
                filterOnKeypress: true,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_SubCategory_JspEmploymentHistory,
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
            ListGrid_EmploymentHistory_Edit();
        },
        filterEditorSubmit: function () {
            ListGrid_JspEmploymentHistory.invalidateCache();
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

    ToolStripButton_Refresh_JspEmploymentHistory = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_EmploymentHistory_refresh();
        }
    });

    ToolStripButton_Edit_JspEmploymentHistory = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_EmploymentHistory_Edit();
        }
    });
    ToolStripButton_Add_JspEmploymentHistory = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_EmploymentHistory_Add();
        }
    });
    ToolStripButton_Remove_JspEmploymentHistory = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_EmploymentHistory_Remove();
        }
    });

    ToolStrip_Actions_JspEmploymentHistory = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspEmploymentHistory,
                ToolStripButton_Edit_JspEmploymentHistory,
                ToolStripButton_Remove_JspEmploymentHistory,
                isc.ToolStripButtonExcel.create({
                    click: function () {
                        ExportToFile.downloadExcelRestUrl(null, ListGrid_JspEmploymentHistory, employmentHistoryUrl + "/iscList/" + teacherIdEmploymentHistory, 0,null, '', "استاد - اطلاعات پايه - سابقه کاری", ListGrid_JspEmploymentHistory.getCriteria(), null)
                    }
                }),
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspEmploymentHistory
                    ]
                })
            ]
    });

    VLayout_Body_JspEmploymentHistory = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspEmploymentHistory,
            ListGrid_JspEmploymentHistory
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_EmploymentHistory_refresh() {
        ListGrid_JspEmploymentHistory.invalidateCache();
        ListGrid_JspEmploymentHistory.filterByEditor();
    }

    function ListGrid_EmploymentHistory_Add() {
        methodEmploymentHistory = "POST";
        saveActionUrlEmploymentHistory = employmentHistoryUrl + "/" + teacherIdEmploymentHistory;
        DynamicForm_JspEmploymentHistory.clearValues();
        RestDataSource_SubCategory_JspEmploymentHistory.implicitCriteria = null;
        DynamicForm_JspEmploymentHistory.getField("subCategories").disable();
        Window_JspEmploymentHistory.show();
    }

    function ListGrid_EmploymentHistory_Edit() {
        var record = ListGrid_JspEmploymentHistory.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodEmploymentHistory = "PUT";
            saveActionUrlEmploymentHistory = employmentHistoryUrl + "/" + record.id;
            DynamicForm_JspEmploymentHistory.clearValues();
            var clonedRecord = Object.assign({}, record);
            clonedRecord.categories = null;
            clonedRecord.subCategories = null;
            DynamicForm_JspEmploymentHistory.editRecord(clonedRecord);
            if (record.categories == null || record.categories.isEmpty())
                DynamicForm_JspEmploymentHistory.getField("subCategories").disable();
            else {
                DynamicForm_JspEmploymentHistory.getField("subCategories").enable();
                var catIds = [];
                for (var i = 0; i < record.categories.length; i++)
                    catIds.add(record.categories[i].id);
                DynamicForm_JspEmploymentHistory.getField("categories").setValue(catIds);
                isCategoriesChanged_JspEmploymentHistory = true;
                DynamicForm_JspEmploymentHistory.getField("subCategories").focus(null, null);
            }
            if (record.subCategories != null && !record.subCategories.isEmpty()) {
                var subCatIds = [];
                for (var i = 0; i < record.subCategories.length; i++)
                    subCatIds.add(record.subCategories[i].id);
                DynamicForm_JspEmploymentHistory.getField("subCategories").setValue(subCatIds);
            }
            Window_JspEmploymentHistory.show();
        }
    }

    function ListGrid_EmploymentHistory_Remove() {
        var record = ListGrid_JspEmploymentHistory.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitEmploymentHistory = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(employmentHistoryUrl +
                            "/" +
                            teacherIdEmploymentHistory +
                            "," +
                            ListGrid_JspEmploymentHistory.getSelectedRecord().id,
                            "DELETE",
                            null,
                            "callback: EmploymentHistory_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function EmploymentHistory_save_result(resp) {
        waitEmploymentHistory.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_EmploymentHistory_refresh();
            Window_JspEmploymentHistory.close();
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

    function EmploymentHistory_remove_result(resp) {
        waitEmploymentHistory.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_EmploymentHistory_refresh();
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

    function loadPage_EmploymentHistory(id) {
        if (teacherIdEmploymentHistory !== id) {
            teacherIdEmploymentHistory = id;
            RestDataSource_JspEmploymentHistory.fetchDataURL = employmentHistoryUrl + "/iscList/" + teacherIdEmploymentHistory;
            ListGrid_JspEmploymentHistory.fetchData();
            ListGrid_EmploymentHistory_refresh();
        }
    }

    function clear_EmploymentHistory() {
        ListGrid_JspEmploymentHistory.clear();
    }

    //</script>