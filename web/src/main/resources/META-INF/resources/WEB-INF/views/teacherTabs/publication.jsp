<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var methodPublication = "GET";
    var saveActionUrlPublication;
    var waitPublication;
    var teacherIdPublication = null;
    var isCategoriesChanged_JspPublication = false;

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspPublication = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "subjectTitle"},
            {name: "publicationSubjectType.titleFa"},
            {name: "publicationSubjectTypeId", filterOperator: "equals"},
            {name: "categories"},
            {name: "subCategories"},
            {name: "categoriesIds", filterOperator: "inSet"},
            {name: "subCategoriesIds", filterOperator: "inSet"},
            {name: "publicationDate"},
            {name: "publicationLocation"},
            {name: "publisher"}
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
                required: true,
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    } ]

            },
            {
                name: "publicationSubjectTypeId",
                type: "IntegerItem",
                title: "<spring:message code="publication.subject.type"/>",
                textAlign: "center",
                required: true,
                width: "*",
                editorType: "ComboBoxItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource:  RestDataSource_EPublicationSubjectType_JspTeacher ,
                autoFetchData: false,
                filterFields: ["titleFa"],
                sortField: ["id"],
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspPublication,
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
                    isCategoriesChanged_JspPublication = true;
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
                optionDataSource: RestDataSource_SubCategory_JspPublication,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                focus: function () {
                    if (isCategoriesChanged_JspPublication) {
                        isCategoriesChanged_JspPublication = false;
                        var ids = DynamicForm_JspPublication.getField("categories").getValue();
                        if (ids == null || ids.isEmpty()) {
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
            },
            {
                name: "publicationLocation",
                title:"<spring:message code='publication.location'/>",
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    } ]

            },
            {
                name: "publisher",
                title: "<spring:message code='publisher'/>",
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    } ]

            },
            {
                name: "publicationDate",
                ID: "publication_publicationDate_JspPublication",
                title: "<spring:message code='publication.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
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
                        if(value != null && value != undefined)
                            return checkBirthDate(value);
                        else
                            return true;
                    }
                }]
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
        close : function(){closeCalendarWindow(); Window_JspPublication.hide()},
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
        fields: [
            {
                name: "subjectTitle",
                title: "<spring:message code='subject.title'/>",
            },
            {
                name: "publicationSubjectTypeId",
                title:"<spring:message code='publication.subject.type'/>",
                type: "IntegerItem",
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_EPublicationSubjectType_JspTeacher,
                filterOnKeypress: true
            },
            {
                name: "categoriesIds",
                title: "<spring:message code='category'/>",
                type: "SelectItem",
                optionDataSource: RestDataSource_Category_JspPublication,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                canSort: false,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_Category_JspPublication,
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
                optionDataSource: RestDataSource_SubCategory_JspPublication,
                valueField: "id",
                displayField: "titleFa",
                canSort: false,
                filterOnKeypress: true,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_SubCategory_JspPublication,
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
                name: "publicationLocation",
                title:"<spring:message code='publication.location'/>"
            },
            {
                name: "publisher",
                title: "<spring:message code='publisher'/>"
            },
            {
                name: "publicationDate",
                title: "<spring:message code='publication.date'/>"
            }
        ],
        rowDoubleClick: function () {
            ListGrid_Publication_Edit();
        },
        filterEditorSubmit: function () {
            ListGrid_JspPublication.invalidateCache();
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
    ToolStripButton_Add_JspPublication = isc.ToolStripButtonCreate.create({
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
                isc.ToolStripButtonExcel.create({
                    click: function () {
                        ExportToFile.downloadExcelRestUrl(null, ListGrid_JspPublication, publicationUrl + "/iscList/" + teacherIdPublication, 0,null, '', "استاد - اطلاعات پايه - تاليفات", ListGrid_JspPublication.getCriteria(), null)
                    }
                }),
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
            var clonedRecord = Object.assign({}, record);
            clonedRecord.categories = null;
            clonedRecord.subCategories = null;
            DynamicForm_JspPublication.editRecord(clonedRecord);
            if (record.categories == null || record.categories.isEmpty())
                DynamicForm_JspPublication.getField("subCategories").disable();
            else {
                DynamicForm_JspPublication.getField("subCategories").enable();
                var catIds = [];
                for (var i = 0; i < record.categories.length; i++)
                    catIds.add(record.categories[i].id);
                DynamicForm_JspPublication.getField("categories").setValue(catIds);
                isCategoriesChanged_JspPublication = true;
                DynamicForm_JspPublication.getField("subCategories").focus(null, null);
            }
            if (record.subCategories != null && !record.subCategories.isEmpty()) {
                var subCatIds = [];
                for (var i = 0; i < record.subCategories.length; i++)
                    subCatIds.add(record.subCategories[i].id);
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
        }
        else {
            if (resp.httpResponseCode === 405) {
                createDialog("info", "<spring:message code="publication.title.duplicate"/>",
                    "<spring:message code="message"/>");
            }

            else if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
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