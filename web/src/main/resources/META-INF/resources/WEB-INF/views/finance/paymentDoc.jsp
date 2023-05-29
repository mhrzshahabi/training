<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let AgreementClassCost_ListGridData = [];
    let agreementClassCost_Data = [];
    let reportCriteria_ULR = null;
    let agreementMethod = "POST";
    let maxFileSizeUpload = 31457280;
    let isFileAttached = false;
    let rialId = null;



    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Payment = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "agreementNumber", title: "شماره تفاهم نامه", filterOperator: "iContains"}
        ],
        // fetchDataURL: agreementUrl + "/spec-list"
    });

    let RestDataSource_Payment_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
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
            {
                name: "agreementNumber",
            }
        ],
        recordClick: function () {
         },
        filterEditorSubmit: function () {
            ListGrid_Payment.invalidateCache();
        },

    });

    ListGrid_Class_Teaching_Cost = isc.ListGrid.create({
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
                                // ClassTeachingCost_SelectClass();
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
                name: "classTeachingCostTab",
                title: "انتخاب کلاس ها",
                pane: ListGrid_Class_Teaching_Cost
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
        height: "70%",
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
                name: "complexId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="complex"/>:",
                optionDataSource: RestDataSource_Payment_Department_Filter,
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                required: true,
                colSpan: 4,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
            }
        ]
    });
    IButton_Save_Payment = isc.IButtonSave.create({
        title: "<spring:message code='save'/>",
        align: "center",
        click: function () {

            <%--if (!DynamicForm_Payment.validate())--%>
            <%--    return;--%>
            <%--if (DynamicForm_Payment.getValue("secondParty") === "1" && DynamicForm_Payment.getValue("secondPartyTeacherId") == null) {--%>
            <%--    createDialog("info", "مدرس را انتخاب کنید");--%>
            <%--    return;--%>
            <%--}--%>
            <%--if (DynamicForm_Payment.getValue("secondParty") === "2" && DynamicForm_Payment.getValue("secondPartyInstituteId") == null) {--%>
            <%--    createDialog("info", "موسسه آموزشی را انتخاب کنید");--%>
            <%--    return;--%>
            <%--}--%>

            <%--let data = DynamicForm_Payment.getValues();--%>

            <%--if (agreementMethod === "POST") {--%>

            <%--    wait.show();--%>
            <%--    isc.RPCManager.sendRequest(TrDSRequest(agreementUrl, "POST", JSON.stringify(data), function (resp) {--%>
            <%--        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
            <%--            wait.close();--%>
            <%--            createDialog("info", "<spring:message code="global.form.request.successful"/>");--%>
            <%--            Window_Payment.close();--%>
            <%--            Payment_Refresh();--%>
            <%--        } else {--%>
            <%--            wait.close();--%>
            <%--            createDialog("info", "خطایی رخ داده است");--%>
            <%--            Window_Payment.close();--%>
            <%--        }--%>
            <%--    }));--%>

            <%--} else if (agreementMethod === "PUT") {--%>

            <%--    wait.show();--%>
            <%--    isc.RPCManager.sendRequest(TrDSRequest(agreementUrl + "/" + data.id, "PUT", JSON.stringify(data), function (resp) {--%>
            <%--        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
            <%--            wait.close();--%>
            <%--            createDialog("info", "<spring:message code="global.form.request.successful"/>");--%>
            <%--            Window_Payment.close();--%>
            <%--            Payment_Refresh();--%>
            <%--        } else {--%>
            <%--            wait.close();--%>
            <%--            createDialog("info", "خطایی رخ داده است");--%>
            <%--            Window_Payment.close();--%>
            <%--        }--%>
            <%--    }));--%>
            <%--}--%>
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
        title: "<spring:message code='agreement'/>",
        width: "50%",
        height: "70%",
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

    function Payment_Add() {
        //
        agreementMethod = "POST";
        DynamicForm_Payment.clearValues();
        DynamicForm_Payment.clearErrors();
        // DynamicForm_Payment.getItem("secondPartyTeacherId").disabled = false;
        // DynamicForm_Payment.getItem("secondPartyInstituteId").disabled = true;
        Window_Payment.setTitle("ایجاد تفاهم نامه/ قرارداد");
        Window_Payment.show();
    }
    function Payment_Edit() {

        // let record = ListGrid_Payment.getSelectedRecord();
        // if (record == null || record.id == null) {
        //     isc.Dialog.create({
        //         message: "تفاهم نامه ای برای ویرایش انتخاب نشده است.",
        //         icon: "[SKIN]ask.png",
        //         title: "توجه",
        //         buttons: [
        //             isc.IButtonSave.create({title: "تائید"})
        //         ],
        //         buttonClick: function (button, index) {
        //             this.close();
        //         }
        //     });
        // } else {
        //
        //     agreementMethod = "PUT";
        //     DynamicForm_Payment.clearValues();
        //     DynamicForm_Payment.clearErrors();
        //     DynamicForm_Payment.editRecord(record);
        //
        //     if (record.secondPartyTeacherId !== undefined && record.secondPartyTeacherId !== null) {
        //         DynamicForm_Payment.setValue("secondParty", "1");
        //         DynamicForm_Payment.setValue("secondPartyTeacherId", record.secondPartyTeacherId);
        //         // DynamicForm_Payment.getItem("secondParty").change(DynamicForm_Payment, DynamicForm_Payment.getItem("secondParty"), "1");
        //     } else {
        //         DynamicForm_Payment.setValue("secondParty", "2");
        //         DynamicForm_Payment.setValue("secondPartyInstituteId", record.secondPartyInstituteId);
        //         // DynamicForm_Payment.getItem("secondParty").change(DynamicForm_Payment, DynamicForm_Payment.getItem("secondParty"), "2");
        //     }
        //     // DynamicForm_Payment.getItem("currencyId").change(DynamicForm_Payment, DynamicForm_Payment.getItem("currencyId"), record.currencyId);
        //     Window_Payment.setTitle("ویرایش تفاهم نامه/ قرارداد");
        //     Window_Payment.show();
        // }
    }
    function Payment_Remove() {

        <%--let record = ListGrid_Payment.getSelectedRecord();--%>
        <%--if (record == null) {--%>
        <%--    isc.Dialog.create({--%>
        <%--        message: "تفاهم نامه ای برای حذف انتخاب نشده است.",--%>
        <%--        icon: "[SKIN]ask.png",--%>
        <%--        title: "توجه",--%>
        <%--        buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],--%>
        <%--        buttonClick: function (button, index) {--%>
        <%--            this.close();--%>
        <%--        }--%>
        <%--    });--%>
        <%--} else {--%>
        <%--    let Dialog_Delete = isc.Dialog.create({--%>
        <%--        message: "آيا مي خواهيد اين تفاهم نامه حذف گردد؟",--%>
        <%--        icon: "[SKIN]ask.png",--%>
        <%--        title: "توجه",--%>
        <%--        buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({--%>
        <%--            title: "خير"--%>
        <%--        })],--%>
        <%--        buttonClick: function (button, index) {--%>
        <%--            this.close();--%>
        <%--            if (index === 0) {--%>
        <%--                wait.show();--%>
        <%--                isc.RPCManager.sendRequest(TrDSRequest(agreementUrl + "/" + record.id, "DELETE", null, function (resp) {--%>
        <%--                    wait.close();--%>
        <%--                    if (resp.httpResponseCode === 200) {--%>
        <%--                        createDialog("info", "<spring:message code='global.grid.record.remove.success'/>");--%>
        <%--                        Payment_Refresh();--%>
        <%--                    } else {--%>
        <%--                        createDialog("info", "<spring:message code='global.grid.record.remove.failed'/>")--%>
        <%--                    }--%>
        <%--                }));--%>
        <%--            }--%>
        <%--        }--%>
        <%--    });--%>
        <%--}--%>
    }
    function Payment_Refresh() {
        ListGrid_Payment.clearFilterValues();
        ListGrid_Payment.invalidateCache();
        ListGrid_Class_Teaching_Cost.setData([]);
    }



    // </script>