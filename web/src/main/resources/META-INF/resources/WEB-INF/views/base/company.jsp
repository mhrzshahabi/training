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
        fetchDataURL: cityUrl + "spec-list?_startRow=0&_endRow=55"
    });

    RestDataSource_Work_State_Company = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=55"
    });

    RestDataSource_company = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "workDomain", title: "<spring:message code="workDomain"/>", filterOperator: "iContains"},
            {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains"},
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
            {name: "id", hidden: true},
            {
                name: "accountInfo.bank",
                title: "<spring:message code='bank'/>",
                // required: "true",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "accountInfo.bankBranch",
                title: "<spring:message code='bank.branch'/>",
                // required: "true",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "accountInfo.bankBranchCode",
                title: "<spring:message code='bank.branch.code'/>",
                // required: "true",
                keyPressFilter: "[0-9]"
            },
            {
                name: "accountInfo.accountNumber",
                title: "<spring:message code='account.number'/>",
                // required: "true",
                keyPressFilter: "[0-9]"
            },
            {
                name: "accountInfo.cartNumber",
                title: "<spring:message code='cart.number'/>",
                // required: "true",
                keyPressFilter: "[0-9]",
                length: "16"
            },
            {
                name: "accountInfo.shabaNumber",
                title: "<spring:message code='shaba.number'/>",
                // required: "true",
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
            {
                name: "manager.nationalCode",
                // required: "true",
                title: "<spring:message code='national.code'/>",
                keyPressFilter: "[0-9]",
                textAlign: "left",
                length: "10",
                changed: function (form, item, value) {
                    let codeCheck = checkNationalCode(value);
                    nationalCodeCheck = codeCheck;
                    if (codeCheck === false)
                        DynamicForm_ManagerInfo_Company.addFieldErrors("manager.nationalCode", "<spring:message
                                                                        code='msg.national.code.validation'/>", true);
                    if (codeCheck === true) {
                        DynamicForm_ManagerInfo_Company.clearFieldErrors("manager.nationalCode", true);
                        isc.RPCManager.sendRequest(TrDSRequest(personalInfoUrl + "getOneByNationalCode/" + value, "GET", null,
                            "callback: personalInfo_findOne_result_company(rpcResponse)"));
                    }
                }
            },
            {
                name: "manager.firstNameFa",
                // required: "true",
                title: "<spring:message code='firstName'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
            },
            {
                name: "manager.lastNameFa",
                // required: "true",
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
                // validators: [TrValidators.MobileValidate]

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
            {name: "id", hidden: true},
            {
                name: "address.restAddr",
                title: "<spring:message code='address'/>",
            },
            {
                name: "address.postalCode",
                title: "<spring:message code='postal.code'/>",
                keyPressFilter: "[0-9]",
                length: "10",
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
                // required: true,
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "name",
                valueField: "id",
                filterFields: ["name"],
                changed: function (form, item, value) {
                    if(value === null || value === undefined){

                    }
                    else {
                        DynamicForm_Address_Company.getItem("address.cityId").setValue([]);
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
                // required: true,
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
            isc.TrSaveBtn.create({
                click: function () {
                    if (company_method === "PUT") {
                        Edit_Company();
                    } else {
                        Save_Company();
                    }
                }
            }), isc.TrCancelBtn.create({
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
        doubleClick: function () {
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

    ToolStripButton_Refresh = isc.TrRefreshBtn.create({
        click: function () {
            Refresh_Company();
        }
    });
    ToolStripButton_Add = isc.TrCreateBtn.create({
        click: function () {
            show_CompanyNewForm();
        }
    });
    ToolStripButton_Edit = isc.TrEditBtn.create({
        click: function () {

            show_Company_EditForm();
        }
    });
    ToolStripButton_Remove = isc.TrRemoveBtn.create({
        click: function () {
            show_CompanyRemoveForm();
        }
    });
    // ToolStripButton_Print = isc.TrPrintBtn.create({
    //     click: function () {
    //     }
    //
    // });

    ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members:
            [
                ToolStripButton_Refresh,
                ToolStripButton_Add,
                ToolStripButton_Edit,
                ToolStripButton_Remove,
                // ToolStripButton_Print
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
            console.log(record.address);
            if (record.address !== undefined && record.address.stateId !== undefined)
                RestDataSource_Work_City_Company.fetchDataURL = stateUrl + "spec-list-by-stateId/" + record.address.stateId;
            co.editRecord(record);
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
                        Wait_Company = createDialog("wait");
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
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>",
                "<spring:message code="message"/>");
        }
    }

    function personalInfo_findOne_result_company(resp) {
        if (resp !== null && resp !== undefined && resp.data !== "") {
            let personal = JSON.parse(resp.data);
            DynamicForm_ManagerInfo_Company.setValue("manager.id", personal.id);
            DynamicForm_ManagerInfo_Company.setValue("manager.firstNameFa", personal.firstNameFa);
            DynamicForm_ManagerInfo_Company.setValue("manager.lastNameFa", personal.lastNameFa);
            if (personal.contactInfo !== null && personal.contactInfo !== undefined) {
                DynamicForm_ManagerInfo_Company.setValue("manager.contactInfo.mobile", personal.contactInfo.mobile);
                DynamicForm_ManagerInfo_Company.setValue("manager.contactInfo.email", personal.contactInfo.email);
            }
        }
    }

    // </script>