<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var instituteMethod = "POST";
    var instituteWait;

    var mailCheck = true;

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//



    var RestDataSource_Institute_Institute = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "teacherNumPHD"},
            {name: "teacherNumLicentiate"},
            {name: "empNumLicentiate"},
            {name: "teacherNumMaster"},
            {name: "empNumMaster"},
            {name: "teacherNumAssociate"},
            {name: "empNumAssociate"},
            {name: "teacherNumDiploma"},
            {name: "empNumDiploma"},
            {name: "contactInfo.email"},
            {name: "accountInfo.bank"},
            {name: "accountInfo.bankBranch"},
            {name: "accountInfo.bankBranchCode"},
            {name: "accountInfo.accountNumber"},
            {name: "manager.firstNameFa"},
            {name: "manager.lastNameFa"},
            {name: "manager.nationalCode"},
            {name: "parentInstitute.titleFa"},
            {name: "einstituteType.titleFa"},
            {name: "elicenseType.titleFa"},
            {name: "address"},
            {name: "address"},
            {name: "email"},
            {name: "postalCode"},
            {name: "branch"},
            {name: "version"}
        ],
        fetchDataURL: instituteUrl + "spec-list"
    });
    var RestDataSource_Institute_TrainingPlace = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "institute.titleFa"},
            {name: "instituteId"},
            {name: "capacity"},
            {name: "ePlaceType.titleFa"},
            {name: "eArrangementType.titleFa"},
            {name: "description"}
        ],
        fetchDataURL: instituteUrl + "training-place/0"
    });
    var RestDataSource_Institute_TrainingPlace_Equipment = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: instituteUrl + "training-place-equipment/0"
    });
    var RestDataSource_Institute_Institite_Equipment = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: instituteUrl + "equipment/0"
    });
    var RestDataSource_Institute_Institite_UnAttachedEquipment = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: instituteUrl + "un-attached-equipment/0"
    });
    var RestDataSource_Institute_Institite_Teacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "teacherCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"},
            {name: "economicalCode"},
            {name: "economicalRecordNumber"}
        ],
        fetchDataURL: instituteUrl + "teacher/0"
    });
    var RestDataSource_Institute_Institite_UnAttachedTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "teacherCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"},
            {name: "economicalCode"},
            {name: "economicalRecordNumber"}
        ],
        fetchDataURL: instituteUrl + "un-attached-teacher/0"
    });

    var RestDataSource_Institute_EPlaceType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "ePlaceType/spec-list"
    });
    var RestDataSource_Institute_EArrangementType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eArrangementType/spec-list"
    });

    var RestDataSource_Institute_EInstituteType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eInstituteType/spec-list"
    });
    var RestDataSource_Institute_ELicenseType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eLicenseType/spec-list"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_Institute_Institute = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Institute_Institute_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_Institute_Institute_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "pieces/16/icon_edit.png", click: function () {
                ListGrid_Institute_Institute_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_Institute_Institute_Remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>", icon: "icon/pdf.png", click: function () {
                ListGrid_institute_print("pdf");
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "icon/excel.png", click: function () {
                ListGrid_institute_print("excel");
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "icon/html.jpg", click: function () {
                ListGrid_institute_print("html");
            }
        }]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Listgrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Institute_Institute = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institute,
        contextMenu: Menu_ListGrid_Institute_Institute,
        doubleClick: function () {
            ListGrid_Institute_Institute_Edit();
        },

        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "equals"},
            {name: "titleFa", title: "<spring:message code='title'/>", align: "center", filterOperator: "contains"},
            {
                name: "telephone",
                title: "<spring:message code='telephone'/>",
                align: "center",
                filterOperator: "contains"
            },
            {name: "branch", title: "<spring:message code='branch'/>", align: "center", filterOperator: "contains"},
            {name: "einstituteType.titleFa", title: "", hidden: true},
            {name: "elicenseType.titleFa", title: "", hidden: true},
            {name: "titleEn", title: "", hidden: true},
            {name: "address", title: "", hidden: true},
            {name: "email", title: "", hidden: true},
            {name: "postalCode", title: "", hidden: true},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    var ListGrid_Institute_Attached_Teacher = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_Teacher,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "teacherCode", title: "کد", align: "center"},
            {name: "personality.firstNameFa", title: "نام", align: "center"},
            {name: "personality.lastNameFa", title: "نام خانوادگی ", align: "center"},
            {name: "personality.nationalCode", title: "کد ملی", align: "center"},
            {name: "economicalCode", title: "کد اقتصادی", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
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

    var ListGrid_Institute_Attached_Equipment = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_Equipment,
        doubleClick: function () {
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "عنوان فارسی", align: "center"},
            {name: "titleFa", title: "عنوان فارسی", align: "center"},
            {name: "titleEn", title: "عنوان لاتین ", align: "center"},
            {name: "description", title: "رسته", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
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

    var ListGrid_Institute_TrainingPlace = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_TrainingPlace,
        doubleClick: function () {

        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان فارسی", align: "center"},
            {name: "titleEn", title: "عنوان لاتین ", align: "center"},
            {name: "capacity", title: "ظرفیت", align: "center"},
            {name: "ePlaceType.titleFa", title: "نوع محل", align: "center"},
            {name: "eArrangementType.titleFa", title: "شکل/ترتیب", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
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
    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//

    var DynamicForm_Institute_Institute = isc.DynamicForm.create({
        width: "800",
        titleWidth: "120",
        height: "190",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        margin: 50,
        padding: 5,
        fields: [
            {name: "id", hidden: true},

            {
                name: "code", title: "<spring:message code='code'/>",
                type: 'text',
                required: true,
                keyPressFilter: "[0-9]",
                length: "15",
            },
            {
                name: "titleFa",
                title: "<spring:message code='title'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true,
                length: "30"
            },
            {
                name: "titleEn",
                title: "<spring:message code='titleEn'/>",
                required: true,
                keyPressFilter: "[a-z|A-Z |]",
                hint: "English/انگليسي",
                showHintInField: true,
                length: "30"
            },
            {
                name: "telephone",
                title: "<spring:message code='telephone'/>",
                keyPressFilter: "[0-9]",
                length: "15",
            },
            {
                name: "address",
                title: "<spring:message code='address'/>"
            },
            {
                name: "email",
                title: "<spring:message code='email'/>",
                hint: "test@nicico.com",
                showHintInField: true,
                length: "30"
                , blur: function () {
                    var emailCheck = false;
                    emailCheck = checkEmail(DynamicForm_Institute_Institute.getValue("email"));
                    mailCheck = emailCheck;
                    if (emailCheck == false)
                        DynamicForm_Institute_Institute.addFieldErrors("email", "<spring:message code='msg.email.validation'/>", true);

                    if (emailCheck == true)
                        DynamicForm_Institute_Institute.clearFieldErrors("email", true);
                }
            },
            {
                name: "postalCode",
                title: "<spring:message code='postal.code'/>",
                keyPressFilter: "[0-9]",
                length: "15"
            },
            {
                name: "branch",
                title: "<spring:message code='branch'/>",
                length: "15"
            },
            {
                name: "einstituteTypeId",
                type: "IntegerItem",
                title: "<spring:message code='institute.type'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_EinstituteType_JspInstitute,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}],
            },
            {
                name: "elicenseTypeId",
                type: "IntegerItem",
                title: "<spring:message code='license.type'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_ElicenseType_JspInstitute,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}],
            },
        ]

    });

    var IButton_Institute_Institute_Exit = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "pieces/16/icon_delete.png",
        click: function () {
            Window_Institute_Institute.close();
        }
    });

    var IButton_Institute_Institute_Save = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {

            if (mailCheck == false)
                return;

            DynamicForm_Institute_Institute.validate();
            if (DynamicForm_Institute_Institute.hasErrors()) {
                return;
            }
            var data = DynamicForm_Institute_Institute.getValues();

            var instituteSaveUrl = instituteUrl;
            if (instituteMethod.localeCompare("PUT") == 0) {
                var instituteRecord = ListGrid_Institute_JspInstitute.getSelectedRecord();
                instituteSaveUrl += instituteRecord.id;
            }
            isc.RPCManager.sendRequest(MyDsRequest(instituteSaveUrl, instituteMethod, JSON.stringify(data), "callback: institute_action_result(rpcResponse)"));
        }
    });

    var HLayOut_Institute_InstituteSaveOrExit = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "800",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Institute_Institute_Save, IButton_Institute_Institute_Exit]
    });

    var Window_Institute_Institute = isc.Window.create({
        title: "<spring:message code='training.institute'/>",
        width: 800,
        height: 200,
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
            width: "100%",
            height: "100%",
            members: [DynamicForm_Institute_Institute, HLayOut_Institute_InstituteSaveOrExit]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Actions In Institute List Grid*/
    //--------------------------------------------------------------------------------------------------------------------//
    function ListGrid_Institute_Institute_Remove() {
        var record = ListGrid_Institute_Institute.getSelectedRecord();
        //console.log(record);
        if (record == null) {
            isc.Dialog.create({
                message: "مهارتی برای حذف انتخاب نشده است!",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين مهارت حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "هشدار",
                buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
                    title: "خير"
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
                            actionURL: instituteUrl + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.data == "true") {
                                    ListGrid_Institute_Institute.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "مهارت با موفقيت حذف گرديد",
                                        icon: "[SKIN]say.png",
                                        title: "انجام شد"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "ركورد مورد نظر قابل حذف نيست",
                                        icon: "[SKIN]stop.png",
                                        title: "خطا"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 3000);
                                }
                            }
                        });
                    }
                }
            });
        }


    };

    function ListGrid_Institute_Institute_Edit() {
        var record = ListGrid_Institute_Institute.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "مهارتی برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            //console.log('record:' + JSON.stringify(record));
            var id = record.categoryId;
            DynamicForm_Institute_Institute.clearValues();
            instituteMethod = "PUT";
            DynamicForm_Institute_Institute.editRecord(record);
            Window_Institute_Institute.setTitle(" ویرایش مرکز آموزشی " + getFormulaMessage(ListGrid_Institute_Institute.getSelectedRecord().code, 3, "red", "I"));
            Window_Institute_Institute.show();

        }
    };

    function ListGrid_Institute_Institute_Add() {
        instituteMethod = "POST";
        DynamicForm_Institute_Institute.clearValues();
        Window_Institute_Institute.setTitle("ایجاد مرکز آموزشی جدید");
        Window_Institute_Institute.show();
    };

    function ListGrid_Institute_Institute_refresh() {
        var record = ListGrid_Institute_Institute.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_Institute_Institute.selectRecord(record);
        }
        ListGrid_Institute_Institute.invalidateCache();
    };

    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Institute_Institute_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "<spring:message code='refresh'/>",
        click: function () {
            ListGrid_Institute_Institute_refresh();
        }
    });
    var ToolStripButton_Institute_Institute_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_Institute_Institute_Edit();
        }
    });
    var ToolStripButton_Institute_Institute_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code='create'/>",
        click: function () {
            ListGrid_Institute_Institute_Add();
        }
    });
    var ToolStripButton_Institute_Institute_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_Institute_Institute_Remove();
        }
    });
    var ToolStripButton_Institute_Institute_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            ListGrid_institute_print("pdf");
        }
    });

    var ToolStrip_Institute_Institute_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Institute_Institute_Refresh,
            ToolStripButton_Institute_Institute_Add,
            ToolStripButton_Institute_Institute_Edit,
            ToolStripButton_Institute_Institute_Remove,
            ToolStripButton_Institute_Institute_Print]
    });

    var HLayout_Institute_Institute_Action = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Institute_Institute_Actions]
    });
    var HLayout_Institute_Institute_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Institute_Institute]
    });

    var HLayout_Institute__Institute_TrainingPlace = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Institute_TrainingPlace]
    });
    var HLayout_Institute_Institute_Teacher = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Institute_Attached_Teacher]
    });
    var HLayout_Institute_Institute_Equipment = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Institute_Attached_Equipment]
    });

    var Tab_Institute_Detail = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {
                id: "TabPane_Institute_TrainingPlace",
                title: "لیست محل های آموزشی",
                pane: HLayout_Institute__Institute_TrainingPlace

            },
            {
                id: "TabPane_Institute_Teacher",
                title: "لیست اساتید",
                pane: HLayout_Institute_Institute_Teacher

            },
            {
                id: "TabPane_Institute_Equipment",
                title: "لیست تجهیزات کمک آموزشی",
                pane: HLayout_Institute_Institute_Equipment
            }
        ]
    });

    var VLayout_Institute_Institute_Head_Body = isc.VLayout.create({
        width: "100%",
        height: "50%",
        members: [
            HLayout_Institute_Institute_Action
            , HLayout_Institute_Institute_Grid
        ]
    });
    var VLayout_Institute_Institute_Detail_Body = isc.VLayout.create({
        width: "100%",
        height: "50%",
        members: [
            Tab_Institute_Detail
        ]
    });

    var VLayout_Body_Institute = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Institute_Institute_Head_Body,
            VLayout_Institute_Institute_Detail_Body
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    <%--function ListGrid_institute_remove() {--%>
        <%--var record = ListGrid_Institute_JspInstitute.getSelectedRecord();--%>
        <%--if (record == null) {--%>
            <%--isc.Dialog.create({--%>
                <%--message: "<spring:message code='msg.record.not.selected'/>",--%>
                <%--icon: "[SKIN]ask.png",--%>
                <%--title: "<spring:message code='message'/>",--%>
                <%--buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],--%>
                <%--buttonClick: function (button, index) {--%>
                    <%--this.close();--%>
                <%--}--%>
            <%--});--%>
        <%--} else {--%>
            <%--var Dialog_Delete = isc.Dialog.create({--%>
                <%--message: "<spring:message code='msg.record.remove.ask'/>",--%>
                <%--icon: "[SKIN]ask.png",--%>
                <%--title: "<spring:message code='msg.remove.title'/>",--%>
                <%--buttons: [isc.Button.create({title: "<spring:message code='yes'/>"}), isc.Button.create({--%>
                    <%--title: "<spring:message code='no'/>"--%>
                <%--})],--%>
                <%--buttonClick: function (button, index) {--%>
                    <%--this.close();--%>

                    <%--if (index == 0) {--%>
                        <%--instituteWait = isc.Dialog.create({--%>
                            <%--message: "<spring:message code='msg.waiting'/>",--%>
                            <%--icon: "[SKIN]say.png",--%>
                            <%--title: "<spring:message code='message'/>"--%>
                        <%--});--%>
                        <%--isc.RPCManager.sendRequest(MyDsRequest(instituteUrl + record.id, "DELETE", null, "callback: institute_delete_result(rpcResponse)"));--%>
                    <%--}--%>
                <%--}--%>
            <%--});--%>
        <%--}--%>
    <%--};--%>

    <%--function ListGrid_institute_edit() {--%>
        <%--var record = ListGrid_Institute_JspInstitute.getSelectedRecord();--%>
        <%--if (record == null || record.id == null) {--%>
            <%--isc.Dialog.create({--%>
                <%--message: "<spring:message code='msg.record.not.selected'/>",--%>
                <%--icon: "[SKIN]ask.png",--%>
                <%--title: "<spring:message code='message'/>",--%>
                <%--buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],--%>
                <%--buttonClick: function (button, index) {--%>
                    <%--this.close();--%>
                <%--}--%>
            <%--});--%>
        <%--} else {--%>
            <%--instituteMethod = "PUT";--%>
            <%--DynamicForm_Institute_Institute.clearValues();--%>
            <%--url = "${restApiUrl}/api/institute/" + record.id;--%>
            <%--DynamicForm_Institute_Institute.editRecord(record);--%>
            <%--Window_Institute_JspInstitute.show();--%>
        <%--}--%>
    <%--};--%>

    <%--function ListGrid_institute_refresh() {--%>
        <%--ListGrid_Institute_JspInstitute.invalidateCache();--%>
    <%--};--%>

    <%--function ListGrid_institute_add() {--%>
        <%--instituteMethod = "POST";--%>
        <%--url = "${restApiUrl}/api/institute";--%>
        <%--DynamicForm_Institute_Institute.clearValues();--%>
        <%--Window_Institute_JspInstitute.show();--%>
    <%--};--%>

    <%--function ListGrid_institute_print(type) {--%>
        <%--var advancedCriteria = ListGrid_Institute_JspInstitute.getCriteria();--%>
        <%--var criteriaForm = isc.DynamicForm.create({--%>
            <%--method: "POST",--%>
            <%--action: "<spring:url value="/institute/printWithCriteria/"/>" + type,--%>
            <%--target: "_Blank",--%>
            <%--canSubmit: true,--%>
            <%--fields:--%>
                <%--[--%>
                    <%--{name: "CriteriaStr", type: "hidden"}--%>
                <%--]--%>
        <%--});--%>
        <%--criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));--%>
        <%--criteriaForm.submitForm();--%>
    <%--};--%>

    <%--function institute_action_result(resp) {--%>
        <%--if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {--%>
            <%--var responseID = JSON.parse(resp.data).id;--%>
            <%--var gridState = "[{id:" + responseID + "}]";--%>
            <%--var OK = isc.Dialog.create({--%>
                <%--message: "<spring:message code='msg.operation.successful'/>",--%>
                <%--icon: "[SKIN]say.png",--%>
                <%--title: "<spring:message code='msg.command.done'/>"--%>
            <%--});--%>
            <%--setTimeout(function () {--%>
                <%--OK.close();--%>
                <%--ListGrid_Institute_JspInstitute.setSelectedState(gridState);--%>
            <%--}, 1000);--%>
            <%--ListGrid_institute_refresh();--%>
            <%--Window_Institute_JspInstitute.close();--%>
        <%--} else {--%>
            <%--var ERROR = isc.Dialog.create({--%>
                <%--message: ("<spring:message code='msg.operation.error'/>"),--%>
                <%--icon: "[SKIN]stop.png",--%>
                <%--title: "<spring:message code='message'/>"--%>
            <%--});--%>
            <%--setTimeout(function () {--%>
                <%--ERROR.close();--%>
            <%--}, 3000);--%>
        <%--}--%>

    <%--};--%>

    <%--function institute_delete_result(resp) {--%>
        <%--instituteWait.close();--%>
        <%--if (resp.httpResponseCode == 200) {--%>
            <%--ListGrid_Institute_JspInstitute.invalidateCache();--%>
            <%--var OK = isc.Dialog.create({--%>
                <%--message: "<spring:message code='msg.record.remove.successful'/>",--%>
                <%--icon: "[SKIN]say.png",--%>
                <%--title: "<spring:message code='msg.command.done'/>"--%>
            <%--});--%>
            <%--setTimeout(function () {--%>
                <%--OK.close();--%>
            <%--}, 3000);--%>
        <%--} else {--%>
            <%--var ERROR = isc.Dialog.create({--%>
                <%--message: "<spring:message code='msg.record.remove.failed'/>",--%>
                <%--icon: "[SKIN]stop.png",--%>
                <%--title: "<spring:message code='message'/>"--%>
            <%--});--%>
            <%--setTimeout(function () {--%>
                <%--ERROR.close();--%>
            <%--}, 3000);--%>
        <%--}--%>
    <%--};--%>

    <%--function checkEmail(email) {--%>
        <%--if (email.indexOf("@") == -1 || email.indexOf(".") == -1 || email.lastIndexOf(".") < email.indexOf("@"))--%>
            <%--return false;--%>
        <%--else--%>
            <%--return true;--%>
    <%--};--%>