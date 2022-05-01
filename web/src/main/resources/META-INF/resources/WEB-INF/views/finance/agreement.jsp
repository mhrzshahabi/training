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

    //----------------------------------------------------Default Rest--------------------------------------------------
    isc.RPCManager.sendRequest(TrDSRequest(parameterValueUrl + "/get-id?code=Rial", "GET", null, function (resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            rialId = Number(JSON.parse(resp.data));
        }
    }));

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Agreement = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "firstPartyId", title: "firstPartyId", hidden: true},
            {name: "firstParty.titleFa", title: "طرف اول تفاهم نامه", filterOperator: "iContains"},
            {name: "secondPartyTeacherId", title: "secondPartyTeacherId", hidden: true},
            {name: "secondPartyTeacher.teacherCode", title: "طرف دوم تفاهم نامه (مدرس)", filterOperator: "iContains"},
            {name: "secondPartyInstituteId", title: "secondPartyInstituteId", hidden: true},
            {name: "secondPartyInstitute.titleFa", title: "طرف دوم تفاهم نامه (موسسه آموزشی)", filterOperator: "iContains"},
            {name: "serviceType.title", title: "نوع خدمات", filterOperator: "iContains"},
            {name: "finalCost", title: "مبلغ نهایی"},
            {name: "currency.title", title: "واحد", filterOperator: "iContains"},
            {name: "subject", title: "موضوع تفاهم نامه", filterOperator: "iContains"},
            {name: "teacherEvaluation", title: "اعمال نمره ارزشیابی مدرس برای پرداخت", valueMap: {"true" : "بله", "false" : "خیر"}},
            {name: "maxPaymentHours", title: "حداکثر ساعت پرداختی"}
        ],
        fetchDataURL: agreementUrl + "/spec-list"
    });
    RestDataSource_Institute_Agreement = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "نام موسسه"},
            {name: "instituteId", title: "شماره ملی"},
            {name: "economicalId", title: "شماره اقتصادی"},
            {name: "contactInfo.workAddress.restAddr", title: "آدرس"},
            {name: "contactInfo.workAddress.phone", title: "تلفن"},
            {name: "contactInfo.workAddress.fax", title: "فاکس"},
            {name: "manager.firstNameFa", title: "نام مدیر"},
            {name: "manager.lastNameFa", title: "نام خانوادگی مدیر"},
            {name: "manager.contactInfo.mobile", title: "موبایل مدیر"},
            {name: "accountInfoSet", title: "شبا"},
            {name: "valid", hidden: true}
        ],
        fetchDataURL: instituteUrl + "spec-list-agreement"
    });
    RestDataSource_Teacher_Agreement = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "teacherCode", title: "کد مدرس", filterOperator: "iContains"},
            {name: "personality.firstNameFa", title: "نام", filterOperator: "iContains"},
            {name: "personality.lastNameFa", title: "نام خانوادگی", filterOperator: "iContains"},
            {name: "personality.nationalCode", title: "کدملی", filterOperator: "iContains"},
            {name: "personality.contactInfo.mobile", title: "موبایل", filterOperator: "iContains"},
            {name: "personality.contactInfo.homeAddress.restAddr", title: "آدرس منزل", filterOperator: "iContains"},
            {name: "personality.accountInfo.shabaNumber", title: "شبا", filterOperator: "iContains"},
            {name: "valid", hidden: true}
        ],
        fetchDataURL: teacherUrl + "spec-list-agreement"
    });
    RestDataSource_Service_Type_Agreement = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "title"}
        ],
        fetchDataURL: enumUrl + "serviceType/spec-list",
    });
    RestDataSource_Currency_Agreement = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>"},
                {name: "code", title: "<spring:message code="code"/>"}
            ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/currency"
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    ToolStripButton_Add_Agreement = isc.ToolStripButtonCreate.create({
        click: function () {
            Agreement_Add();
        }
    });
    ToolStripButton_Edit_Agreement = isc.ToolStripButtonEdit.create({
        click: function () {
            Agreement_Edit();
        }
    });
    ToolStripButton_Remove_Agreement = isc.ToolStripButtonRemove.create({
        click: function () {
            Agreement_Remove();
        }
    });
    ToolStripButton_Refresh_Agreement = isc.ToolStripButtonRefresh.create({
        click: function () {
            Agreement_Refresh();
        }
    });
    ToolStrip_Actions_Agreement = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                <sec:authorize access="hasAuthority('Agreement_C')">
                ToolStripButton_Add_Agreement,
                </sec:authorize>
                <sec:authorize access="hasAuthority('Agreement_U')">
                ToolStripButton_Edit_Agreement,
                </sec:authorize>
                <sec:authorize access="hasAuthority('Agreement_D')">
                ToolStripButton_Remove_Agreement,
                </sec:authorize>
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        <sec:authorize access="hasAuthority('Agreement_R')">
                        ToolStripButton_Refresh_Agreement
                        </sec:authorize>
                    ]
                })
            ]
    });

    ListGrid_Agreement = isc.TrLG.create({
        height: "90%",
        autoFetchData: true,
        showFilterEditor: true,
        filterOnKeypress: false,
        <sec:authorize access="hasAuthority('Agreement_R')">
        dataSource: RestDataSource_Agreement,
        </sec:authorize>
        gridComponents: ["filterEditor", "header", "body"],
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {name: "id", hidden: true},
            {name: "firstParty.titleFa"},
            {name: "secondPartyTeacher.teacherCode"},
            {name: "secondPartyInstitute.titleFa"},
            {name: "serviceType.title"},
            {name: "finalCost"},
            {name: "currency.title"},
            {name: "subject"},
            {name: "teacherEvaluation"},
            {name: "maxPaymentHours"}
        ]
    });
    ListGrid_Class_Teaching_Cost = isc.ListGrid.create({
        width: "100%",
        height: "70%",
        autoFetchData: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {name: "id", hidden: true},
            {name: "classId", hidden: true},
            {name: "titleClass", title: "عنوان کلاس"},
            {name: "code", title: "کدکلاس"},
            {name: "teachingCostPerHour", title: "هزینه ساعتی تدریس", canEdit: true},
            {name: "agreementId", hidden: true},
            {
                name: "removeIcon",
                width: "4%",
                align: "center",
                showTitle: false,
                canFilter: false
            }
        ],
        click: function () {
        },
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
                        ListGrid_Class_Teaching_Cost.selectSingleRecord(record);
                        ListGrid_Class_Teaching_Cost.removeData(record);
                    }
                });
                return removeImg;
            } else {
                return null;
            }
        }
    });

    DynamicForm_Agreement = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        wrapItemTitles: false,
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 2,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "firstPartyId",
                title: "طرف اول تفاهم نامه",
                required: true,
                colSpan: 4,
                type: "selectItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Institute_Agreement,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "titleFa", title: "نام موسسه", filterOperator: "iContains"},
                    {name: "instituteId", title: "شماره ملی", filterOperator: "iContains"},
                    {name: "economicalId", title: "شماره اقتصادی", filterOperator: "iContains"},
                    {name: "contactInfo.workAddress.phone", title: "تلفن", filterOperator: "iContains"},
                    {name: "manager.firstNameFa", title: "نام مدیر", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", title: "نام خانوادگی مدیر", filterOperator: "iContains"},
                    {name: "valid", hidden: true}
                ],
                pickListProperties: {
                    showFilterEditor: false
                },
                click: function (form, item) {
                    item.fetchData();
                },
                changed: function (form, item) {
                    checkInstituteValidation(item);
                }
            },
            {
                name: "secondParty",
                title: "طرف دوم تفاهم نامه",
                required: true,
                colSpan: 4,
                type: "radioGroup",
                defaultValue: "1",
                valueMap: {
                    "1" : "مدرس",
                    "2" : "موسسه آموزشی"
                },
                change: function (form, item, value) {
                    if (value === "1") {
                        form.getItem("secondPartyTeacherId").show();
                        form.getItem("secondPartyTeacherId").setRequired(true);
                        form.getItem("secondPartyInstituteId").hide();
                        form.getItem("secondPartyInstituteId").setRequired(false);
                    } else if (value === "2") {
                        form.getItem("secondPartyTeacherId").hide();
                        form.getItem("secondPartyTeacherId").setRequired(false);
                        form.getItem("secondPartyInstituteId").show();
                        form.getItem("secondPartyInstituteId").setRequired(true);
                    }
                }
            },
            {
                name: "secondPartyTeacherId",
                title: "طرف دوم تفاهم نامه (مدرس)",
                required: true,
                colSpan: 4,
                hidden: false,
                type: "selectItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Teacher_Agreement,
                valueField: "id",
                displayField: "teacherCode",
                filterFields: ["teacherCode"],
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "teacherCode", title: "کد مدرس"},
                    {name: "personality.firstNameFa", title: "نام"},
                    {name: "personality.lastNameFa", title: "نام خانوادگی"},
                    {name: "personality.nationalCode", title: "کدملی"},
                    {name: "personality.contactInfo.mobile", title: "موبایل"},
                    {name: "personality.contactInfo.homeAddress.restAddr", title: "آدرس منزل"},
                    {name: "personality.accountInfo.shabaNumber", title: "شبا"},
                    {name: "valid", hidden: true}
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
                click: function (form, item) {
                    item.fetchData();
                },
                changed: function (form, item) {
                    checkTeacherValidation(item);
                }
            },
            {
                name: "secondPartyInstituteId",
                title: "طرف دوم تفاهم نامه (موسسه آموزشی)",
                required: false,
                colSpan: 4,
                hidden: true,
                type: "selectItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Institute_Agreement,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "titleFa", title: "نام موسسه", filterOperator: "iContains"},
                    {name: "instituteId", title: "شماره ملی", filterOperator: "iContains"},
                    {name: "economicalId", title: "شماره اقتصادی", filterOperator: "iContains"},
                    {name: "contactInfo.workAddress.phone", title: "تلفن", filterOperator: "iContains"},
                    {name: "manager.firstNameFa", title: "نام مدیر", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", title: "نام خانوادگی مدیر", filterOperator: "iContains"},
                    {name: "valid", hidden: true}
                ],
                pickListProperties: {
                    showFilterEditor: false
                },
                click: function (form, item) {
                    item.fetchData();
                },
                changed: function (form, item) {
                    checkInstituteValidation(item);
                }
            },
            {
                name: "serviceTypeId",
                title: "نوع خدمات",
                required: true,
                colSpan: 2,
                type: "radioGroup",
                defaultValue: 1,
                valueMap: {
                    1 : "تدریس",
                    2 : "سایر خدمات"
                }
            },
            {
                name: "class",
                title: "انتخاب کلاس (ها)",
                colSpan: 2,
                align: "center",
                width: 170,
                type: "button",
                startRow: false,
                endRow: false,
                click: function () {
                    calculateFinalCost();
                }
            },
            {
                name: "finalCost",
                title: "مبلغ نهایی",
                required: true,
                colSpan: 4,
                type: "float"
            },
            {
                name: "currencyId",
                title: "واحد",
                required: true,
                colSpan: 4,
                type: "selectItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Currency_Agreement,
                displayField: "title",
                valueField: "id",
                pickListProperties: {
                    showFilterEditor: false
                },
                click: function (form, item) {
                    item.fetchData();
                },
                change: function (form, item, value) {
                    let finalCost = form.getItem("finalCost").getValue();
                    if (finalCost != null) {
                        if (value === rialId) {
                            let finalCostT = finalCost / 10;
                            form.getItem("alphabeticFinalCost").show();
                            form.setValue("alphabeticFinalCost", String(finalCostT).toPersianLetter() + " تومان");
                        } else
                            form.getItem("alphabeticFinalCost").hide();
                    }
                }
            },
            {
                name: "alphabeticFinalCost",
                title: "مبلغ نهایی به حروف",
                required: false,
                colSpan: 4,
                type: "staticText",
                hidden: true
            },
            {
                name: "subject",
                title: "موضوع تفاهم نامه",
                colSpan: 4,
                type: "textArea",
                height: "100",
                length: 150
            },
            {
                name: "teacherEvaluation",
                title: "اعمال نمره ارزشیابی مدرس برای پرداخت",
                required: true,
                colSpan: 4,
                type: "radioGroup",
                defaultValue: "false",
                valueMap: {
                    "true" : "بله",
                    "false" : "خیر"
                },
                change: function (form, item, value, oldValue) {
                    if (value === "1") {
                        form.getItem("class").setRequired(true);
                    } else {
                        form.getItem("class").setRequired(false);
                    }
                }
            },
            {
                name: "maxPaymentHours",
                title: "حداکثر ساعت پرداختی",
                required: true,
                colSpan: 4,
                type: "float"
            }
        ]
    });
    IButton_Save_Agreement = isc.IButtonSave.create({
        title: "<spring:message code='save'/>",
        align: "center",
        click: function () {

            DynamicForm_Agreement.validate();
            if (DynamicForm_Agreement.hasErrors())
                return;
            let data = DynamicForm_Agreement.getValues();

            if (agreementMethod === "POST") {

                if (data.serviceTypeId === 1 && agreementClassCost_Data.length === 0) {
                    createDialog("info", "کلاسی انتخاب نشده است");
                    return;
                }

                let create = {
                    firstPartyId: data.firstPartyId,
                    secondPartyTeacherId: data.secondPartyTeacherId,
                    secondPartyInstituteId: data.secondPartyInstituteId,
                    serviceTypeId: data.serviceTypeId,
                    currencyId: data.currencyId,
                    finalCost: data.finalCost,
                    subject: data.subject,
                    teacherEvaluation: data.teacherEvaluation,
                    maxPaymentHours: data.maxPaymentHours,
                    classCostList: agreementClassCost_Data
                };

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(agreementUrl, "POST", JSON.stringify(create), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Agreement.close();
                        ListGrid_Agreement.invalidateCache();
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                        Window_Agreement.close();
                    }
                }));

            } else if (agreementMethod === "PUT") {

                let update = {
                    id: data.id,
                    firstPartyId: data.firstPartyId,
                    secondPartyTeacherId: data.secondPartyTeacherId,
                    secondPartyInstituteId: data.secondPartyInstituteId,
                    serviceTypeId: data.serviceTypeId,
                    currencyId: data.currencyId,
                    finalCost: data.finalCost,
                    subject: data.subject,
                    teacherEvaluation: data.teacherEvaluation,
                    maxPaymentHours: data.maxPaymentHours,
                    classCostList: agreementClassCost_Data
                };

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(agreementUrl + "/" + data.id, "PUT", JSON.stringify(update), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Agreement.close();
                        ListGrid_Agreement.invalidateCache();
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                        Window_Agreement.close();
                    }
                }));
            }
        }
    });
    IButton_Exit_Agreement = isc.IButtonCancel.create({
        title: "<spring:message code='cancel'/>",
        align: "center",
        click: function () {
            Window_Agreement.close();
        }
    });
    HLayOut_SaveOrExit_Agreement = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: 50,
        alignLayout: "center",
        align: "center",
        membersMargin: 10,
        members: [IButton_Save_Agreement, IButton_Exit_Agreement]
    });

    Window_Agreement = isc.Window.create({
        title: "<spring:message code='agreement'/>",
        width: "50%",
        height: "40%",
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [
                DynamicForm_Agreement,
                HLayOut_SaveOrExit_Agreement
            ]
        })]
    });

    VLayout_Body_Agreement = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_Agreement,
            ListGrid_Agreement
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function Agreement_Add() {

        agreementMethod = "POST";
        isFileAttached = false;
        DynamicForm_Agreement.clearValues();
        DynamicForm_Agreement.clearErrors();
        Window_Agreement.setTitle("ایجاد تفاهم نامه");
        Window_Agreement.show();
    }
    function Agreement_Edit() {

        let record = ListGrid_Agreement.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "تفاهم نامه ای برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            agreementMethod = "PUT";
            DynamicForm_Agreement.clearValues();
            DynamicForm_Agreement.clearErrors();
            DynamicForm_Agreement.editRecord(record);
            if (record.secondPartyTeacherId !== undefined && record.secondPartyTeacherId !== null) {
                DynamicForm_Agreement.setValue("secondParty", "1");
                DynamicForm_Agreement.getItem("secondParty").change(DynamicForm_Agreement, DynamicForm_Agreement.getItem("secondParty"), "1");
            } else {
                DynamicForm_Agreement.setValue("secondParty", "2");
                DynamicForm_Agreement.getItem("secondParty").change(DynamicForm_Agreement, DynamicForm_Agreement.getItem("secondParty"), "2");
            }
            DynamicForm_Agreement.getItem("currencyId").change(DynamicForm_Agreement, DynamicForm_Agreement.getItem("currencyId"), record.currencyId);
            Window_Agreement.setTitle("ویرایش تفاهم نامه");
            Window_Agreement.show();
        }
    }
    function Agreement_Remove() {

        let record = ListGrid_Agreement.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "تفاهم نامه ای برای حذف انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            let Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين تفاهم نامه حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                    title: "خير"
                })],
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(agreementUrl + "/" + record.id, "DELETE", null, function (resp) {
                            wait.close();
                            if (resp.httpResponseCode === 200) {
                                createDialog("info", "<spring:message code='global.grid.record.remove.success'/>");
                                ListGrid_Agreement.invalidateCache();
                            } else {
                                createDialog("info", "<spring:message code='global.grid.record.remove.failed'/>")
                            }
                        }));
                    }
                }
            });
        }
    }
    function Agreement_Refresh() {
        ListGrid_Agreement.clearFilterValues();
        ListGrid_Agreement.invalidateCache();
    }

    function calculateFinalCost() {

        let RestDataSource_Select_Class = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleClass"},
                {name: "code"},
                {name: "course.titleFa"}
            ],
            fetchDataURL: classUrl + "info-tuple-list"
        });
        let DynamicForm_Select_Class = isc.DynamicForm.create({
            colWidths: ["10%", "90%"],
            width: "100%",
            height: "20%",
            numCols: 2,
            autoFocus: "true",
            cellPadding: 5,
            fields: [
                {
                    name: "class.code",
                    align: "center",
                    title: "کلاس",
                    editorType: "selectItem",
                    multiple: true,
                    defaultValue: null,
                    changeOnKeypress: true,
                    showHintInField: true,
                    displayField: "code",
                    valueField: "code",
                    optionDataSource: RestDataSource_Select_Class,
                    changed: function (form, item) {

                        let listClassCost_Data = [];
                        let records = item.getSelectedRecords();
                        if (records === null || records.length === 0)
                            ListGrid_Class_Teaching_Cost.setData([]);
                        else {
                            for (let i = 0; i < records.length; i++) {
                                let obj = {
                                    classId: records[i].id,
                                    titleClass: records[i].titleClass,
                                    code: records[i].code
                                };
                                listClassCost_Data.add(obj);
                            }
                            ListGrid_Class_Teaching_Cost.setData(listClassCost_Data);
                        }
                    }
                }
            ]
        });

        let IButton_Class_Teaching_Cost_Save = isc.IButtonSave.create({
            title: "<spring:message code='save'/>",
            align: "center",
            click: function () {
                AgreementClassCost_Add(ListGrid_Class_Teaching_Cost.getData(), Window_Select_Class);
            }
        });
        let IButton_Class_Teaching_Cost_Exit = isc.IButtonCancel.create({
            title: "<spring:message code='close'/>",
            align: "center",
            click: function () {
                Window_Select_Class.close();
            }
        });
        let HLayOut_Class_Teaching_Cost_SaveOrExit = isc.HLayout.create({
            layoutMargin: 5,
            showEdges: false,
            edgeImage: "",
            width: "100%",
            height: "10%",
            alignLayout: "center",
            align: "center",
            membersMargin: 10,
            members: [IButton_Class_Teaching_Cost_Save, IButton_Class_Teaching_Cost_Exit]
        });
        let Window_Select_Class = isc.Window.create({
            title: "انتخاب کلاس (ها)",
            autoSize: false,
            width: "40%",
            height: "45%",
            canDragReposition: true,
            canDragResize: true,
            autoDraw: false,
            autoCenter: true,
            isModal: false,
            items: [
                DynamicForm_Select_Class,
                ListGrid_Class_Teaching_Cost,
                HLayOut_Class_Teaching_Cost_SaveOrExit
            ]
        });

        if (agreementMethod === "PUT") {
            let recordId = ListGrid_Agreement.getSelectedRecord().id;
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(agreementClassCostUrl + "/list-by-agreementId/" + recordId, "GET", null, function (resp) {
                if (resp.httpResponseCode === 200) {
                    wait.close();
                    let costList = JSON.parse(resp.httpResponseText);
                    ListGrid_Class_Teaching_Cost.setData(costList);
                    Window_Select_Class.show();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        } else
            Window_Select_Class.show();
    }
    function AgreementClassCost_Add(records, window) {
        let dataObject = {};
        agreementClassCost_Data = [];
        for (let i = 0; i < records.length; i++) {
            if (records[i].teachingCostPerHour === undefined || records[i].teachingCostPerHour === null) {
                createDialog("info", "کلاسی بدون ثبت هزینه تدریس وجود دارد");
                return;
                break;
            }
            dataObject = {
                classId: records[i].classId,
                teachingCostPerHour: records[i].teachingCostPerHour
            };
            agreementClassCost_Data.add(dataObject);
        }
        window.close();
    }
    function checkInstituteValidation(item) {
        let record = item.getSelectedRecord();
        if (record.valid === false) {
            item.setValue(null);
            createDialog("info", "همه اطلاعات موسسه آموزشی انتخابی شامل نام موسسه - شماره ملی - شماره اقتصادی - آدرس - تلفن - فاکس - نام و نام خانوادگی و موبایل مدیر و شبای موسسه باید در فرم مرکز آموزشی تکمیل گردد");
            return;
        }
    }
    function checkTeacherValidation(item) {
        let record = item.getSelectedRecord();
        if (record.valid === false) {
            item.setValue(null);
            createDialog("info", "همه اطلاعات مدرس انتخابی شامل نام - نام خانوادگی - کد ملی  - آدرس - موبایل - شبا باید در فرم استاد تکمیل گردد");
            return;
        }
    }
    function Help_Files_Upload_Changed() {
        if (document.getElementById('file_JspAttachments').files.length !== 0)
            isFileAttached = true;
    }

    // </script>