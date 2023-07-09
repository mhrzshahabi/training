<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let method = "POST";
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    let RestDataSource_Class = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
            {name: "c"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "studentCount", canFilter: false, canSort: false},
            {name: "code"},
            {name: "term.titleFa"},
            {name: "course.titleFa"},
            {name: "course.id"},
            {name: "teacherId"},
            {
                name: "teacher",
            },
            {
                name: "teacher.personality.lastNameFa",
            },
            {name: "reason"},
            {name: "classStatus"},
            {name: "topology"},
            {name: "trainingPlaceIds"},
            {name: "instituteId"},
            {name: "workflowEndingStatusCode"},
            {name: "workflowEndingStatus"},
            {name: "preCourseTest", type: "boolean"},
            {name: "course.code"},
            {name: "course.theoryDuration"},
            {name: "course.eTheoType"},
            {name: "scoringMethod"},
            {name: "evaluation"}
        ],
        fetchDataURL: classUrl + "spec-list"
    });

    let RestDataSource_Class_Fees = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "date", title: "تاریخ", filterOperator: "iContains"},
            {
                name: "complexTitle",
                title: "<spring:message code="complex"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                detail: true
            },
            {name: "classTitle", title: "کلاس", filterOperator: "iContains"},
            {name: "classFeeStatus", title: "وضعیت", filterOperator: "equals"},
        ],
        fetchDataURL: classFeesUrl + "/spec-list",

    });

    let RestDataSource_Fee_Items = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "title", title: "عنوان", filterOperator: "iContains"},
            {name: "cost", title: "هزینه", filterOperator: "iContains"},
            // {name: "classId", title: "کلاس", filterOperator: "iContains"},
            {name: "classTitle", title: "کلاس", filterOperator: "iContains"},
        ],
        fetchDataURL: feeItemsUrl + "/spec-list"
    });

    let RestDataSource_Class_Department_Filter = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "code"},
            {name: "title"},
            {name: "enabled"}
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    let ToolStripButton_Add_ClassFee = isc.ToolStripButtonCreate.create({
        click: function () {
            RegisterFee();
        }
    });

    let ToolStripButton_Edit_ClassFee = isc.ToolStripButtonEdit.create({
        click: function () {
            EditClassFee();
        }
    });

    let ToolStripButton_Remove_ClassFee = isc.ToolStripButtonRemove.create({
        click: function () {
            RemoveFee();
        }
    });

    let ToolStripButton_Refresh_ClassFees = isc.ToolStripButtonRefresh.create({
        click: function () {
            RefreshData();
        }
    });

    let ToolStripButton_Refresh_Fee_Items = isc.ToolStripButtonRefresh.create({
        click: function () {
            let selectedRecord = ListGrid_Register_Class_Fee.getSelectedRecord();

            if (selectedRecord == null) {
                return;
            }

            refreshListGridFeeItems(selectedRecord.classId)
        }
    });

    let ToolStrip_Actions_ClassFee = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_ClassFee,
                ToolStripButton_Edit_ClassFee,
                ToolStripButton_Remove_ClassFee,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_ClassFees
                    ]
                })
            ]
    });

    let ListGrid_Register_Class_Fee = isc.TrLG.create({
        height: "55%",
        autoFetchData: true,
        showFilterEditor: true,
        filterOnKeypress: false,
        dataSource: RestDataSource_Class_Fees,
        gridComponents: ["filterEditor", "header", "body"],
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {name: "id", hidden: true},
            {name: "date", title: "<spring:message code='date'/>"},
            {name: "complexTitle", title: "<spring:message code='complex'/>"},
            {name: "classTitle", title: "<spring:message code='class'/>"},
            {
                name: "classFeeStatus",
                title: "<spring:message code='status'/>",
                valueMap: {
                    "1": "ثبت اولیه",
                    "2": "پرداخت شده"
                }
            },
        ],
        recordClick: function () {
            selectionUpdatedClassFee();
        },
        filterEditorSubmit: function () {
            ListGrid_Register_Class_Fee.invalidateCache();
        },

    });

    let Add_Fee_item = isc.ToolStrip.create({
        width: "100%",
        layoutMargin: 5,
        membersMargin: 10,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    showAddFeeItemToClassFeeWindow()
                }.bind(this)
            }),
            isc.ToolStripButtonEdit.create({
                click: function () {
                    editFeeItem();
                }
            }),
            isc.ToolStripButtonRemove.create({
                title: "حذف",
                click: function () {
                    deleteFeeItemFromClassFee()
                }.bind(this)
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Fee_Items
                ]
            })
        ]
    });

    let ListGrid_Fee_Item = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canEdit: false,
        autoFetchData: false,
        validateByCell: true,
        dataSource: RestDataSource_Fee_Items,
        selectCellTextOnClick: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {name: "id", hidden: true},
            {
                name: "title",
                title: "<spring:message code='title'/>"
            },
            {
                name: "cost",
                title: "هزینه (ريال)",
                type: "float",
                format: "0,"
            },
            {name: "classTitle", title: "<spring:message code='class'/>"},
        ],
        gridComponents: [
            Add_Fee_item,
            "header",
            "body"
        ],
        createRecordComponent: function (record, colNum) {
            let fieldName = this.getFieldName(colNum);
            if (fieldName === "removeIcon") {
                let removeImg = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/remove.png",
                    prompt: "حذف",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        let canRemove = ListGrid_Register_Class_Fee.getSelectedRecord().paymentDocStatus === 'ثبت اولیه';
                        if (canRemove) {
                            payment_classes_Remove(record);
                        } else {
                            createDialog("info", "هزینه کلاس شده حذف نخواهد شد");
                        }
                    }
                });
                return removeImg;
            } else {
                return null;
            }
        }
    });

    let TabSet_ClassFee_Reg = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {
                name: "classFeeRegistrationTab",
                title: "آیتم های هزینه",
                pane: ListGrid_Fee_Item
            }
        ]
    });

    let HLayout_Tab_ClassFeeReg = isc.HLayout.create({
        width: "100%",
        height: "40%",
        members: [
            TabSet_ClassFee_Reg
        ]
    });

    let DynamicForm_ClassFee = isc.DynamicForm.create({
        width: "100%",
        height: "100%%",
        align: "center",
        canSubmit: true,
        wrapItemTitles: false,
        showInlineErrors: true,
        showErrorText: false,
        numCols: 2,
        titleAlign: "center",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        fields: [
            {name: "id", hidden: true},
            {
                name: "date",
                title: "<spring:message code='date'/>",
                required: true,
                width: "100%",
                ID: "date",
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                textAlign: "center",
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('date', this, 'ymd', '/', "right");
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "complexId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="complex"/>:",
                optionDataSource: RestDataSource_Class_Department_Filter,
                width: "100%",
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
            },
            {
                name: "classId",
                title: "<spring:message code="class"/>",
                required: false,
                textAlign: "center",
                autoFetchData: false,
                width: "100%",
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Class,
                sortField: ["id"],
                filterFields: ["id"],
                pickListFields: [
                    {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "course.titleFa",
                        title: "<spring:message code='course.title'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        sortNormalizer: function (record) {
                            return record.course.titleFa;
                        }
                    },
                    {
                        name: "term.titleFa",
                        title: "term",
                        align: "center",
                        filterOperator: "iContains",
                        hidden: true
                    },
                    {
                        name: "course.eTheoType",
                        title: "eTheoType",
                        align: "center",
                        filterOperator: "iContains",
                        hidden: true
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        autoFitWidth: true
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        autoFitWidth: true
                    },
                    {
                        name: "teacher",
                        title: "<spring:message code='teacher'/>",
                        displayField: "teacher.personality.lastNameFa",
                        displayValueFromRecord: false,
                        type: "TextItem",
                        sortNormalizer(record) {
                            return record.teacher.personality.lastNameFa;
                        },

                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        // sortNormalizer(record) {
                        //     return record.teacher.personality.lastNameFa;
                        // }
                    },
                    {
                        name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                        valueMap: {
                            "1": "برنامه ریزی",
                            "2": "در حال اجرا",
                            "3": "پایان یافته",
                        },
                        filterEditorProperties: {
                            pickListProperties: {
                                showFilterEditor: false
                            },
                        },
                        filterOnKeypress: true,
                        autoFitWidth: true,
                    },
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
                // pickListWidth: 800,
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();

                        }
                    }
                ],
                endRow: true,
                startRow: false,

                changed: function (form, item, value) {
                    //DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                },
                change: function (form, item, value) {
                    // if (item.getSelectedRecord().course.etheoType.id == 1) { // Theory
                    //     form.getItem("practicalScore").setValue(0);
                    //     form.getItem("practicalScore").setDisabled(true);
                    // } else {
                    //     form.getItem("practicalScore").setDisabled(false);
                    // }

                }
            },
        ]
    });

    let IButton_Save_ClassFee = isc.IButtonSave.create({
        title: "<spring:message code='save'/>",
        align: "center",
        click: function () {
            if (!DynamicForm_ClassFee.validate())
                return;

            let data = DynamicForm_ClassFee.getValues();

            if (method === "POST") {
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(classFeesUrl, "POST", JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Add_Class_Fee.close();
                        RefreshData()
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                        Window_Add_Class_Fee.close();
                    }
                }));

            } else if (method === "PUT") {
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(classFeesUrl, "PUT", JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Add_Class_Fee.close();
                        RefreshData();
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                        Window_Add_Class_Fee.close();
                    }
                }));
            }

        }
    });

    let IButton_Exit_ClassFee = isc.IButtonCancel.create({
        title: "<spring:message code='cancel'/>",
        align: "center",
        click: function () {
            Window_Add_Class_Fee.close();
        }
    });

    let HLayOut_SaveOrExit_ClassFee_Reg = isc.HLayout.create({
        layoutMargin: 5,
        width: "100%",
        height: "10%",
        align: "center",
        membersMargin: 10,
        alignLayout: "center",
        members: [
            IButton_Save_ClassFee,
            IButton_Exit_ClassFee
        ]
    });

    let DynamicForm_Add_Fee_item = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        numCols: 2,
        align: "center",
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "title",
                title: "<spring:message code="title"/>:",
                editorType: "textArea",
                required: true
            },
            {
                name: "cost",
                title: "مبلغ(ريال)",
                format: "0,",
                validateOnChange: true,
                type: "float",
                keyPressFilter: "[0-9]",
                required: true
            },
            {
                name: "classId",
                title: "<spring:message code="class"/>",
                required: false,
                textAlign: "center",
                autoFetchData: false,
                width: "100%",
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Class,
                sortField: ["id"],
                filterFields: ["id"],
                pickListFields: [
                    {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "course.titleFa",
                        title: "<spring:message code='course.title'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        sortNormalizer: function (record) {
                            return record.course.titleFa;
                        }
                    },
                    {
                        name: "term.titleFa",
                        title: "term",
                        align: "center",
                        filterOperator: "iContains",
                        hidden: true
                    },
                    {
                        name: "course.eTheoType",
                        title: "eTheoType",
                        align: "center",
                        filterOperator: "iContains",
                        hidden: true
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        autoFitWidth: true
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        autoFitWidth: true
                    },
                    {
                        name: "teacher",
                        title: "<spring:message code='teacher'/>",
                        displayField: "teacher.personality.lastNameFa",
                        displayValueFromRecord: false,
                        type: "TextItem",
                        sortNormalizer(record) {
                            return record.teacher.personality.lastNameFa;
                        },

                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        // sortNormalizer(record) {
                        //     return record.teacher.personality.lastNameFa;
                        // }
                    },
                    {
                        name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                        valueMap: {
                            "1": "برنامه ریزی",
                            "2": "در حال اجرا",
                            "3": "پایان یافته",
                        },
                        filterEditorProperties: {
                            pickListProperties: {
                                showFilterEditor: false
                            },
                        },
                        filterOnKeypress: true,
                        autoFitWidth: true,
                    },
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
                // pickListWidth: 800,
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();

                        }
                    }
                ],
                endRow: true,
                startRow: false,
            },

        ]
    });

    let HLayout_IButtons_Add_Fee_Item = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            isc.IButtonSave.create({
                top: 260,
                layoutMargin: 5,
                membersMargin: 5,
                click: function () {
                    saveFeeItemAndClassFee()
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    DynamicForm_Add_Fee_item.clearValues()
                    Window_Add_Fee_Item.close();
                }
            })
        ]
    });

    let Window_Add_Class_Fee = isc.Window.create({
        title: "ثبت هزینه کلاس",
        width: "60%",
        height: "60%",
        autoSize: false,
        autoCenter: true,
        isModal: true,
        align: "center",
        items: [
            DynamicForm_ClassFee,
            HLayOut_SaveOrExit_ClassFee_Reg
        ]
    });

    let Window_Add_Fee_Item = isc.Window.create({
        title: "افزودن آیتم هزینه به کلاس",
        width: "40%",
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Add_Fee_item,
            HLayout_IButtons_Add_Fee_Item
        ]
    });

    let VLayout_Body_ClassFee_Reg = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_ClassFee,
            ListGrid_Register_Class_Fee,
            HLayout_Tab_ClassFeeReg
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function RegisterFee() {
        method = "POST";
        DynamicForm_ClassFee.clearValues();
        DynamicForm_ClassFee.clearErrors();
        Window_Add_Class_Fee.setTitle("ثبت هزینه کلاس");
        Window_Add_Class_Fee.show();
    }

    function EditClassFee() {
        let record = ListGrid_Register_Class_Fee.getSelectedRecord();

        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "موردی برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [
                    isc.IButtonSave.create({title: "تائید"})
                ],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
            return;
        }

        if (record.classFeeStatus !== 1) {
            isc.Dialog.create({
                message: "رکورد باید در وضعیت ثبت اولیه باشد.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [
                    isc.IButtonSave.create({title: "تائید"})
                ],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
            return;
        }

        if (record.classId != null) {
            for (let i = 0; i < ListGrid_Fee_Item.getData().size(); i++) {
                if (ListGrid_Fee_Item.getData().get(i).classId === record.classId) {
                    createDialog("info", "امکان ویرایش وجود ندارد");
                    return;
                }
            }
        }

        method = "PUT";
        DynamicForm_ClassFee.clearValues();
        DynamicForm_ClassFee.clearErrors();
        DynamicForm_ClassFee.editRecord(record);
        Window_Add_Class_Fee.setTitle("ویرایش هزینه کلاس");
        Window_Add_Class_Fee.show();
    }

    function RemoveFee() {
        let record = ListGrid_Register_Class_Fee.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "موردی برای حذف انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else if (record.classFeeStatus !== 1) {
            isc.Dialog.create({
                message: "رکورد باید در وضعیت ثبت اولیه باشد.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [
                    isc.IButtonSave.create({title: "تائید"})
                ],
                buttonClick: function (button, index) {
                    this.close();
                }
            });

        } else {
            let Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين هزینه حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                    title: "خير"
                })],
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(classFeesUrl + "/" + record.id, "DELETE", null, function (resp) {
                            wait.close();
                            if (resp.httpResponseCode === 200) {
                                createDialog("info", "<spring:message code='global.grid.record.remove.success'/>");
                                RefreshData();
                            } else {
                                createDialog("info", "<spring:message code='global.grid.record.remove.failed'/>")
                            }
                        }));
                    }
                }
            });
        }
    }

    function RefreshData() {
        ListGrid_Register_Class_Fee.clearFilterValues();
        ListGrid_Register_Class_Fee.invalidateCache();
        ListGrid_Fee_Item.setData([]);
        ListGrid_Fee_Item.invalidateCache();
    }

    function selectionUpdatedClassFee() {
        ListGrid_Fee_Item.setData([]);

        let classFee = ListGrid_Register_Class_Fee.getSelectedRecord();

        if (classFee.classId === undefined || classFee.classId == null) {
            return;
        }

        refreshListGridFeeItems(classFee.classId)

    }

    function showAddFeeItemToClassFeeWindow() {
        let record = ListGrid_Register_Class_Fee.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return
        }
        if (record.classId != null) {
            DynamicForm_Add_Fee_item.getField("classId").hide()
            DynamicForm_Add_Fee_item.getField("classId").setRequired(false)
        } else {
            DynamicForm_Add_Fee_item.getItem("classId").setValue(record.classId)
            DynamicForm_Add_Fee_item.getField("classId").show()
            DynamicForm_Add_Fee_item.getField("classId").setRequired(true)
        }
        Window_Add_Fee_Item.show()
    }

    function saveFeeItemAndClassFee() {
        if (!DynamicForm_Add_Fee_item.validate()) {
            return
        }

        let data = DynamicForm_Add_Fee_item.getValues();


        let selectedClassFee = ListGrid_Register_Class_Fee.getSelectedRecord();

        if (selectedClassFee.classId != null) {
            data.classId = selectedClassFee.classId

        }

        isc.RPCManager.sendRequest(TrDSRequest(feeItemsUrl, "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                createDialog("info", "آیتم با موفقیت ایجاد شد");
                refreshListGridFeeItems(data.classId)
            } else {
                createDialog("info", "عملیات ناموفق.")
                refreshListGridFeeItems(data.classId)
            }
            Window_Add_Fee_Item.close();
        }));
    }

    function editFeeItem() {
        let selectedFeeItem = ListGrid_Fee_Item.getSelectedRecord();
        if (selectedFeeItem == null) {
            createDialog("info", "آیتمی انتخاب نشده است.");
            return;
        }

        // if (selectedRecord.classFeeStatus !== 1) {
        //     isc.Dialog.create({
        //         message: "رکورد باید در وضعیت ثبت اولیه باشد.",
        //         icon: "[SKIN]ask.png",
        //         title: "توجه",
        //         buttons: [
        //             isc.IButtonSave.create({title: "تائید"})
        //         ],
        //         buttonClick: function (button, index) {
        //             this.close();
        //         }
        //     });
        //     return;
        // }

        if (selectedFeeItem.classId != null) {
            for (let i = 0; i < ListGrid_Register_Class_Fee.getData().size(); i++) {
                if (ListGrid_Register_Class_Fee.getData().get(i).classId === selectedFeeItem.classId) {
                    createDialog("info", "امکان ویرایش وجود ندارد");
                    return;
                }
            }
        }

        DynamicForm_Add_Fee_item.editRecord(selectedFeeItem);
        Window_Add_Fee_Item.title = "ویرایش آیتم هزینه به کلاس";
        Window_Add_Fee_Item.show();
    }

    function deleteFeeItemFromClassFee() {
        isc.Dialog.create({
            message: "آيا مي خواهيد اين آیتم حذف گردد؟",
            icon: "[SKIN]ask.png",
            title: "توجه",
            buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                title: "خير"
            })],
            buttonClick: function (button, index) {
                this.close();
                if (index === 0) {
                    wait.show();
                    let id = ListGrid_Fee_Item.getSelectedRecord().id;
                    isc.RPCManager.sendRequest(TrDSRequest(feeItemsUrl + "/" + id, "DELETE", null, function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            createDialog("info", "آیتم مورد نظر با موفقیت حذف گردید");
                            ListGrid_Fee_Item.invalidateCache();
                        } else {
                            createDialog("info", "عملیات حذف ناموفق بود")
                        }
                    }));
                    wait.close()
                }
            }
        });

    }

    function refreshListGridFeeItems(classFeeId) {
        if (classFeeId == null) {
            wait.close();
            return;
        }

        wait.show();

        isc.RPCManager.sendRequest(TrDSRequest(feeItemsUrl + "/" + classFeeId, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let classCostList = JSON.parse(resp.httpResponseText);
                ListGrid_Fee_Item.setData(classCostList);
                ListGrid_Fee_Item.invalidateCache()
            } else {
                createDialog("info", "خطایی رخ داده است");
            }
        }));
    }

    // </script>