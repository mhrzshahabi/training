<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var methodPublication = "GET";
    var saveActionUrlPublication;
    var waitPublication;
    var teacherIdPublication = null;
    var isCategoriesChanged = false;

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspPublication = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "subjectTitle"},
            {name: "categories"},
            {name: "subCategories"},
            {name: "persianPublicationDate"},
            {name: "publicationLocation"},
            {name: "publisher"},
            {name: "publicationSubjectType.titleFa"}
        ]
    });

    RestDataSource_Category_JspPublication = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_SubCategory_JspPublication = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_EPublicationSubjectType_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: enumUrl + "ePublicationSubjectType/spec-list"
    });


    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspPublication = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "subjectTitle",
                title: "<spring:message code='subject.title'/>",
                required: true
            },
            {
                name: "publicationLocation",
                title:"<spring:message code='publication.location'/>"
            },
            {
                name: "publisher",
                title: "<spring:message code='publisher'/>"
            },
            {
                name: "persianPublicationDate",
                ID: "publication_publicationDate_JspPublication",
                title: "<spring:message code='publication.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('publication_publicationDate_JspPublication', this, 'ymd', '/');
                    }
                }],
                validators: [{
                    type: "custom",
                    errorMessage: "<spring:message code='msg.correct.date'/>",
                    condition: function (item, validator, value) {
                        return checkBirthDate(value);
                    }
                }]
            },
            {
                name: "publicationSubjectTypeId",
                type: "IntegerItem",
                title: "<spring:message code="publication.subject.type"/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource:  RestDataSource_EPublicationSubjectType_JspTeacher ,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                type: "selectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspPublication,
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
                    var subCategoryField = DynamicForm_JspPublication.getField("subCategories");
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
                optionDataSource: RestDataSource_SubCategory_JspPublication,
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
                        var ids = DynamicForm_JspPublication.getField("categories").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspPublication.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspPublication.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
                }
            }
        ]
    });

    IButton_Save_JspPublication = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_JspPublication.validate();
            if (!DynamicForm_JspPublication.valuesHaveChanged() || !DynamicForm_JspPublication.validate())
                return;
            waitPublication = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlPublication,
                methodPublication,
                JSON.stringify(DynamicForm_JspPublication.getValues()),
                "callback: Publication_save_result(rpcResponse)"));
        }
    });

    IButton_Cancel_JspPublication = isc.TrCancelBtn.create({
        click: function () {
            DynamicForm_JspPublication.clearValues();
            Window_JspPublication.close();
        }
    });

    HLayout_SaveOrExit_JspPublication = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspPublication, IButton_Cancel_JspPublication]
    });

    Window_JspPublication = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='publication'/>",
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspPublication, HLayout_SaveOrExit_JspPublication]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspPublication = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_Publication_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_Publication_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_Publication_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_Publication_Remove();
            }
        }
        ]
    });

    ListGrid_JspPublication = isc.TrLG.create({
        dataSource: RestDataSource_JspPublication,
        contextMenu: Menu_JspPublication,
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
                name: "subjectTitle",
                title: "<spring:message code='subject.title'/>",
            },
            {
                name: "publicationLocation",
                title:"<spring:message code='publication.location'/>"
            },
            {
                name: "publisher",
                title: "<spring:message code='publisher'/>"
            },
            {
                name: "publicationSubjectType.titleFa",
                title:"<spring:message code='publication.subject.type'/>"
            },
            {
                name: "persianPublicationDate",
                title: "<spring:message code='publication.date'/>",
                canFilter: false,
                canSort: false
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                // canFilter: false,
                formatCellValue: function (value) {
                    if (value.length === 0)
                        return;
                    value.sort();
                    var cat = value[0].titleFa.toString();
                    for (var i = 1; i < value.length; i++) {
                        cat += "، " + value[i].titleFa;
                    }
                    return cat;
                },
                sortNormalizer: function (value) {
                    if (value.categories.length === 0)
                        return;
                    value.categories.sort();
                    var cat = value.categories[0].titleFa.toString();
                    for (var i = 1; i < value.categories.length; i++) {
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
                    var subCat = value[0].titleFa.toString();
                    for (var i = 1; i < value.length; i++) {
                        subCat += "، " + value[i].titleFa;
                    }
                    return subCat;
                },
                sortNormalizer: function (value) {
                    if (value.subCategories.length === 0)
                        return;
                    value.subCategories.sort();
                    var subCat = value.subCategories[0].titleFa.toString();
                    for (var i = 1; i < value.subCategories.length; i++) {
                        subCat += "، " + value.subCategories[i].titleFa;
                    }
                    return subCat;
                }
            }
        ],
        rowDoubleClick: function () {
            ListGrid_Publication_Edit();
        }
    });

    ToolStripButton_Refresh_JspPublication = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Publication_refresh();
        }
    });

    ToolStripButton_Edit_JspPublication = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_Publication_Edit();
        }
    });
    ToolStripButton_Add_JspPublication = isc.ToolStripButtonAdd.create({
        click: function () {
            ListGrid_Publication_Add();
        }
    });
    ToolStripButton_Remove_JspPublication = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_Publication_Remove();
        }
    });

    ToolStrip_Actions_JspPublication = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspPublication,
                ToolStripButton_Edit_JspPublication,
                ToolStripButton_Remove_JspPublication,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspPublication
                    ]
                })
            ]
    });

    VLayout_Body_JspPublication = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspPublication,
            ListGrid_JspPublication
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_Publication_refresh() {
        ListGrid_JspPublication.invalidateCache();
        ListGrid_JspPublication.filterByEditor();
    }

    function ListGrid_Publication_Add() {
        methodPublication = "POST";
        saveActionUrlPublication = publicationUrl + "/" + teacherIdPublication;
        DynamicForm_JspPublication.clearValues();
        Window_JspPublication.show();
    }

    function ListGrid_Publication_Edit() {
        var record = ListGrid_JspPublication.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodPublication = "PUT";
            saveActionUrlPublication = publicationUrl + "/" + record.id;
            DynamicForm_JspPublication.clearValues();
            DynamicForm_JspPublication.editRecord(record);
            var categoryIds = DynamicForm_JspPublication.getField("categories").getValue();
            var subCategoryIds = DynamicForm_JspPublication.getField("subCategories").getValue();
            if (categoryIds == null || categoryIds.length === 0)
                DynamicForm_JspPublication.getField("subCategories").disable();
            else {
                DynamicForm_JspPublication.getField("subCategories").enable();
                var catIds = [];
                for (var i = 0; i < categoryIds.length; i++)
                    catIds.add(categoryIds[i].id);
                DynamicForm_JspPublication.getField("categories").setValue(catIds);
                isCategoriesChanged = true;
                DynamicForm_JspPublication.getField("subCategories").focus(null, null);
            }
            if (subCategoryIds != null && subCategoryIds.length > 0) {
                var subCatIds = [];
                for (var i = 0; i < subCategoryIds.length; i++)
                    subCatIds.add(subCategoryIds[i].id);
                DynamicForm_JspPublication.getField("subCategories").setValue(subCatIds);
            }
            Window_JspPublication.show();
        }
    }

    function ListGrid_Publication_Remove() {
        var record = ListGrid_JspPublication.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitPublication = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(publicationUrl +
                            "/" +
                            teacherIdPublication +
                            "," +
                            ListGrid_JspPublication.getSelectedRecord().id,
                            "DELETE",
                            null,
                            "callback: Publication_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function Publication_save_result(resp) {
        waitPublication.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_Publication_refresh();
            Window_JspPublication.close();
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

    function Publication_remove_result(resp) {
        waitPublication.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Publication_refresh();
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

    function loadPage_Publication(id) {
        if (teacherIdPublication !== id) {
            teacherIdPublication = id;
            RestDataSource_JspPublication.fetchDataURL = publicationUrl + "/iscList/" + teacherIdPublication;
            ListGrid_JspPublication.fetchData();
            ListGrid_Publication_refresh();
        }
    }

    function clear_Publication() {
        ListGrid_JspPublication.clear();
    }

    //</script>