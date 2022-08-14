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
            {name: "agreementNumber", title: "شماره تفاهم نامه", filterOperator: "iContains"},
            {name: "agreementDate", title: "تاریخ عقد تفاهم نامه", filterOperator: "iContains"},
            {name: "fromDate", title: "<spring:message code='from.date'/>"},
            {name: "toDate", title: "<spring:message code='to.date'/>"},
            {name: "firstPartyId", title: "firstPartyId", hidden: true},
            {name: "firstParty.titleFa", title: "طرف اول تفاهم نامه", filterOperator: "iContains"},
            {name: "secondPartyTeacherId", title: "secondPartyTeacherId", hidden: true},
            {name: "secondPartyTeacher.fullNameFa", title: "طرف دوم تفاهم نامه (مدرس)", filterOperator: "iContains"},
            {name: "secondPartyInstituteId", title: "secondPartyInstituteId", hidden: true},
            {name: "secondPartyInstitute.titleFa", title: "طرف دوم تفاهم نامه (موسسه آموزشی)", filterOperator: "iContains"},
            {name: "finalCost", title: "مبلغ نهایی", hidden: true},
            {name: "currency.title", title: "واحد", filterOperator: "iContains"},
            {name: "subject", title: "موضوع تفاهم نامه", filterOperator: "iContains"},
            {name: "teacherEvaluation", title: "اعمال نمره ارزشیابی مدرس برای پرداخت", valueMap: {"true" : "بله", "false" : "خیر"}},
            {name: "maxPaymentHours", title: "حداکثر ساعت پرداختی", hidden: true}
        ],
        fetchDataURL: agreementUrl + "/spec-list"
    });
    RestDataSource_Institute_Agreement = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "نام موسسه", filterOperator: "iContains"},
            {name: "instituteId", title: "شماره ملی", filterOperator: "iContains"},
            {name: "economicalId", title: "شماره اقتصادی", filterOperator: "iContains"},
            {name: "contactInfo.workAddress.restAddr", title: "آدرس", filterOperator: "iContains"},
            {name: "contactInfo.workAddress.phone", title: "تلفن", filterOperator: "iContains"},
            {name: "contactInfo.workAddress.fax", title: "فاکس", filterOperator: "iContains"},
            {name: "manager.firstNameFa", title: "نام مدیر", filterOperator: "iContains"},
            {name: "manager.lastNameFa", title: "نام خانوادگی مدیر", filterOperator: "iContains"},
            {name: "manager.contactInfo.mobile", title: "موبایل مدیر", filterOperator: "iContains"},
            {name: "accountInfoSet", title: "شبا", filterOperator: "iContains"},
            {name: "valid", hidden: true}
        ],
        fetchDataURL: instituteUrl + "spec-list-agreement"
    });
    RestDataSource_Teacher_Agreement = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "teacherCode", title: "کد مدرس", filterOperator: "iContains"},
            {name: "fullNameFa", title: "مدرس", filterOperator: "iContains"},
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
    RestDataSource_Currency_Agreement = isc.TrDS.create({
        fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>"},
                {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterUrl + "/iscList/currency"
    });
    RestDataSource_Basis_Calculate_Agreement = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterUrl + "/iscList/basisCalculatingCost"
    });
    RestDataSource_Teacher_Name_Agreement = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "fullNameFa", filterOperator: "iContains"},
            {name: "personality.firstNameFa", title: "<spring:message code='firstName'/>", filterOperator: "iContains"},
            {name: "personality.lastNameFa", title: "<spring:message code='lastName'/>", filterOperator: "iContains"},
            {name: "personality.nationalCode", title: "<spring:message code='national.code'/>", filterOperator: "iContains"}
        ],
        fetchDataURL: teacherUrl + "fullName-list"
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
    ToolStripButton_Print_Word_Agreement = isc.IButton.create({
        layoutAlign: "center",
        title: "چاپ فرمت تفاهم نامه برای امضا",
        width: "190",
        margin: 3,
        click: function () {
            Agreement_Print_Word();
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
                ToolStripButton_Print_Word_Agreement,
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
        height: "55%",
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
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        fields: [
            {name: "id", hidden: true},
            {
                name: "agreementNumber",
            },
            {
                name: "agreementDate"
            },
            {
                name: "fromDate",
                hidden: true
            },
            {
                name: "toDate",
                hidden: true
            },
            {
                name: "firstParty.titleFa",
                sortNormalizer: function (record) {
                    return record.firstParty.titleFa;
                }
            },
            {
                name: "secondPartyTeacher.fullNameFa"
            },
            {
                name: "secondPartyInstitute.titleFa"
            },
            {
                name: "finalCost",
                canFilter: false,
                hidden: true
            },
            {
                name: "currency.title",
                canFilter: false,
                sortNormalizer: function (record) {
                    return record.currency.title;
                }
            },
            {
                name: "subject",
                canFilter: false
            },
            {
                name: "teacherEvaluation",
                canFilter: false,
            },
            {
                name: "maxPaymentHours",
                canFilter: false,
                hidden: true
            },
            {
                name: "upload",
                align: "center",
                showTitle: false,
                canFilter: false
            },
            {
                name: "download",
                align: "center",
                showTitle: false,
                canFilter: false
            }
        ],
        recordClick: function () {
            selectionUpdated_Teaching_Cost();
        },
        filterEditorSubmit: function () {
            ListGrid_Agreement.invalidateCache();
        },
        createRecordComponent: function (record, colNum) {

            let fieldName = this.getFieldName(colNum);
            if (fieldName === "upload") {
                return isc.IButton.create({
                    layoutAlign: "center",
                    title: "آپلود فایل امضا شده",
                    width: "145",
                    margin: 3,
                    click: function () {
                        showUploadSignedFileWindow(record.id);
                    }
                });
            } else if (fieldName === "download") {
                return isc.IButton.create({
                    layoutAlign: "center",
                    title: "دانلود فایل امضا شده",
                    width: "145",
                    margin: 3,
                    click: function () {
                        downloadSignedFile(record)
                    }
                });
            } else return null;
        }
    });

    ListGrid_Class_Teaching_Cost = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canEdit: true,
        autoFetchData: true,
        validateByCell: true,
        // validateOnChange: true,
        // showInlineErrors: true,
        // editEvent: "doubleClick",
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
                name: "teacherId",
                title: "استاد",
                editorType: "SelectItem",
                valueField: "id",
                displayField: "fullNameFa",
                optionDataSource: RestDataSource_Teacher_Name_Agreement,
                pickListWidth: "500",
                pickListProperties:
                    {
                        showFilterEditor: true
                    },
                pickListFields: [
                    {name: "personality.firstNameFa"},
                    {name: "personality.lastNameFa"},
                    {name: "personality.nationalCode", title: "کد ملی"}
                ]
            },
            {
                name: "basisCalculateId",
                title: "مبنای محاسبه",
                required: true,
                // validateOnChange: true,
                editorType: "SelectItem",
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_Basis_Calculate_Agreement,
                pickListProperties:
                    {
                        showFilterEditor: true
                    },
                pickListFields: [
                    {name: "title", align: "center"},
                ]
            },
            {
                name: "teachingCostPerHourAuto",
                title: "نرخ محاسباتی",
                required: true,
                // validateOnChange: true,
                canEdit: false
            },
            {
                name: "teachingCostPerHour",
                title: "نرخ توافقی",
                required: true,
                // validateOnChange: true,
            },
            {
                name: "agreementId",
                hidden: true
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
                                ClassTeachingCost_SelectClass();
                            }
                        }),
                        isc.Button.create({
                            name: "calcTeachingCost",
                            title: "محاسبه سیستمی نرخ",
                            colSpan: 2,
                            align: "center",
                            width: 200,
                            type: "button",
                            startRow: true,
                            endRow: false,
                            click: function () {
                                ClassTeachingCost_Calculate();
                            }
                        }),
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
                            let record = ListGrid_Agreement.getSelectedRecord();
                            ClassTeachingCost_Save(record.id);
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
                        ClassTeachingCost_Remove(record);
                    }
                });
                return removeImg;
            } else {
                return null;
            }
        }
    });
    TabSet_Agreement = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {
                name: "classTeachingCostTab",
                title: "هزینه کلاس ها",
                pane: ListGrid_Class_Teaching_Cost
            }
        ]
    });
    HLayout_Tab_Agreement = isc.HLayout.create({
        width: "100%",
        height: "40%",
        members: [
            TabSet_Agreement
        ]
    });

    DynamicForm_Agreement = isc.DynamicForm.create({
        width: "85%",
        height: "90%",
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
                name: "agreementNumber",
                title: "شماره تفاهم نامه",
                required: true,
                titleColSpan: 1,
                colSpan: 1,
                type: "text"
            },
            {
                name: "agreementDate",
                title: "تاریخ عقد تفاهم نامه",
                required: true,
                titleColSpan: 1,
                colSpan: 1,
                ID: "agreementDate_agreement",
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                textAlign: "center",
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('agreementDate_agreement', this, 'ymd', '/');
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
                name: "fromDate",
                title: "<spring:message code='from.date'/>",
                required: true,
                titleColSpan: 1,
                colSpan: 1,
                ID: "fromDate_agreement",
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                textAlign: "center",
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('fromDate_agreement', this, 'ymd', '/');
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
                name: "toDate",
                title: "<spring:message code='to.date'/>",
                required: true,
                titleColSpan: 1,
                colSpan: 1,
                ID: "toDate_agreement",
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                textAlign: "center",
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('toDate_agreement', this, 'ymd', '/');
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
                    showFilterEditor: true
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
                        form.getItem("secondPartyTeacherId").disabled = false;
                        form.getItem("secondPartyTeacherId").setRequired(true);
                        form.getItem("secondPartyInstituteId").disabled = true;
                        form.getItem("secondPartyInstituteId").setRequired(false);
                    } else if (value === "2") {
                        form.getItem("secondPartyTeacherId").disabled = true;
                        form.getItem("secondPartyTeacherId").setRequired(false);
                        form.getItem("secondPartyInstituteId").disabled = false;
                        form.getItem("secondPartyInstituteId").setRequired(true);
                    }
                }
            },
            {
                name: "secondPartyTeacherId",
                title: "طرف دوم تفاهم نامه (مدرس)",
                required: true,
                colSpan: 4,
                disabled: false,
                type: "selectItem",
                autoFetchData: true,
                optionDataSource: RestDataSource_Teacher_Agreement,
                valueField: "id",
                displayField: "fullNameFa",
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "teacherCode", title: "کد مدرس"},
                    {name: "fullNameFa", hidden: true},
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
                disabled: true,
                type: "selectItem",
                autoFetchData: true,
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
                    showFilterEditor: true
                },
                click: function (form, item) {
                    item.fetchData();
                },
                changed: function (form, item) {
                    checkInstituteValidation(item);
                }
            },
            {
                name: "finalCost",
                title: "مبلغ نهایی",
                colSpan: 4,
                type: "float",
                hidden: true
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
                // change: function (form, item, value) {
                //     let finalCost = form.getItem("finalCost").getValue();
                //     if (finalCost != null) {
                //         if (value === rialId) {
                //             let finalCostT = finalCost / 10;
                //             form.getItem("alphabeticFinalCost").show();
                //             form.setValue("alphabeticFinalCost", String(finalCostT).toPersianLetter() + " تومان");
                //         } else
                //             form.getItem("alphabeticFinalCost").hide();
                //     }
                // }
            },
            {
                name: "alphabeticFinalCost",
                title: "مبلغ نهایی به حروف",
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
                }
            },
            {
                name: "maxPaymentHours",
                title: "حداکثر ساعت پرداختی",
                colSpan: 4,
                type: "float",
                hidden: true
            }
        ]
    });
    IButton_Save_Agreement = isc.IButtonSave.create({
        title: "<spring:message code='save'/>",
        align: "center",
        click: function () {

            if (!DynamicForm_Agreement.validate())
                return;

            let data = DynamicForm_Agreement.getValues();

            if (agreementMethod === "POST") {

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(agreementUrl, "POST", JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Agreement.close();
                        Agreement_Refresh();
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                        Window_Agreement.close();
                    }
                }));

            } else if (agreementMethod === "PUT") {

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(agreementUrl + "/" + data.id, "PUT", JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Agreement.close();
                        Agreement_Refresh();
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
        width: "100%",
        height: "10%",
        align: "center",
        membersMargin: 10,
        alignLayout: "center",
        members: [
            IButton_Save_Agreement,
            IButton_Exit_Agreement
        ]
    });
    Window_Agreement = isc.Window.create({
        title: "<spring:message code='agreement'/>",
        width: "60%",
        height: "60%",
        autoSize: false,
        align: "center",
        items: [
            DynamicForm_Agreement,
            HLayOut_SaveOrExit_Agreement
        ]
    });

    VLayout_Body_Agreement = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_Agreement,
            ListGrid_Agreement,
            HLayout_Tab_Agreement
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function Agreement_Add() {

        agreementMethod = "POST";
        DynamicForm_Agreement.clearValues();
        DynamicForm_Agreement.clearErrors();
        DynamicForm_Agreement.getItem("secondPartyTeacherId").disabled = false;
        DynamicForm_Agreement.getItem("secondPartyInstituteId").disabled = true;
        Window_Agreement.setTitle("ایجاد تفاهم نامه/ قرارداد");
        Window_Agreement.show();
    }
    function Agreement_Edit() {

        let record = ListGrid_Agreement.getSelectedRecord();
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
            // DynamicForm_Agreement.getItem("currencyId").change(DynamicForm_Agreement, DynamicForm_Agreement.getItem("currencyId"), record.currencyId);
            Window_Agreement.setTitle("ویرایش تفاهم نامه/ قرارداد");
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
                                Agreement_Refresh();
                            } else {
                                createDialog("info", "<spring:message code='global.grid.record.remove.failed'/>")
                            }
                        }));
                    }
                }
            });
        }
    }
    function Agreement_Print_Word() {

        let record = ListGrid_Agreement.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "تفاهم نامه ای برای چاپ انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            // let finalCostChars = String(record.finalCost).toPersianLetter();
            let finalCostChars = "مبلغ به حروف";
            window.open("/training/agreement/print/" + record.id + "?finalCostChars=" + finalCostChars);
        }
    }
    function Agreement_Refresh() {
        ListGrid_Agreement.clearFilterValues();
        ListGrid_Agreement.invalidateCache();
        ListGrid_Class_Teaching_Cost.setData([]);
    }

    function ClassTeachingCost_SelectClass() {

        let record = ListGrid_Agreement.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "تفاهم نامه ای انتخاب نشده است.",
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
                fetchDataURL: classUrl + "info-tuple-list"
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
                            code: item.code
                        };
                        selectedClasses.add(object);
                    });

                    let addedClasses = ListGrid_Class_Teaching_Cost.getData();
                    let addedClassesId = ListGrid_Class_Teaching_Cost.getData().map(item => item.classId);
                    selectedClasses.forEach(item => {
                        if (addedClassesId.contains(item.classId))
                            selectedClasses.splice(selectedClasses.indexOf(item), 1);
                    });

                    ListGrid_Class_Teaching_Cost.setData(selectedClasses.concat(addedClasses));
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
    function ClassTeachingCost_Calculate() {

        let records = ListGrid_Class_Teaching_Cost.getSelectedRecords();
        if (records.size() === 0) {
            isc.Dialog.create({
                message: "رکوردی برای محاسبه نرخ انتخاب نشده است",
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

            let agreementRecord = ListGrid_Agreement.getSelectedRecord();
            let fromDate = agreementRecord.fromDate;
            if (fromDate === null) {
                createDialog("info", "از تاریخ برای تفاهم نامه مشخص نشده است");
                return;
            }
            let alarm = false;
            if (agreementRecord.secondPartyTeacherId !== undefined) {
                // teacher
                let teacherId = agreementRecord.secondPartyTeacherId;
                records.forEach(item => item.teacherId = teacherId);
            } else {
                // institute
                for (let i = 0; i < records.size(); i++) {
                    if (records[i].teacherId == null) {
                        alarm = true;
                        break;
                    }
                }
            }

            if (alarm) {
                isc.Dialog.create({
                    message: "برای تعدادی از کلاسها استاد انتخاب نشده است بنابراین امکان محاسبه برای آنها وجود ندارد",
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

                let calcTeachingCostList = {
                    fromDate: fromDate,
                    calcTeachingCost: records
                };
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(agreementClassCostUrl + "/calculate-teaching-cost", "POST", JSON.stringify(calcTeachingCostList), function (resp) {
                    wait.close();
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Agreement_Refresh();
                    } else if (resp.httpResponseCode === 404) {
                        createDialog("info", resp.httpResponseText);
                    } else {
                        createDialog("info", "خطایی رخ داده است");
                    }
                }));
            }


        }
    }
    function ClassTeachingCost_Save(agreementId) {

        let isValid = true;
        for (let i = 0; i < ListGrid_Class_Teaching_Cost.getTotalRows(); i++) {
            if (!ListGrid_Class_Teaching_Cost.validateRow(i))
                return;
        }
        let costList = ListGrid_Class_Teaching_Cost.getData();
        costList.forEach(item => {
            if (item.basisCalculateId === undefined)
                isValid = false;
        });

        if (isValid) {
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(agreementClassCostUrl + "/create-or-update/" + agreementId, "POST", JSON.stringify(costList), function (resp) {
                wait.close();
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    selectionUpdated_Teaching_Cost();
                } else {
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        } else {
            createDialog("info", "مبنای محاسبه برای بعضی از رکوردها مشخض نشده است");
        }
    }
    function ClassTeachingCost_Remove(record) {

        if (record.id == null) {
            ListGrid_Class_Teaching_Cost.selectSingleRecord(record);
            ListGrid_Class_Teaching_Cost.removeData(record);
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
                        isc.RPCManager.sendRequest(TrDSRequest(agreementClassCostUrl + "/" + record.id, "DELETE", null, function (resp) {
                            wait.close();
                            if (resp.httpResponseCode === 200) {
                                createDialog("info", "<spring:message code='global.grid.record.remove.success'/>");
                                selectionUpdated_Teaching_Cost();
                            } else {
                                createDialog("info", "<spring:message code='global.grid.record.remove.failed'/>")
                            }
                        }));
                    }
                }
            });
        }
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

    function showUploadSignedFileWindow(recordId) {

        let DynamicForm_Upload_File = isc.DynamicForm.create({
            width: "100%",
            height: 0,
            align: "center",
            canSubmit: true,
            showInlineErrors: true,
            showErrorText: false,
            numCols: 2,
            titleAlign: "left",
            requiredMessage: "<spring:message code='msg.field.is.required'/>",
            margin: 2,
            newPadding: 5,
            fields: [
                {name: "group_id", hidden: true},
                {name: "key", hidden: true},
            ]
        });
        let Button_Upload_File = isc.HTMLFlow.create({
            align: "center",
            contents: "<form class=\"uploadButton\" method=\"POST\" id=\"form_file_JspAgreement\" action=\"\" enctype=\"multipart/form-data\"><label for=\"file_JspAgreement\" class=\"custom-file-upload\"><i class=\"fa fa-cloud-upload\"></i><spring:message code='file.upload'/></label><input id=\"file_JspAgreement\" type=\"file\" name=\"file[]\" name=\"file\" onchange=(function(){Agreement_Upload_Changed()})() /></form>"
        });
        let Label_Upload_File = isc.Label.create({
            height: "100%",
            align: "center",
            contents: "<spring:message code='file.size.hint'/>"
        });
        let Button_Save_Upload_File = isc.IButtonSave.create({
            title: "<spring:message code='save'/>",
            align: "center",
            click: function () {

                if (!isFileAttached) {
                    createDialog("info", "فایلی آپلود نشده است");
                    return;
                }
                if (document.getElementById('file_JspAgreement').files[0].size > this.maxFileSizeUpload) {
                    createDialog("info", "<spring:message code='file.size.hint'/>");
                    return;
                }
                let file = document.getElementById('file_JspAgreement').files[0];
                let formData = new FormData();
                formData.append("file", file);

                let request = new XMLHttpRequest();
                request.open("Post", '${uploadMinioUrl}' + "/" + '${groupId}', true);
                request.setRequestHeader("contentType", "application/json; charset=utf-8");
                request.setRequestHeader("Authorization", "Bearer <%= accessToken %>");
                request.setRequestHeader("user-id", "Bearer <%= accessToken %>");
                request.setRequestHeader("app-id", "Training");
                request.send(formData);
                request.onreadystatechange = function () {

                    if (request.readyState === XMLHttpRequest.DONE) {
                        if (request.status === 200 || request.status === 201) {
                            let key = JSON.parse(request.response).key;
                            let upload = {
                                id: recordId,
                                fileName: file.name,
                                group_id: '${groupId}',
                                key: key
                            };

                            wait.show();
                            isc.RPCManager.sendRequest(TrDSRequest(agreementUrl + "/upload", "PUT", JSON.stringify(upload), function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    wait.close();
                                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                    Window_Upload_File.close();
                                    Agreement_Refresh();
                                } else {
                                    wait.close();
                                    createDialog("info", "خطایی رخ داده است");
                                    Window_Upload_File.close();
                                }
                            }));
                        } else {
                            createDialog("info", "<spring:message code="upload.failed"/>");
                        }
                    }
                };

            }
        });
        let Button_Exit_Upload_File = isc.IButtonCancel.create({
            title: "<spring:message code='cancel'/>",
            align: "center",
            click: function () {
                Window_Upload_File.close();
            }
        });
        let HLayOut_SaveOrExit_Upload_File = isc.HLayout.create({
            layoutMargin: 5,
            showEdges: false,
            edgeImage: "",
            width: "100%",
            height: 50,
            alignLayout: "center",
            align: "center",
            membersMargin: 10,
            members: [Button_Save_Upload_File, Button_Exit_Upload_File]
        });
        let Window_Upload_File = isc.Window.create({
            title: "<spring:message code='help.files'/>",
            width: 500,
            height: 50,
            showModalMask: true,
            align: "center",
            autoDraw: false,
            dismissOnEscape: false,
            border: "1px solid gray",
            items: [isc.VLayout.create({
                width: "100%",
                height: "100%",
                members: [
                    DynamicForm_Upload_File,
                    Button_Upload_File,
                    Label_Upload_File,
                    HLayOut_SaveOrExit_Upload_File
                ]
            })]
        });

        isFileAttached = false;
        DynamicForm_Upload_File.clearValues();
        DynamicForm_Upload_File.clearErrors();
        Button_Upload_File.show();
        Label_Upload_File.show();
        Window_Upload_File.setTitle("آپلود فایل امضا شده");
        Window_Upload_File.show();
    }
    function downloadSignedFile(record) {

        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else if (record.fileName == null || record.key == null || record.group_id == null) {
            createDialog("info", "فایلی آپلود نشده است");
        } else {
            let downloadForm = isc.DynamicForm.create({
                method: "GET",
                action: "minIo/downloadFile-by-key/" + record.group_id + "/" + record.key,
                target: "_Blank",
                canSubmit: true,
                fields: [
                    {name: "token", type: "hidden"}
                ]
            });
            downloadForm.setValue("token", "<%=accessToken%>");
            downloadForm.show();
            downloadForm.submitForm();
        }
    }
    function Agreement_Upload_Changed() {
        if (document.getElementById('file_JspAgreement').files.length !== 0)
            isFileAttached = true;
    }
    function selectionUpdated_Teaching_Cost() {

        let agreement = ListGrid_Agreement.getSelectedRecord();
        let tab = TabSet_Agreement.getSelectedTab();

        if (agreement == null && tab.pane != null) {
            tab.pane.setData([]);
            return;
        }

        switch (tab.name) {
            case "classTeachingCostTab": {
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(agreementClassCostUrl + "/list-by-agreementId/" + agreement.id, "GET", null, function (resp) {
                    wait.close();
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        let classCostList = JSON.parse(resp.httpResponseText);
                        ListGrid_Class_Teaching_Cost.setData(classCostList);
                    } else {
                        createDialog("info", "خطایی رخ داده است");
                    }
                }));
                break;
            }
        }
    }

    // </script>