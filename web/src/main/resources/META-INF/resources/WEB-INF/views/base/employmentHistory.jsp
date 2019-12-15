<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let methodEmploymentHistory = "GET";
    let saveActionUrlEmploymentHistory;
    let waitEmploymentHistory;
    let teacherIdEmploymentHistory = null;
    let isCategoriesChanged = false;

    //--------------------------------------------------------------------------------------------------------------------//
    /*EmploymentHistory*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspEmploymentHistory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "companyName", filterOperator: "iContains"},
            {name: "jobTitle", filterOperator: "iContains"},
            {name: "categories", filterOperator: "iContains"},
            {name: "subCategories", filterOperator: "iContains"},
            {name: "persianStartDate"},
            {name: "persianEndDate"}
        ]
    });

    RestDataSource_Category_JspEmploymentHistory = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_SubCategory_JspEmploymentHistory = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    DynamicForm_JspEmploymentHistory = isc.DynamicForm.create({
        fields: [
            {name: "id", hidden: true},
            {
                name: "companyName",
                title: "نام سازمان",
            },
            {
                name: "jobTitle",
                title: "عنوان شغل",
            },
            {
                name: "categories",
                type: "selectItem",
                textAlign: "center",
                title: "<spring:message code='category'/>",
                optionDataSource: RestDataSource_Category_JspEmploymentHistory,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                },
                changed: function () {
                    isCategoriesChanged = true;
                    let categoryField = DynamicForm_JspEmploymentHistory.getField("categories");
                    let subCategoryField = DynamicForm_JspEmploymentHistory.getField("subCategories");
                    if (categoryField.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    let subCategories = subCategoryField.getSelectedRecords();
                    let categoryIds = categoryField.getValue();
                    let SubCats = [];
                    for (let i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                }
            },
            {
                name: "subCategories",
                type: "selectItem",
                textAlign: "center",
                title: "<spring:message code='subcategory'/>",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspEmploymentHistory,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                },
                focus: function () {
                    if (isCategoriesChanged) {
                        isCategoriesChanged = false;
                        let ids = DynamicForm_JspEmploymentHistory.getField("categories").getValue();
                        if (ids === []) {
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
                name: "persianStartDate",
                title: "تاریخ شروع",
                ID: "employmentHistories_startDate_JspEmploymentHistory",
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('employmentHistories_startDate_JspEmploymentHistory', this, 'ymd', '/');
                    }
                }],
                changed: function () {
                }
            },
            {
                name: "persianEndDate",
                title: "تاریخ پایان",
                ID: "employmentHistories_endDate_JspEmploymentHistory",
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('employmentHistories_endDate_JspEmploymentHistory', this, 'ymd', '/');
                    }
                }],
                changed: function () {
                }
            }
        ],
        itemChanged: function (item, newValue) {
        }
    });

    IButton_Save_JspEmploymentHistory = isc.TrSaveBtn.create({
        top: 260,
        click: function () {

            DynamicForm_JspEmploymentHistory.validate();
            if (DynamicForm_JspEmploymentHistory.hasErrors()) {
                return;
            }
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlEmploymentHistory,
                methodEmploymentHistory,
                JSON.stringify(DynamicForm_JspEmploymentHistory.getValues()),
                "callback: EmploymentHistory_save_result(rpcResponse)"));
        }
    });

    IButton_Cancel_JspEmploymentHistory = isc.TrCancelBtn.create({
        prompt: "",
        orientation: "vertical",
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
        align: "center",
        border: "1px solid gray",
        title: "سابقه کاری",
        items: [isc.TrVLayout.create({
            width: "500",
            height: "120",
            members: [DynamicForm_JspEmploymentHistory, HLayout_SaveOrExit_JspEmploymentHistory]
        })]
    });


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
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {name: "id", hidden: true},
            {
                name: "companyName",
                title: "نام سازمان",
            },
            {
                name: "jobTitle",
                title: "عنوان شغل",
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                // canFilter: false,
                formatCellValue: function (value) {
                    if (value.length === 0)
                        return;
                    value.sort();
                    let cat = value[0].titleFa.toString();
                    for (let i = 1; i < value.length; i++) {
                        cat += "، " + value[i].titleFa;
                    }
                    return cat;
                },
                sortNormalizer: function (value) {
                    if (value.categories.length === 0)
                        return;
                    value.categories.sort();
                    let cat = value.categories[0].titleFa.toString();
                    for (let i = 1; i < value.categories.length; i++) {
                        cat += "، " + value.categories[i].titleFa;
                    }
                    return cat;
                }
            },
            {
                name: "subCategories",
                title: "<spring:message code='subcategory'/>",
                // canFilter: false,
                formatCellValue: function (value) {
                    if (value.length === 0)
                        return;
                    value.sort();
                    let subCat = value[0].titleFa.toString();
                    for (let i = 1; i < value.length; i++) {
                        subCat += "، " + value[i].titleFa;
                    }
                    return subCat;
                },
                sortNormalizer: function (value) {
                    if (value.subCategories.length === 0)
                        return;
                    value.subCategories.sort();
                    let subCat = value.subCategories[0].titleFa.toString();
                    for (let i = 1; i < value.subCategories.length; i++) {
                        subCat += "، " + value.subCategories[i].titleFa;
                    }
                    return subCat;
                }
            },
            {
                name: "persianStartDate",
                title: "تاریخ شروع",
                canFilter: false,
                canSort: false
            },
            {
                name: "persianEndDate",
                title: "تاریخ پایان",
                canFilter: false,
                canSort: false
            }
        ],
        doubleClick: function () {
            ListGrid_EmploymentHistory_Edit();
        }

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
    ToolStripButton_Add_JspEmploymentHistory = isc.ToolStripButtonAdd.create({
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

    function ListGrid_EmploymentHistory_refresh() {
        ListGrid_JspEmploymentHistory.invalidateCache();
        // ListGrid_JspEmploymentHistory.filterByEditor();
        // ListGrid_JspEmploymentHistory.refreshFields();
    }

    function ListGrid_EmploymentHistory_Add() {
        methodEmploymentHistory = "POST";
        saveActionUrlEmploymentHistory = teacherUrl + "employment-history/" + teacherIdEmploymentHistory;
        DynamicForm_JspEmploymentHistory.clearValues();
        Window_JspEmploymentHistory.show();
    }

    function ListGrid_EmploymentHistory_Edit() {
        let record = ListGrid_JspEmploymentHistory.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodEmploymentHistory = "PUT";
            saveActionUrlEmploymentHistory = employmentHistoryUrl + "/" + record.id;
            DynamicForm_JspEmploymentHistory.clearValues();
            DynamicForm_JspEmploymentHistory.editRecord(record);
            let categoryIds = DynamicForm_JspEmploymentHistory.getField("categories").getValue();
            let subCategoryIds = DynamicForm_JspEmploymentHistory.getField("subCategories").getValue();
            if (categoryIds == null || categoryIds.length === 0)
                DynamicForm_JspEmploymentHistory.getField("subCategories").disable();
            else {
                DynamicForm_JspEmploymentHistory.getField("subCategories").enable();
                let catIds = [];
                for (let i = 0; i < categoryIds.length; i++)
                    catIds.add(categoryIds[i].id);
                DynamicForm_JspEmploymentHistory.getField("categories").setValue(catIds);
                isCategoriesChanged = true;
                DynamicForm_JspEmploymentHistory.getField("subCategories").focus(null, null);
            }
            if (subCategoryIds != null && subCategoryIds.length > 0) {
                let subCatIds = [];
                for (let i = 0; i < subCategoryIds.length; i++)
                    subCatIds.add(subCategoryIds[i].id);
                DynamicForm_JspEmploymentHistory.getField("subCategories").setValue(subCatIds);
            }
            Window_JspEmploymentHistory.show();
        }
    }

    function ListGrid_EmploymentHistory_Remove() {
        let record = ListGrid_JspEmploymentHistory.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        attachmentWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "employment-history/" + teacherIdEmploymentHistory + "," + ListGrid_JspEmploymentHistory.getSelectedRecord().id, "DELETE", null, "callback: EmploymentHistory_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function EmploymentHistory_save_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_EmploymentHistory_refresh();
            // Window_JspEmploymentHistory.close();
        }
    }

    function EmploymentHistory_remove_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_EmploymentHistory_refresh();
            // Window_JspEmploymentHistory.close();
        }
    }

    function loadPage_EmploymentHistory(id) {
        if (teacherIdEmploymentHistory !== id) {
            teacherIdEmploymentHistory = id;
            RestDataSource_JspEmploymentHistory.fetchDataURL = employmentHistoryUrl + "/iscList/" + teacherIdEmploymentHistory;
            ListGrid_JspEmploymentHistory.fetchData();
            ListGrid_EmploymentHistory_refresh();
        }
        else
            ListGrid_JspEmploymentHistory.clear();
    }

    function clear_EmploymentHistory(){
        ListGrid_JspEmploymentHistory.clear();
    }

    //**********************************************************************************************************************
    //**********************************************************************************************************************
    //**********************************************************************************************************************
    //**********************************************************************************************************************


    //</script>