<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

// <script>

    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************

    let company_method = "POST";
    let Wait_Company;

    RestDataSource_Work_City_Company = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: cityUrl + "iscList"
    });

    RestDataSource_Work_State_Company = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: stateUrl + "iscList"
    });

    RestDataSource_company = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "workDomain", title: "<spring:message code="workDomain"/>", filterOperator: "iContains"},
            {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains"},
            {name: "companyId", title: "<spring:message code="company.id"/>", filterOperator: "iContains"},
            {name: "economicalId", title: "<spring:message code="company.economical.id"/>", filterOperator: "iContains"},
            {name: "registerId", title: "<spring:message code="company.register.id"/>", filterOperator: "iContains"},
            {name: "manager.id"},
            {name: "manager.contactInfo.id"},
            {name: "accountInfo.id"},
            {name: "address.id"}
        ],
        fetchDataURL: companyUrl + "spec-list"
    });

    //*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************
    co = isc.ValuesManager.create({});

    Menu_ListGrid_Company = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    Refresh_Company();
                }
            },
            {
                title: "<spring:message code="create"/>", icon: "<spring:url value="create.png"/>", click: function () {
                    show_CompanyNewForm();
                }
            },
            {
                title: "<spring:message code="edit"/>", icon: "<spring:url value="edit.png"/>", click: function () {
                    show_Company_EditForm();
                }
            },
            {
                title: "<spring:message code="remove"/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    show_CompanyRemoveForm();
                }
            },
            <%--{isSeparator: true},--%>
            <%--{--%>
            <%--    title: "<spring:message code="print.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {--%>

            <%--    }--%>
            <%--},--%>
            <%--{--%>
            <%--    title: "<spring:message code="print.excel"/>",--%>
            <%--    icon: "<spring:url value="excel.png"/>",--%>
            <%--    click: function () {--%>

            <%--    }--%>
            <%--},--%>
            <%--{--%>
            <%--    title: "<spring:message code="print.html"/>",--%>
            <%--    icon: "<spring:url value="html.png"/>",--%>
            <%--    click: function () {--%>

            <%--    }--%>
            <%--}--%>
        ]
    });

    DynamicForm_Company = isc.DynamicForm.create({
        height: "100%",
        align: "center",
        isGroup: true,
        groupTitle: "اطلاعات شرکت",
        canSubmit: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "co",
        numCols: 4,
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="title"/>",
                required: true,
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "workDomain",
                title: "<spring:message code="workDomain"/>",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "companyId",
                title: "<spring:message code="company.id"/>",
                filterOperator: "iContains",
                length: 12,
                required: false,
                keyPressFilter: "[0-9]"
            },
            {
                name: "economicalId",
                title: "<spring:message code="company.economical.id"/>",
                filterOperator: "iContains",
                length: 12,
                required: false,
                keyPressFilter: "[0-9]"
            },
            {
                name: "registerId",
                title: "<spring:message code="company.register.id"/>",
                filterOperator: "iContains",
                length: 12,
                required: false,
                keyPressFilter: "[0-9]"
            },
            {
                name: "email",
                title: "<spring:message code="email"/>",
                validators: [TrValidators.EmailValidate],
                keyPressFilter: "[a-z|A-Z|0-9|.|@]",
            }
        ]
    });

    DynamicForm_AccountInfo_Company = isc.DynamicForm.create({
        height: "100%",
        align: "center",
        canSubmit: true,
        isGroup: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "co",
        numCols: 6,
        titleAlign: "left",
        margin: 20,
        newPadding: 5,
        fields: [
            {name: "accountInfo.id", hidden: true},
            {
                name: "accountInfo.bank",
                title: "<spring:message code='bank'/>",
                required: false,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "accountInfo.bankBranch",
                title: "<spring:message code='bank.branch'/>",
                required: false,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "accountInfo.bankBranchCode",
                title: "<spring:message code='bank.branch.code'/>",
                required: false,
                keyPressFilter: "[0-9]"
            },
            {
                name: "accountInfo.accountNumber",
                title: "<spring:message code='account.number'/>",
                required: false,
                keyPressFilter: "[0-9]"
            },
            {
                name: "accountInfo.cartNumber",
                title: "<spring:message code='cart.number'/>",
                required: false,
                keyPressFilter: "[0-9]",
                length: "16"
            },
            {
                name: "accountInfo.shabaNumber",
                title: "<spring:message code='shaba.number'/>",
                required: false,
                length: "30"
            },

        ]
    });

    DynamicForm_ManagerInfo_Company = isc.DynamicForm.create({
        height: "100%",
        align: "center",
        canSubmit: true,
        isGroup: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "co",
        numCols: 6,
        titleAlign: "left",
        margin: 20,
        newPadding: 5,
        fields: [
            {name: "manager.id", hidden: true},
            {name: "manager.contactInfo.id", hidden: true},
            {
                name: "manager.nationalCode",
                required: "true",
                                title: "<spring:message code='national.code'/>",
                keyPressFilter: "[0-9]",
                textAlign: "left",
                length: "10",
                validators: [TrValidators.NationalCodeValidate],
                changed: function (form, item, value) {
                    if (value == null || !this.validate())
                        return;
                    isc.RPCManager.sendRequest(TrDSRequest(personalInfoUrl + "getOneByNationalCode/" + value, "GET", null,
                        "callback: personalInfo_findOne_result_company(rpcResponse)"));
                }
            },
            {
                name: "manager.firstNameFa",
                required: "true",
                title: "<spring:message code='firstName'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
            },
            {
                name: "manager.lastNameFa",
                required: "true",
                title: "<spring:message code='lastName'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
            },

            {
                name: "manager.contactInfo.mobile",
                title: "<spring:message code='mobile'/>",
                textAlign: "left",
                length: "11",
                hint: "*********09",
                showHintInField: true,
                keyPressFilter: "[0-9]",
                validateOnExit: true,
                validators: [TrValidators.MobileValidate]

            },
            {
                name: "manager.contactInfo.email",
                title: "<spring:message code='email'/>",
                validateOnExit: true,
                validators: [TrValidators.EmailValidate],
                keyPressFilter: "[a-z|A-Z|0-9|.|@]",
            },
        ]
    });

    DynamicForm_Address_Company = isc.DynamicForm.create({
        height: "100%",
        align: "center",
        canSubmit: true,
        isGroup: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "co",
        numCols: 6,
        titleAlign: "left",
        margin: 20,
        newPadding: 5,
        fields: [
            {name: "address.id", hidden: true},
            {
                name: "address.postalCode",
                title: "<spring:message code='postal.code'/>",
                keyPressFilter: "[0-9]",
                length: "10",
                required: false,
                validators: [TrValidators.PostalCodeValidate],
                changed: function (form, item, value) {
                    if (value === null || !this.validate() || value === undefined)
                        return;
                    fillAddressFields(value);
                }
            },
            {
                name: "address.restAddr",
                title: "<spring:message code='address'/>",
            },
            {
                name: "address.phone",
                title: "<spring:message code='telephone'/>",
                textAlign: "left",
                keyPressFilter: "[0-9]",
                validateOnExit: true,
                validators: [TrValidators.PhoneValidate]
            },
            {
                name: "address.fax",
                title: "<spring:message code='fax'/>",
                keyPressFilter: "[0-9]",
                validateOnExit: true,
                validators: [TrValidators.PhoneValidate]
            },
            {
                name: "address.webSite",
                title: "<spring:message code='website'/>",
                validateOnExit: true,
                validators: [TrValidators.WebsiteValidate],
            },
            {
                name: "address.stateId",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                optionDataSource: RestDataSource_Work_State_Company,
                required: false,
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "name",
                valueField: "id",
                filterFields: ["name"],
                changed: function (form, item, value) {
                    DynamicForm_Address_Company.clearValue("address.cityId");
                    if (value !== null && value !== undefined) {
                        RestDataSource_Work_City_Company.fetchDataURL = stateUrl + "spec-list-by-stateId/" + value;
                        DynamicForm_Address_Company.getItem("address.cityId").fetchData();
                    }
                },
            },
            {
                name: "address.cityId",
                title: "<spring:message code='city'/>",
                prompt: "<spring:message code="msg.city.choose.state.first"/>",
                optionDataSource: RestDataSource_Work_City_Company,
                textAlign: "center",
                destroyed: true,
                required: false,
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "name",
                valueField: "id",
                filterFields: ["name"],
            },
        ],

    });

    //********************************************************************************************************************

    HLayOut_Company = isc.TrHLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        alignLayout: "center",
        align: "center",
        padding: 10,
        height: "20%",
        membersMargin: 10,
        members: [DynamicForm_Company]
    });

    TabSet_Company_JspCompany = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "25%",
        tabs: [
            {
                ID: "MyTab1",
                title: "<spring:message code='account.information'/>", canClose: false,
                pane: DynamicForm_AccountInfo_Company,
            },
            {
                ID: "MyTab2",
                title: "<spring:message code='manager.information'/>", canClose: false,
                pane: DynamicForm_ManagerInfo_Company,
            },

            {
                ID: "MyTab3",
                title: "<spring:message code="address"/>", canClose: false,
                pane: DynamicForm_Address_Company,
            }
        ]
    });

    HLayout_Buttons_Company = isc.TrHLayoutButtons.create({
        members: [
            isc.IButtonSave.create({
                title: "<spring:message code="save"/>",
                click: function () {
                    if (company_method === "PUT") {
                        Edit_Company();
                    } else {
                        Save_Company();
                    }
                }
            }), isc.IButtonCancel.create({
                title: "<spring:message code="cancel"/>",
                click: function () {
                    Window_Company.close();
                }
            })
        ]
    });

    Window_Company = isc.Window.create({
        width: "50%",
        height: "45%",
        minWidth: 900,
        title: "<spring:message code='teacher'/>",
        canDragReposition: true,
        align: "center",
        autoCenter: true,
        border: "1px solid gray",
        items: [isc.TrVLayout.create({
            height: "390",
            members: [
                HLayOut_Company,
                TabSet_Company_JspCompany,
                HLayout_Buttons_Company
            ]
        })]
    });

    ListGrid_Company = isc.TrLG.create({
        dataSource: RestDataSource_company,
        contextMenu: Menu_ListGrid_Company,
        sortField: 1,
        autoFetchData: true,
        fields: [
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "workDomain", title: "<spring:message code="workDomain"/>", filterOperator: "iContains"},
            {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains"},
        ],
        rowDoubleClick: function () {
            show_Company_EditForm();
        },
        selectionChanged: function (record) {
        },
        click: function () {
        },
        dataArrived: function (startRow, endRow) {
        }
    });


    //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************

    ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            Refresh_Company();
        }
    });
    ToolStripButton_Add = isc.ToolStripButtonAdd.create({
        title: "<spring:message code="create"/>",
        click: function () {
            show_CompanyNewForm();
        }
    });
    ToolStripButton_Edit = isc.ToolStripButtonEdit.create({

        title: "<spring:message code="edit"/>",
        click: function () {

            show_Company_EditForm();
        }
    });
    ToolStripButton_Remove = isc.ToolStripButtonRemove.create({

        title: "<spring:message code="remove"/>",
        click: function () {
            show_CompanyRemoveForm();
        }
    });
   var ToolStripButton_Export2EXcel = isc.ToolStripButtonExcel.create({
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Company,  companyUrl + "spec-list", 0, null, '',"لیست شرکت ها", ListGrid_Company.getCriteria(), null);
        }
    });
    // ToolStripButton_Print = isc.TrPrintBtn.create({
    //     click: function () {
    //     }
    //
    // });

    ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add,
            ToolStripButton_Edit,
            ToolStripButton_Remove,
            ToolStripButton_Export2EXcel,
            //ToolStripButton_Print,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh,
                ]
            })
        ]
    });

    //***********************************************************************************
    //HLayout
    //***********************************************************************************
    HLayout_Actions_Group = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions]
    });

    HLayout_Grid_Company = isc.TrHLayout.create({
        members: [ListGrid_Company]
    });

    VLayout_Body_Group = isc.TrVLayout.create({
        members:
            [
                HLayout_Actions_Group,
                HLayout_Grid_Company
            ]
    });

    VLayout_Committee_Body_All = isc.TrVLayout.create({
        members: [VLayout_Body_Group]
    });


    //************************************************************************************
    //function
    //************************************************************************************

    function Refresh_Company() {
        ListGrid_Company.invalidateCache();
        ListGrid_Company.filterByEditor()
    }

    function Save_Company() {
        if (!DynamicForm_Company.validate()) {
            return;
        }
        if (!DynamicForm_AccountInfo_Company.validate()) {
            TabSet_Company_JspCompany.selectTab(0);
            return;
        }
        if (!DynamicForm_ManagerInfo_Company.validate()) {
            TabSet_Company_JspCompany.selectTab(1);
            return;
        }
        if (!DynamicForm_Address_Company.validate()) {
            TabSet_Company_JspCompany.selectTab(2);
            return;
        }
        if (DynamicForm_Company.validate() && DynamicForm_AccountInfo_Company && DynamicForm_ManagerInfo_Company && DynamicForm_Address_Company) {
            let data_Company = co.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(companyUrl, "POST", JSON.stringify(data_Company), "callback:show_CompanyActionResult(rpcResponse)"));
        }
    }

    function Edit_Company() {
        if (!DynamicForm_Company.validate()) {
            return;
        }
        if (!DynamicForm_AccountInfo_Company.validate()) {
            TabSet_Company_JspCompany.selectTab(0);
            return;
        }
        if (!DynamicForm_ManagerInfo_Company.validate()) {
            TabSet_Company_JspCompany.selectTab(1);
            return;
        }
        if (!DynamicForm_Address_Company.validate()) {
            TabSet_Company_JspCompany.selectTab(2);
            return;
        }
        let company_editURL = companyUrl;
        let Record = ListGrid_Company.getSelectedRecord();
        company_editURL += Record.id;
        if (DynamicForm_Company.validate() && DynamicForm_AccountInfo_Company && DynamicForm_ManagerInfo_Company && DynamicForm_Address_Company) {
            let data_Company = co.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(company_editURL, company_method, JSON.stringify(data_Company), "callback:show_CompanyActionResult(rpcResponse)"));
        }
    }

    function show_CompanyNewForm() {
        co.clearValues();
        co.clearErrors(true);
        company_method = "POST";
        Window_Company.setTitle("<spring:message code="company.create"/>");
        DynamicForm_ManagerInfo_Company.getItem("manager.nationalCode").setDisabled(false);
        DynamicForm_Address_Company.getItem("address.postalCode").setDisabled(false);
        Window_Company.show();
    }

    function show_Company_EditForm() {
        let record_company = ListGrid_Company.getSelectedRecord();
        if (record_company == null || record_company.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let record = ListGrid_Company.getSelectedRecord();
            co.clearValues();
            co.clearErrors(true);
            company_method = "PUT";
            if (record.address !== undefined && record.address.stateId !== undefined)
                RestDataSource_Work_City_Company.fetchDataURL = stateUrl + "spec-list-by-stateId/" + record.address.stateId;
            co.editRecord(record);
            DynamicForm_ManagerInfo_Company.getItem("manager.nationalCode").setDisabled(true);
            DynamicForm_Address_Company.getItem("address.postalCode").setDisabled(true);
            Window_Company.setTitle("<spring:message code="company.edit"/>");
            Window_Company.show();
        }
    }

    function show_CompanyRemoveForm() {
        let record = ListGrid_Company.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Remove_Company = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Remove_Company.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        isc.RPCManager.sendRequest(TrDSRequest(companyUrl + record.id, "DELETE", null, "callback: show_CompanyActionResult(rpcResponse)"));
                    }
                }
            });
        }
    }

    function show_CompanyActionResult(resp) {

        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 2000);
            Refresh_Company();
            Window_Company.close();
        } else
        {
            let respText = JSON.parse(resp.httpResponseText);
            createDialog("info",respText.message, "<spring:message code="error"/>");
        }
        <%--    if(resp.httpResponseCode === 409)--%>
        <%--{--%>
        <%--    createDialog("info", "شرکتی با کد پستی وارد شده قبلا ثبت شده است",--%>
        <%--        "<spring:message code="message"/>");--%>
        <%--}--%>
        <%--else if(resp.httpResponseCode === 406)--%>
        <%--{--%>
        <%--    createDialog("info", "اطلاعات مدیر تغییر کرده",--%>
        <%--        "<spring:message code="message"/>");--%>
        <%--}--%>
        <%--else {--%>
        <%--    createDialog("info", "<spring:message code="msg.operation.error"/>",--%>
        <%--        "<spring:message code="message"/>");--%>
        <%--}--%>
    }

    function personalInfo_findOne_result_company(resp) {
        if (resp !== null && resp !== undefined && resp.data !== "") {
            let personal = JSON.parse(resp.data);
            DynamicForm_ManagerInfo_Company.setValue("manager.id", personal.id);
            DynamicForm_ManagerInfo_Company.setValue("manager.firstNameFa", personal.firstNameFa);
            DynamicForm_ManagerInfo_Company.setValue("manager.lastNameFa", personal.lastNameFa);
            if (personal.contactInfo !== null && personal.contactInfo !== undefined) {
                DynamicForm_ManagerInfo_Company.setValue("manager.contactInfo.id", personal.contactInfo.id);
                DynamicForm_ManagerInfo_Company.setValue("manager.contactInfo.mobile", personal.contactInfo.mobile);
                DynamicForm_ManagerInfo_Company.setValue("manager.contactInfo.email", personal.contactInfo.email);
            }
        }
    }

    function fillAddressFields(postalCode) {
        if (postalCode !== undefined)
            isc.RPCManager.sendRequest(TrDSRequest(addressUrl + "getOneByPostalCode/" + postalCode, "GET", null,
                "callback: address_findOne_result(rpcResponse)"));
    }

    function address_findOne_result(resp) {
        if (resp === null || resp === undefined || resp.data === "") {
            return;
        }
        let data = JSON.parse(resp.data);
        DynamicForm_Address_Company.setValue("address.id", data.id);
        DynamicForm_Address_Company.setValue("address.postalCode", data.postalCode);
        DynamicForm_Address_Company.setValue("address.restAddr", data.restAddr);
        DynamicForm_Address_Company.setValue("address.phone", data.phone);
        DynamicForm_Address_Company.setValue("address.fax", data.fax);
        DynamicForm_Address_Company.setValue("address.webSite", data.webSite);
        DynamicForm_Address_Company.setValue("address.stateId", data.stateId);
        DynamicForm_Address_Company.getItem("address.stateId").changed(null, null,data.stateId);
        DynamicForm_Address_Company.setValue("address.cityId", data.cityId);
        // createDialog("info", "اطلاعات این آدرس از قبل وجود دارد");
    }

    // </script>