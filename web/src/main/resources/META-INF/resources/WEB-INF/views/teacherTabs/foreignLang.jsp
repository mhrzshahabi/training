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
    /*RestDataSource*/
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
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_SubCategory_JspEmploymentHistory = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: subCategoryUrl + "iscList"
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
                name: "langName",
                title: "عنوان زبان",
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                type: "selectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspEmploymentHistory,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                }
            }
        ]
    });

    IButton_Save_JspEmploymentHistory = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspEmploymentHistory.valuesHaveChanged() || !DynamicForm_JspEmploymentHistory.validate())
                return;
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
            {
                name: "companyName",
                title: "<spring:message code='company.name'/>",
            },
            {
                name: "jobTitle",
                title: "<spring:message code='job.title'/>",
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
                title: "<spring:message code='start.date'/>",
                canFilter: false,
                canSort: false
            },
            {
                name: "persianEndDate",
                title: "<spring:message code='end.date'/>",
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
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
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
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
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