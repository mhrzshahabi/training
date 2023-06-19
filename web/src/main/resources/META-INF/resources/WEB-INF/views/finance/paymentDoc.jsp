<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
// /    let agreementClassCost_Data = [];
//     let reportCriteria_ULR = null;
    let paymentMethod = "POST";
    // let maxFileSizeUpload = 31457280;
    // let isFileAttached = false;



    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Payment = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "agreement.agreementNumber", title: "شماره تفاهم نامه", filterOperator: "iContains"},
            {name: "agreement.id",  hidden: true},
            {name: "agreement.agreementDate", title: "تاریخ عقد تفاهم نامه", filterOperator: "iContains"},
            {name: "createdDate", title: "تاریخ ثبت سند"},
            {name: "paymentDocStatus", title: "آخرین وضعیت سند"},
            {name: "lastModifiedDate", title: "تاریخ ویرایش سند"},
            {name: "createdBy", title: "کاربر ثبت کننده سند", filterOperator: "iContains"},
            {name: "lastModifiedBy", title: "کاربر ویرایش کننده سند", filterOperator: "iContains"}
        ],
        fetchDataURL: paymentUrl + "/spec-list"
    });

    let RestDataSource_Payment_Agrement_Filter = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "agreementNumber", title: "شماره تفاهم نامه", filterOperator: "iContains"},
            {name: "agreementDate", title: "تاریخ عقد تفاهم نامه", filterOperator: "iContains"},
            {name: "fromDate", title: "<spring:message code='from.date'/>"},
            {name: "toDate", title: "<spring:message code='to.date'/>"},
            {name: "firstParty.titleFa", title: "طرف اول ", filterOperator: "iContains"},
            {name: "secondPartyTeacher.fullNameFa", title: "طرف دوم", filterOperator: "iContains"}
        ],
        fetchDataURL: agreementUrl + "/spec-list"
    });
    //----------------------------------- layOut -----------------------------------------------------------------------
    ToolStripButton_Add_Payment = isc.ToolStripButtonCreate.create({
        click: function () {
            Payment_Add();
        }
    });
    ToolStripButton_Edit_Payment = isc.ToolStripButtonEdit.create({
        click: function () {
            Payment_Edit();
        }
    });
    ToolStripButton_Remove_Payment = isc.ToolStripButtonRemove.create({
        click: function () {
            Payment_Remove();
        }
    });
    ToolStripButton_Refresh_Payment = isc.ToolStripButtonRefresh.create({
        click: function () {
            Payment_Refresh();
        }
    });
    ToolStrip_Actions_payment = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_Payment,
                ToolStripButton_Edit_Payment,
                ToolStripButton_Remove_Payment,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_Payment
                    ]
                })
            ]
    });

    ListGrid_Payment = isc.TrLG.create({
        height: "55%",
        autoFetchData: true,
        showFilterEditor: true,
        filterOnKeypress: false,
        dataSource: RestDataSource_Payment,
        gridComponents: ["filterEditor", "header", "body"],
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {name: "id", hidden: true},
            {name: "agreement.id",hidden: true},
            {name: "agreement.agreementNumber"},
            {name: "agreement.agreementDate"},
            {name: "paymentDocStatus"},
            {name: "createdBy"},
            {name: "createdDate",  canFilter: false, formatCellValue: function (value) {
                    if (value) {
                        let d = new Date(value);
                        return d.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }},
            {name: "lastModifiedBy"},
            {name: "lastModifiedDate",  canFilter: false, formatCellValue: function (value) {
                    if (value) {
                        let d = new Date(value);
                        return d.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }},{
                name: "changeStatus",
                align: "center",
                showTitle: false,
                canFilter: false
            },

        ],
        createRecordComponent: function (record, colNum) {

            let fieldName = this.getFieldName(colNum);
            if (fieldName === "changeStatus") {
                return isc.IButton.create({
                    layoutAlign: "center",
                    title: "تغییر وضعیت",
                    width: "145",
                    margin: 3,
                    click: function () {
                        changePaymentStatus(record.id);
                    }
                });
            } else return null;
        },

        recordClick: function () {
            selectionUpdated_Payment_class();
        },
        filterEditorSubmit: function () {
            ListGrid_Payment.invalidateCache();
        },

    });

    ListGrid_Class_Payment = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canEdit: true,
        autoFetchData: true,
        validateByCell: true,
        selectCellTextOnClick: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {name: "id", hidden: true},
            {
                name: "classId",
                hidden: true
            },
            {
                name: "titleClass",
                title: "عنوان کلاس",
                canEdit: false
            },
            {
                name: "code",
                title: "کد کلاس",
                canEdit: false
            },
            {
                name: "classDuration",
                title: "مدت دوره کلاس (ساعت)",
                canEdit: false

            },
            {
                name: "timeSpent",
                title: "مقدار زمان برگزار شده کلاس (ساعت)",
                required: true,
                canEdit: true,
                format: "0,",
                filterEditorProperties: {
                    keyPressFilter: "[0-9|.]"
                },
                change: function (form, item, value, oldValue) {
                    if (value != null && value != '' && typeof (value) != 'undefined' && !value.match(/^(([1-9]\d{0,4})|100|0)$/)) {
                        item.setValue(value.substring(0, value.length - 1));
                    } else {
                        item.setValue(value);
                    }

                    if (value == null || typeof (value) == 'undefined') {
                        item.setValue('');
                    }


                    if (oldValue == null || typeof (oldValue) == 'undefined') {
                        oldValue = '';
                    }


                    if (item.getValue() != oldValue) {
                        setFinalAmount(value, form);                    }
                },
            },
            {
                name: "teachingCostPerHour",
                title: "مبلغ توافق تفاهم نامه",
                canEdit: false
            },
            {
                name: "finalAmount",
                title: "مبلغ کل",
                canEdit: false,
                required: true,
                format: "0,",
            },
            {
                name: "removeIcon",
                width: "4%",
                align: "center",
                showTitle: false,
                canFilter: false,
                canEdit: false
            }
        ],
        gridComponents: [
            isc.ToolStrip.create({
                width: "100%",
                height: "5%",
                membersMargin: 5,
                members:
                    [
                        isc.Button.create({
                            name: "class",
                            title: "انتخاب کلاس",
                            colSpan: 2,
                            align: "center",
                            width: 200,
                            type: "button",
                            startRow: true,
                            endRow: false,
                            click: function () {
                                let canChoose= ListGrid_Payment.getSelectedRecord().paymentDocStatus === 'ثبت اولیه';
                                if (canChoose){
                                    selectClassForPayment();
                                }else {
                                    createDialog("info", "سند پرداخت شده ویرایش نخواهد شد");
                                }
                            }
                        })
                    ]
            }),
            "header",
            "body",
            isc.HLayout.create({
                layoutMargin: 5,
                width: "100%",
                height: "10%",
                align: "center",
                membersMargin: 10,
                alignLayout: "center",
                members: [
                    isc.IButtonSave.create({
                        title: "ذخیره تغییرات",
                        align: "center",
                        click: function () {
                            let canSave= ListGrid_Payment.getSelectedRecord().paymentDocStatus === 'ثبت اولیه';
                            if (canSave){
                                Payment_classes_Save()
                            }else {
                                createDialog("info", "سند پرداخت شده ویرایش نخواهد شد");
                            }
                          }
                    })
                ]
            })
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
                        let canRemove= ListGrid_Payment.getSelectedRecord().paymentDocStatus === 'ثبت اولیه';
                        if (canRemove){
                            payment_classes_Remove(record);
                        }else {
                            createDialog("info", "سند پرداخت شده ویرایش نخواهد شد");
                        }
                    }
                });
                return removeImg;
            } else {
                return null;
            }
        }
    });
    TabSet_Payment = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {
                name: "classTeachingCostTabPayment",
                title: "انتخاب کلاس ها",
                pane: ListGrid_Class_Payment
            }
        ]
    });
    HLayout_Tab_Payment = isc.HLayout.create({
        width: "100%",
        height: "40%",
        members: [
            TabSet_Payment
        ]
    });

    DynamicForm_Payment = isc.DynamicForm.create({
        width: "85%",
        height: "100%",
        align: "center",
        canSubmit: true,
        wrapItemTitles: false,
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        fields: [
            {name: "id", hidden: true},
            {
                name: "agreementId",
                editorType: "ComboBoxItem",
                title: "تفاهم نامه :",
                optionDataSource: RestDataSource_Payment_Agrement_Filter,
                displayField: "agreementNumber",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                required: true,
                colSpan: 4,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "agreementNumber",filterOperator: "iContains"},
                    {name: "agreementDate", filterOperator: "iContains"},
                    {name: "fromDate", filterOperator: "iContains"},
                    {name: "toDate", filterOperator: "iContains"},
                    {name: "firstParty.titleFa", filterOperator: "iContains"},
                    {name: "secondPartyTeacher.fullNameFa",filterOperator: "iContains"}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: true
                },
            }
        ]
    });
    IButton_Save_Payment = isc.IButtonSave.create({
        title: "<spring:message code='save'/>",
        align: "center",
        click: function () {

            if (!DynamicForm_Payment.validate())
                return;


            let data = DynamicForm_Payment.getValues();
            let paymentData = {};
            paymentData.agreementId = data.agreementId
            if (paymentMethod === "POST") {

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(paymentUrl, "POST", JSON.stringify(paymentData), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Payment.close();
                        Payment_Refresh();
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                        Window_Payment.close();
                    }
                }));

            } else if (paymentMethod === "PUT") {

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(paymentUrl + "/" + data.id, "PUT", JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Payment.close();
                        Payment_Refresh();
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                        Window_Payment.close();
                    }
                }));
            }
        }
    });
    IButton_Exit_Payment = isc.IButtonCancel.create({
        title: "<spring:message code='cancel'/>",
        align: "center",
        click: function () {
            Window_Payment.close();
        }
    });
    HLayOut_SaveOrExit_Payment = isc.HLayout.create({
        layoutMargin: 5,
        width: "100%",
        height: "10%",
        align: "center",
        membersMargin: 10,
        alignLayout: "center",
        members: [
            IButton_Save_Payment,
            IButton_Exit_Payment
        ]
    });
    Window_Payment = isc.Window.create({
        title: "ایجاد سند پرداخت",
        width: "50%",
        height: "20%",
        autoSize: false,
        align: "center",
        items: [
            DynamicForm_Payment,
            HLayOut_SaveOrExit_Payment
        ]
    });

    VLayout_Body_Payment = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_payment,
            ListGrid_Payment,
            HLayout_Tab_Payment
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    function setFinalAmount (value, form) {
        let   totalAmount = 0;
        let teachingCostPerHour = 0


        teachingCostPerHour = ListGrid_Class_Payment.getSelectedRecord().teachingCostPerHour;

        if (!isNaN(teachingCostPerHour)) {
            totalAmount = Number(teachingCostPerHour) * Number(value);
        }
        ListGrid_Class_Payment.setEditValue(form.grid.getRowNum(form.grid.getSelectedRecord()), form.grid.getField("finalAmount").masterIndex, totalAmount);
     }


    function Payment_Add() {
        //
        paymentMethod = "POST";
        DynamicForm_Payment.clearValues();
        DynamicForm_Payment.clearErrors();
        // DynamicForm_Payment.getItem("secondPartyTeacherId").disabled = false;
        // DynamicForm_Payment.getItem("secondPartyInstituteId").disabled = true;
        Window_Payment.setTitle("ایجاد سند پرداخت");
        Window_Payment.show();
    }
    function Payment_Edit() {

        let record = ListGrid_Payment.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "تفاهم نامه ای برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [
                    isc.IButtonSave.create({title: "تائید"})
                ],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else  if (record.paymentDocStatus!== 'ثبت اولیه' ) {
            createDialog("info", "سند فقط در وضعیت ثبت اولیه امکان ویرایش دارد");

        } else   {

            paymentMethod = "PUT";
            DynamicForm_Payment.clearValues();
            DynamicForm_Payment.clearErrors();
            DynamicForm_Payment.editRecord(record);
            Window_Payment.setTitle("ویرایش سند پرداخت");
            Window_Payment.show();
        }
    }
    function Payment_Remove() {

        let record = ListGrid_Payment.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "سندی برای حذف انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else  if (record.paymentDocStatus!== 'ثبت اولیه' ) {
            createDialog("info", "سند فقط در وضعیت ثبت اولیه امکان ویرایش دارد");

        }else {
            let Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين سند حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                    title: "خير"
                })],
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(paymentUrl + "/" + record.id, "DELETE", null, function (resp) {
                            wait.close();
                            if (resp.httpResponseCode === 200) {
                                createDialog("info", "<spring:message code='global.grid.record.remove.success'/>");
                                Payment_Refresh();
                            } else {
                                createDialog("info", "<spring:message code='global.grid.record.remove.failed'/>")
                            }
                        }));
                    }
                }
            });
        }
    }
    function Payment_Refresh() {
        ListGrid_Payment.clearFilterValues();
        ListGrid_Payment.invalidateCache();
        ListGrid_Class_Payment.setData([]);
    }

    function selectClassForPayment() {

        let record = ListGrid_Payment.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "سندی انتخاب نشده است.",
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
            let RestDataSource_Select_Class = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true},
                    {name: "titleClass", filterOperator: "iContains"},
                    {name: "code", filterOperator: "iContains"},
                    {name: "course.titleFa"}
                ],
                fetchDataURL: agreementClassCostUrl + "/list-by-agreementId-for-payment/" + record.agreement.id,
                // implicitCriteria: {
                //     _constructor:"AdvancedCriteria",
                //     operator:"and",
                //     criteria:[{ fieldName: "classStatus", operator: "inSet", value: ["2","3","4","5"]}
                //     ]
                // },
            });
            let ListGrid_Select_Class = isc.TrLG.create({
                height: "90%",
                autoFetchData: true,
                showFilterEditor: true,
                filterOnKeypress: false,
                selectionType: "simple",
                selectionAppearance: "checkbox",
                dataSource: RestDataSource_Select_Class,
                gridComponents: ["filterEditor", "header", "body"],
                initialSort: [
                    {property: "id", direction: "descending"}
                ],
                fields: [
                    {name: "id", hidden: true},
                    {name: "titleClass", title: "عنوان کلاس"},
                    {name: "code", title: "کد کلاس"}
                ]
            });

            let IButton_Select_Class_Save = isc.IButtonSave.create({
                title: "<spring:message code='save'/>",
                align: "center",
                click: function () {
                    let records = ListGrid_Select_Class.getSelectedRecords();
                    let selectedClasses = [];
                    records.forEach(item => {
                        let object = {
                            classId: item.id,
                            titleClass: item.titleClass,
                            code: item.code,
                            classDuration: item.classDuration,
                            teachingCostPerHour: item.teachingCostPerHour
                        };
                        selectedClasses.add(object);
                    });

                    let addedClasses = ListGrid_Class_Payment.getData();
                    let addedClassesId = ListGrid_Class_Payment.getData().map(item => item.classId);
                    selectedClasses.forEach(item => {
                        if (addedClassesId.contains(item.classId))
                            selectedClasses.splice(selectedClasses.indexOf(item), 1);
                    });

                    ListGrid_Class_Payment.setData(selectedClasses.concat(addedClasses));
                    Window_Select_Class.close();
                }
            });
            let IButton_Select_Class_Exit = isc.IButtonCancel.create({
                title: "<spring:message code='close'/>",
                align: "center",
                click: function () {
                    Window_Select_Class.close();
                }
            });
            let HLayOut_Select_Class_SaveOrExit = isc.HLayout.create({
                layoutMargin: 5,
                showEdges: false,
                edgeImage: "",
                width: "100%",
                height: "10%",
                alignLayout: "center",
                align: "center",
                membersMargin: 10,
                members: [
                    IButton_Select_Class_Save,
                    IButton_Select_Class_Exit
                ]
            });
            let Window_Select_Class = isc.Window.create({
                title: "انتخاب کلاس",
                autoSize: false,
                width: "40%",
                height: "45%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    ListGrid_Select_Class,
                    HLayOut_Select_Class_SaveOrExit
                ]
            });

            Window_Select_Class.show();
        }
    }
    function selectionUpdated_Payment_class() {

        let payment = ListGrid_Payment.getSelectedRecord();
        let tab = TabSet_Payment.getSelectedTab();

        if (payment == null && tab.pane != null) {
            tab.pane.setData([]);
            return;
        }

        switch (tab.name) {
            case "classTeachingCostTabPayment": {
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(paymentDocClassUrl + "/list-by-paymentId/" + payment.id, "GET", null, function (resp) {
                    wait.close();
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        let classCostList = JSON.parse(resp.httpResponseText);
                        ListGrid_Class_Payment.setData(classCostList);
                    } else {
                        createDialog("info", "خطایی رخ داده است");
                    }
                }));
                break;
            }
        }
    }
    function changePaymentStatus(id) {
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(paymentUrl + "/change-payment-status/" + id, "PUT", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                Payment_Refresh()

            } else {
                let respText =  JSON.parse(resp.httpResponseText);
                createDialog("info", respText.message,
                    "<spring:message code="message"/>");
            }
        }));
    }
    function Payment_classes_Save() {

        let isValid = true;
        ListGrid_Class_Payment.endEditing();
        for (let i = 0; i < ListGrid_Class_Payment.getTotalRows(); i++) {
            if (!ListGrid_Class_Payment.validateRow(i))
                return;
        }
        // if (ListGrid_Payment.getSelectedRecord()===null || ListGrid_Payment.getSelectedRecord()===undefined){
        //     createDialog("info", "روی سند مورد نظر کلیک کنید");
        //     return;
        // }
        // let agreementSelectedId=  ListGrid_Payment.getSelectedRecord().agreement.id;

        let costList = ListGrid_Class_Payment.getData();
        costList.forEach(item => {
            if (item.finalAmount === undefined || item.teachingCostPerHour === undefined)
                isValid = false;
            item.paymentDocId=ListGrid_Payment.getSelectedRecord().id

        });

        if (isValid) {
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(paymentDocClassUrl, "POST", JSON.stringify(costList), function (resp) {
                wait.close();
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    selectionUpdated_Payment_class();
                } else {
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        } else {
            createDialog("info", "مبلغ کل برای بعضی از رکوردها مشخض نشده است");
        }



    }
    function payment_classes_Remove(record) {

        if (record.id == null) {
            ListGrid_Class_Payment.selectSingleRecord(record);
            ListGrid_Class_Payment.removeData(record);
        } else {
            let Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين رکورد حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                    title: "خير"
                })],
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(paymentDocClassUrl + "/" + record.id, "DELETE", null, function (resp) {
                            wait.close();
                            if (resp.httpResponseCode === 200) {
                                createDialog("info", "<spring:message code='global.grid.record.remove.success'/>");
                                selectionUpdated_Payment_class();
                            } else {
                                createDialog("info", "<spring:message code='global.grid.record.remove.failed'/>")
                            }
                        }));
                    }
                }
            });
        }
    }




    // </script>