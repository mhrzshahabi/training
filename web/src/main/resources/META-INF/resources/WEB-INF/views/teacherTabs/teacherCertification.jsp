<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var methodTeacherCertification = "GET";
    var saveActionUrlTeacherCertification;
    var waitTeacherCertification;
    var teacherIdTeacherCertification = null;
    var isCategoriesChanged = false;
    var startDateCheck_JSPTeachCertificate = true;
    var endDateCheck_JSPTeachCertificate = true;
    var dateCheck_Order_JSPTeachCertificate = true;

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspTeacherCertification = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "courseTitle", filterOperator: "iContains"},
            {name: "companyName", filterOperator: "iContains"},
            {name: "companyLocation", filterOperator: "iContains"},
            {name: "duration"},
            {name: "categories"},
            {name: "subCategories"},
            {name: "categoriesIds", filterOperator: "inSet"},
            {name: "subCategoriesIds", filterOperator: "inSet"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    RestDataSource_Category_JspTeacherCertification = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_SubCategory_JspTeacherCertification = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspTeacherCertification = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "courseTitle",
                title: "<spring:message code='course.title'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                required: true
            },
            {
                name: "companyName",
                title: "<spring:message code='company.name'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "companyLocation",
                title: "<spring:message code='location.name'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "categories",
                title: "<spring:message code='category'/>",
                type: "selectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspTeacherCertification,
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
                    var subCategoryField = DynamicForm_JspTeacherCertification.getField("subCategories");
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
                optionDataSource: RestDataSource_SubCategory_JspTeacherCertification,
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
                        var ids = DynamicForm_JspTeacherCertification.getField("categories").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspTeacherCertification.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspTeacherCertification.implicitCriteria = {
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
                name: "startDate",
                ID: "teachingHistories_startDate_JspTeacherCertification",
                title: "<spring:message code='start.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('teachingHistories_startDate_JspTeacherCertification', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    var dateCheck;
                    var endDate = form.getValue("endDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDateCheck_JSPTeachCertificate = false;
                        dateCheck_Order_JSPTeachCertificate = true;
                        form.clearFieldErrors("startDate", true);
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        dateCheck_Order_JSPTeachCertificate = false;
                        startDateCheck_JSPTeachCertificate = true;
                        form.clearFieldErrors("startDate", true);
                        form.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        startDateCheck_JSPTeachCertificate = true;
                        dateCheck_Order_JSPTeachCertificate = true;
                        form.clearFieldErrors("startDate", true);
                    }
                }
            },
            {
                name: "endDate",
                ID: "teachingHistories_endDate_JspTeacherCertification",
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
                            displayDatePicker('teachingHistories_endDate_JspTeacherCertification', this, 'ymd', '/');
                        }
                    }
                }],
                editorExit: function (form, item, value) {
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate");
                    if (dateCheck === false) {
                        endDateCheck_JSPTeachCertificate = false;
                        dateCheck_Order_JSPTeachCertificate = true;
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (value < startDate) {
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDateCheck_JSPTeachCertificate = true;
                        dateCheck_Order_JSPTeachCertificate = false;
                    } else {
                        form.clearFieldErrors("endDate", true);
                        endDateCheck_JSPTeachCertificate = true;
                        dateCheck_Order_JSPTeachCertificate = true;
                    }
                }
            }
        ]
    });

    IButton_Save_JspTeacherCertification = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_JspTeacherCertification.validate();
            if (!DynamicForm_JspTeacherCertification.valuesHaveChanged() ||
                !DynamicForm_JspTeacherCertification.validate() ||
                dateCheck_Order_JSPTeachCertificate == false ||
                dateCheck_Order_JSPTeachCertificate == false ||
                endDateCheck_JSPTeachCertificate == false ||
                startDateCheck_JSPTeachCertificate == false) {

                if (dateCheck_Order_JSPTeachCertificate == false){
                    DynamicForm_JspTeacherCertification.clearFieldErrors("endDate", true);
                    DynamicForm_JspTeacherCertification.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (dateCheck_Order_JSPTeachCertificate == false){
                    DynamicForm_JspTeacherCertification.clearFieldErrors("startDate", true);
                    DynamicForm_JspTeacherCertification.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (endDateCheck_JSPTeachCertificate == false){
                    DynamicForm_JspTeacherCertification.clearFieldErrors("endDate", true);
                    DynamicForm_JspTeacherCertification.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                }

                if (startDateCheck_JSPTeachCertificate == false){
                    DynamicForm_JspTeacherCertification.clearFieldErrors("startDate", true);
                    DynamicForm_JspTeacherCertification.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                }

                if (DynamicForm_JspTeacherCertification.getValue("startDate") != undefined && DynamicForm_JspTeacherCertification.getValue("endDate") == undefined){
                    DynamicForm_JspTeacherCertification.clearFieldErrors("endDate", true);
                    DynamicForm_JspTeacherCertification.addFieldErrors("endDate", "<spring:message code='msg.field.is.required'/>", true);
                }
                return;
            }

            if (DynamicForm_JspTeacherCertification.getValue("startDate") != undefined && DynamicForm_JspTeacherCertification.getValue("endDate") == undefined) {
                DynamicForm_JspTeacherCertification.clearFieldErrors("endDate", true);
                DynamicForm_JspTeacherCertification.addFieldErrors("endDate", "<spring:message code='msg.field.is.required'/>", true);
                return;
            }
            waitTeacherCertification = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlTeacherCertification,
                methodTeacherCertification,
                JSON.stringify(DynamicForm_JspTeacherCertification.getValues()),
                "callback: TeacherCertification_save_result(rpcResponse)"));
        }
    });

    IButton_Cancel_JspTeacherCertification = isc.TrCancelBtn.create({
        click: function () {
            DynamicForm_JspTeacherCertification.clearValues();
            Window_JspTeacherCertification.close();
        }
    });

    HLayout_SaveOrExit_JspTeacherCertification = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspTeacherCertification, IButton_Cancel_JspTeacherCertification]
    });

    Window_JspTeacherCertification = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='teacherCertification'/>",
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspTeacherCertification, HLayout_SaveOrExit_JspTeacherCertification]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspTeacherCertification = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_TeacherCertification_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_TeacherCertification_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_TeacherCertification_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_TeacherCertification_Remove();
            }
        }
        ]
    });

    ListGrid_JspTeacherCertification = isc.TrLG.create({
        dataSource: RestDataSource_JspTeacherCertification,
        contextMenu: Menu_JspTeacherCertification,
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
                name: "companyLocation",
                title: "<spring:message code='location.name'/>",
            },
            {
                name: "categoriesIds",
                title: "<spring:message code='category'/>",
                type: "selectItem",
                optionDataSource: RestDataSource_Category_JspTeacherCertification,
                valueField: "id",
                displayField: "titleFa",
                multiple: true,
                filterLocally: false,
                filterOnKeypress: true,
            },
            {
                name: "subCategoriesIds",
                title: "<spring:message code='subcategory'/>",
                type: "selectItem",
                optionDataSource: RestDataSource_SubCategory_JspTeacherCertification,
                valueField: "id",
                displayField: "titleFa",
                multiple: true,
                filterLocally: false,
                filterOnKeypress: true,
            },
            {
                name: "duration",
                title: "<spring:message code='duration'/>",
                filterOperator: "equals"
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                canSort: false
            },
            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                canSort: false
            }
        ],
        filterEditorSubmit: function () {
            ListGrid_JspTeacherCertification.invalidateCache();
        },
        doubleClick: function () {
            ListGrid_TeacherCertification_Edit();
        },
        align: "center",
        filterOperator: "iContains",
        filterOnKeypress: false,
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

    ToolStripButton_Refresh_JspTeacherCertification = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_TeacherCertification_refresh();
        }
    });

    ToolStripButton_Edit_JspTeacherCertification = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_TeacherCertification_Edit();
        }
    });
    ToolStripButton_Add_JspTeacherCertification = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_TeacherCertification_Add();
        }
    });
    ToolStripButton_Remove_JspTeacherCertification = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_TeacherCertification_Remove();
        }
    });

    ToolStrip_Actions_JspTeacherCertification = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspTeacherCertification,
                ToolStripButton_Edit_JspTeacherCertification,
                ToolStripButton_Remove_JspTeacherCertification,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspTeacherCertification
                    ]
                })
            ]
    });

    VLayout_Body_JspTeacherCertification = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspTeacherCertification,
            ListGrid_JspTeacherCertification
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_TeacherCertification_refresh() {
        ListGrid_JspTeacherCertification.invalidateCache();
        ListGrid_JspTeacherCertification.filterByEditor();
    }

    function ListGrid_TeacherCertification_Add() {
        methodTeacherCertification = "POST";
        saveActionUrlTeacherCertification = teacherCertificationUrl + "/" + teacherIdTeacherCertification;
        DynamicForm_JspTeacherCertification.clearValues();
        Window_JspTeacherCertification.show();
    }

    function ListGrid_TeacherCertification_Edit() {
        var record = ListGrid_JspTeacherCertification.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodTeacherCertification = "PUT";
            saveActionUrlTeacherCertification = teacherCertificationUrl + "/" + record.id;
            DynamicForm_JspTeacherCertification.clearValues();
            DynamicForm_JspTeacherCertification.editRecord(record);
            var categoryIds = DynamicForm_JspTeacherCertification.getField("categories").getValue();
            var subCategoryIds = DynamicForm_JspTeacherCertification.getField("subCategories").getValue();
            if (categoryIds == null || categoryIds.length === 0)
                DynamicForm_JspTeacherCertification.getField("subCategories").disable();
            else {
                DynamicForm_JspTeacherCertification.getField("subCategories").enable();
                var catIds = [];
                for (var i = 0; i < categoryIds.length; i++)
                    catIds.add(categoryIds[i].id);
                DynamicForm_JspTeacherCertification.getField("categories").setValue(catIds);
                isCategoriesChanged = true;
                DynamicForm_JspTeacherCertification.getField("subCategories").focus(null, null);
            }
            if (subCategoryIds != null && subCategoryIds.length > 0) {
                var subCatIds = [];
                for (var i = 0; i < subCategoryIds.length; i++)
                    subCatIds.add(subCategoryIds[i].id);
                DynamicForm_JspTeacherCertification.getField("subCategories").setValue(subCatIds);
            }
            Window_JspTeacherCertification.show();
        }
    }

    function ListGrid_TeacherCertification_Remove() {
        var record = ListGrid_JspTeacherCertification.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitTeacherCertification = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(teacherCertificationUrl +
                            "/" +
                            teacherIdTeacherCertification +
                            "," +
                            ListGrid_JspTeacherCertification.getSelectedRecord().id,
                            "DELETE",
                            null,
                            "callback: TeacherCertification_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function TeacherCertification_save_result(resp) {
        waitTeacherCertification.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_TeacherCertification_refresh();
            Window_JspTeacherCertification.close();
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

    function TeacherCertification_remove_result(resp) {
        waitTeacherCertification.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_TeacherCertification_refresh();
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

    function loadPage_TeacherCertification(id) {
        if (teacherIdTeacherCertification !== id) {
            teacherIdTeacherCertification = id;
            RestDataSource_JspTeacherCertification.fetchDataURL = teacherCertificationUrl + "/iscList/" + teacherIdTeacherCertification;
            ListGrid_JspTeacherCertification.fetchData();
            ListGrid_TeacherCertification_refresh();
        }
    }

    function clear_TeacherCertification() {
        ListGrid_JspTeacherCertification.clear();
    }

    //</script>