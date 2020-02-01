<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let methodTeachingHistory = "GET";
    let saveActionUrlTeachingHistory;
    let waitTeachingHistory;
    let teacherIdTeachingHistory = null;
    let isCategoriesChanged = false;

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspTeachingHistory = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "courseTitle", filterOperator: "iContains"},
            {name: "educationLevelId", filterOperator: "equals"},
            {name: "duration"},
            {name: "categories"},
            {name: "subCategories"},
            {name: "categoriesIds", filterOperator: "inSet"},
            {name: "subCategoriesIds", filterOperator: "inSet"},
            {name: "persianStartDate"},
            {name: "persianEndDate"},
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
        fetchDataURL: educationUrl + "level/iscList"
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
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "companyName",
                title: "<spring:message code='company.name'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
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
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                type: "selectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspTeachingHistory,
                valueField: "id",
                required: true,
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
                    let subCategoryField = DynamicForm_JspTeachingHistory.getField("subCategories");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    let subCategories = subCategoryField.getSelectedRecords();
                    let categoryIds = this.getValue();
                    let SubCats = [];
                    for (let i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "subCategories",
                title: "<spring:message code='subcategory'/>",
                type: "selectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspTeachingHistory,
                valueField: "id",
                required: true,
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
                        let ids = DynamicForm_JspTeachingHistory.getField("categories").getValue();
                        if (ids === []) {
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
                name: "duration",
                title: "<spring:message code='duration'/>",
                type: "IntegerItem",
                keyPressFilter: "[0-9]",
                hint: "<spring:message code='hour'/>",
                showHintInField: true,
                length: 5
            },
            {
                name: "persianStartDate",
                ID: "teachingHistories_startDate_JspTeachingHistory",
                title: "<spring:message code='start.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('teachingHistories_startDate_JspTeachingHistory', this, 'ymd', '/');
                    }
                }],
                validators: [{
                    type: "custom",
                    errorMessage: "<spring:message code='msg.correct.date'/>",
                    condition: function (item, validator, value) {
                        if (value === undefined)
                            return DynamicForm_JspTeachingHistory.getValue("persianEndDate") === undefined;
                        return checkBirthDate(value);
                    }
                }]
            },
            {
                name: "persianEndDate",
                ID: "teachingHistories_endDate_JspTeachingHistory",
                title: "<spring:message code='end.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('teachingHistories_endDate_JspTeachingHistory', this, 'ymd', '/');
                    }
                }],
                validators: [{
                    type: "custom",
                    errorMessage: "<spring:message code='msg.correct.date'/>",
                    condition: function (item, validator, value) {
                        if (value === undefined)
                            return DynamicForm_JspTeachingHistory.getValue("persianStartDate") === undefined;
                        if (!checkDate(value))
                            return false;
                        if (DynamicForm_JspTeachingHistory.hasFieldErrors("persianStartDate"))
                            return true;
                        let persianStartDate = JalaliDate.jalaliToGregori(DynamicForm_JspTeachingHistory.getValue("persianStartDate"));
                        let persianEndDate = JalaliDate.jalaliToGregori(DynamicForm_JspTeachingHistory.getValue("persianEndDate"));
                        return Date.compareDates(persianStartDate, persianEndDate) === 1;
                    }
                }]
            }
        ]
    });

    IButton_Save_JspTeachingHistory = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_JspTeachingHistory.validate();
            if (!DynamicForm_JspTeachingHistory.valuesHaveChanged() || !DynamicForm_JspTeachingHistory.validate())
                return;
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
                name: "educationLevelId",
                type: "IntegerItem",
                title: "<spring:message code='education.level'/>",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_EducationLevel_JspTeachingHistory
            },
            {
                name: "categoriesIds",
                title: "<spring:message code='category'/>",
                type: "selectItem",
                optionDataSource: RestDataSource_Category_JspTeachingHistory,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                multiple: true,
                filterLocally: false
            },
            {
                name: "subCategoriesIds",
                title: "<spring:message code='subcategory'/>",
                type: "selectItem",
                optionDataSource: RestDataSource_SubCategory_JspTeachingHistory,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                multiple: true,
                filterLocally: false
            },
            {
                name: "duration",
                title: "<spring:message code='duration'/>",
                filterOperator: "equals"
            },
            {
                name: "persianStartDate",
                title: "<spring:message code='start.date'/>",
                canSort: false
            },
            {
                name: "persianEndDate",
                title: "<spring:message code='end.date'/>",
                canSort: false
            }
        ],
        doubleClick: function () {
            ListGrid_TeachingHistory_Edit();
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
    ToolStripButton_Add_JspTeachingHistory = isc.ToolStripButtonAdd.create({
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
        Window_JspTeachingHistory.show();
    }

    function ListGrid_TeachingHistory_Edit() {
        let record = ListGrid_JspTeachingHistory.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodTeachingHistory = "PUT";
            saveActionUrlTeachingHistory = teachingHistoryUrl + "/" + record.id;
            DynamicForm_JspTeachingHistory.clearValues();
            DynamicForm_JspTeachingHistory.editRecord(record);
            let categoryIds = DynamicForm_JspTeachingHistory.getField("categories").getValue();
            let subCategoryIds = DynamicForm_JspTeachingHistory.getField("subCategories").getValue();
            if (categoryIds == null || categoryIds.length === 0)
                DynamicForm_JspTeachingHistory.getField("subCategories").disable();
            else {
                DynamicForm_JspTeachingHistory.getField("subCategories").enable();
                let catIds = [];
                for (let i = 0; i < categoryIds.length; i++)
                    catIds.add(categoryIds[i].id);
                DynamicForm_JspTeachingHistory.getField("categories").setValue(catIds);
                isCategoriesChanged = true;
                DynamicForm_JspTeachingHistory.getField("subCategories").focus(null, null);
            }
            if (subCategoryIds != null && subCategoryIds.length > 0) {
                let subCatIds = [];
                for (let i = 0; i < subCategoryIds.length; i++)
                    subCatIds.add(subCategoryIds[i].id);
                DynamicForm_JspTeachingHistory.getField("subCategories").setValue(subCatIds);
            }
            Window_JspTeachingHistory.show();
        }
    }

    function ListGrid_TeachingHistory_Remove() {
        let record = ListGrid_JspTeachingHistory.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
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
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
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