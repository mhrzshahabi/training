<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

var company_method = "POST";
var companyId;

//************************************************************************************
// RestDataSource & ListGrid
//************************************************************************************
//<script>

    var RestDataSource_Work_City_Company = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ]
    });


    var RestDataSource_Work_State_Company = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=55"
    });


    var RestDataSource_company = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "عنوان ", filterOperator: "contains"},
            {name: "workDomain", title: "حوزه کاری", filterOperator: "contains"},
            {name: "email", title: "ایمیل", filterOperator: "contains"},
        ],
          fetchDataURL: companyUrl + "spec-list"
    });


    Menu_ListGrid_Company = isc.Menu.create({
        data: [
            {
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {

                }
            }, {
                title: "ایجاد", icon: "<spring:url value="create.png"/>", click: function () {

                }
            }, {
                title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {

                }
            }, {
                title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {

                }
            }, {isSeparator: true}, {
                title: "ارسال به Pdf", icon: "<spring:url value="pdf.png"/>", click: function () {

                }
            }, {
                title: "ارسال به Excel", icon: "<spring:url value="excel.png"/>", click: function () {

                }
            }, {
                title: "ارسال به Html", icon: "<spring:url value="html.png"/>", click: function () {

                }
            }
        ]
    });

    //*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************
    var co = isc.ValuesManager.create({});
    var DynamicForm_Company = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        isGroup:true,
        groupTitle:"اطلاعات شرکت",
        canSubmit: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "co",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="title"/>",
                required: true,
                length: "250",
                width: "*",
                required: "true",
                requiredMessage: "لطفا نام شرکت را وارد کنید",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "workDomain",
                title: "حوزه کاری",
                required: true,
                requiredMessage: "لطفا حوزه فعالیت شرکت را وارد کنید",
                width: "*",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "email",
                title: "ایمیل",
                width: "*",


            }
        ]
    });


    var DynamicForm_AccountInfo_Company = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        isGroup:true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "co",
        numCols: 6,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 20,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},

            {
                name: "accountInfo.bank",
                title: "<spring:message code='bank'/>",
                type: 'text',
                required: "true",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "accountInfo.bankBranch",
                title: "<spring:message code='bank.branch'/>",
                type: 'text',
                required: "true",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "accountInfo.bankBranchCode",
                title: "<spring:message code='bank.branch.code'/>",
                type: 'text',
                required: "true",
                keyPressFilter: "[0-9]",
                length: "30"
            },


            {
                name: "accountInfo.accountNumber",
                title: "<spring:message code='account.number'/>",
                type: 'text',
                required: "true",
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "accountInfo.cartNumber",
                title: "<spring:message code='cart.number'/>",
                type: 'text',
                required: "true",
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "accountInfo.shabaNumber",
                title: "<spring:message code='shaba.number'/>",
                type: 'text',
                required: "true",
                keyPressFilter: "[0-9]",
                length: "30"
            },

        ]
    });


    var DynamicForm_ManagerInfo_Company = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        isGroup:true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "co",
        numCols: 6,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 20,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "manager.firstNameFa",
                required: "true",
                title: "نام",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "manager.lastNameFa",
                required: "true",
                title: "نام خانوادگی",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "manager.nationalCode",
                required: "true",
                title: "شماره ملی",
                type: 'text',
                keyPressFilter: "[0-9]",
                textAlign: "left",
                length: "10"
            },
             {
                name: "manager.contactInfo.mobile",
                title: "موبایل",
                type: 'text',
                textAlign: "left",
                length: "11",
                hint: "*********09",
              width:272,
                showHintInField: true,
                keyPressFilter: "[0-9]",
                icons: [{
                    name: "tel",
                    src: "blank", // if inline icons are not supported by the browser, revert to a blank icon
                    inline: true,
                    text: "&#x2706;",
                    baseStyle: "telIcon"
                }]
            },
            {
                name: "manager.contactInfo.email",
                title: "ایمیل",
                type: 'text',
                width:"250",
                validators: [TrValidators.EmailValidate],
                keyPressFilter: "[a-z|A-Z|0-9|.|@]",
                blur: function () {
                    var emailCheck;
                    emailCheck = ValidateEmail(DynamicForm_ManagerInfo_Company.getValue("manager.contactInfo.email"));
                    if (emailCheck == false) {
                        DynamicForm_ManagerInfo_Company.addFieldErrors("manager.contactInfo.email", "<spring:message code='msg.company.checked.email'/>", true);
                    } else {
                        DynamicForm_ManagerInfo_Company.clearFieldErrors("manager.contactInfo.email", true);
                    }

                }
            },

        ]
    });


    var DynamicForm_Address_Company = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        isGroup:true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "co",
        numCols: 6,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 20,
        newPadding: 5,


        fields: [
            {name: "id", hidden: true},
            {
                name: "address.restAddr",
                title: "آدرس",
                type: 'text',
                // keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F\]",
                length: "30",
               // width: "*"
            },
            {
                name: "address.postCode",
                title: "کد پستی",
                type: 'text',
                keyPressFilter: "[1-9]",
                length: "30",
               // width: "*"
            },
            {
                name: "address.phone",
                title: "تلفن",
                type: 'text',
                length: "30",
                textAlign:"left",
                keyPressFilter: "[0-9]",
                usePlaceholderForHint:true,
               // width: "*"
            },
            {
                name: "address.fax",
                title: "فکس",
                type: "text",
                keyPressFilter: "[0-9]",
              //  width: "*",
                length: "255"
            },
            {
                name: "address.webSite",
                title: "وب سایت",
                type: 'text',
                 keyPressFilter: "[a-z|A-Z]",
              //  width: "*",
                // keyPressFilter: "[0-9]",
                length: "11"
            },
            {
                name: "address.stateId",
                title: "استان",
                textAlign: "center",
                optionDataSource: RestDataSource_Work_State_Company,
                required: true,
             //   width: "*",
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "name",
                valueField: "id",
                filterFields: ["name"],
                changed: function (form, item, value) {
                    DynamicForm_Address_Company.getItem("address.cityId").clearValue();
                    DynamicForm_Address_Company.getItem("address.cityId").setValue();
                    RestDataSource_Work_City_Company.fetchDataURL = stateUrl + "spec-list-by-stateId/" + value;
                    DynamicForm_Address_Company.getItem("address.cityId").optionDataSource = RestDataSource_Work_City_Company;
                    DynamicForm_Address_Company.getItem("address.cityId").fetchData();
                },
            },
            {
                name: "address.cityId",
                title: "<spring:message code='city'/>",
                prompt: "ابتدا شهر را انتخاب کنید",
                textAlign: "center",
                destroyed: true,
                required: true,
             //   width: "*",
                displayField: "name",
                valueField: "id",
                filterFields: ["name"],
            },
        ],

});


    //********************************************************************************************************************

    var HLayOut_Company = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        alignLayout: "center",
        align: "center",
        padding: 10,
        height: "20%",
        membersMargin:10,
          members: [DynamicForm_Company]
    });


    var TabSet_Company_JspCompany = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "25%",
        tabs: [
            {
                title: "<spring:message code='account.information'/>", canClose: false,
                pane: DynamicForm_AccountInfo_Company,
            },
            {
                title: "اطلاعات مدیر", canClose: false,
                pane: DynamicForm_ManagerInfo_Company,
            },

            {
            title: "آدرس", canClose: false,
            pane: DynamicForm_Address_Company,
            }
        ]
    });

    var Window_Company = isc.Window.create({
// placement: "fillScreen",
        width: "60%",
        height: "65%",
// height: "500",
        title: "<spring:message code='teacher'/>",
        canDragReposition: true,
        canDragResize: true,
        autoSize: true,
        align: "center",
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        autoDraw: false,
        dismissOnEscape: true,
        border: "1px solid gray",
        items: [isc.VLayout.create({
            width: "100%",
            height: "390",
            members: [
                HLayOut_Company,
                TabSet_Company_JspCompany,
                isc.MyHLayoutButtons.create({
                    members: [isc.MyButton.create({
                        title: "<spring:message code="save"/>",
                       // icon: "pieces/16/save.png",
                        click: function () {
                            if (company_method == "PUT") {
                                Edit_Company();
                            } else {

                                Save_Company();
                            }


                        }
                    }), isc.MyButton.create({
                        title: "<spring:message code="cancel"/>",
                       // icon: "<spring:url value="remove.png"/>",
                        click: function () {
                            Window_Company.close();
                        }
                    })],
                })
            ]
        })]
    });


    var ListGrid_Company = isc.MyListGrid.create({
        dataSource: RestDataSource_company,
        contextMenu: Menu_ListGrid_Company,
        autoFetchData: true,
        doubleClick: function () {

        },

        selectionChanged: function (record, state) {
            companyId = record;
      },
        click: function () {
        },
        dataArrived: function (startRow, endRow) {
        },
        sortField: 1,
    });


    //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************
    var ToolStripButton_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Company.invalidateCache();
        }
    });
    var ToolStripButton_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/>",
        click: function () {

            show_Company_EditForm();
        }
    });
    var ToolStripButton_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code="create"/>",
        click: function () {
            show_CompanyNewForm();
        }
    });
    var ToolStripButton_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/>",
        click: function () {
            show_CompanyRemoveForm();
        }
    });
    var ToolStripButton_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code="print"/>",
        click: function () {

        }

    });


    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print]
    });

    //***********************************************************************************
    //HLayout
    //***********************************************************************************
    var HLayout_Actions_Group = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions]
    });

    var HLayout_Grid_Company = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Company]
    });

    var VLayout_Body_Group = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_Group
            , HLayout_Grid_Company
        ]
    });


    var VLayout_Committee_Body_All = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [VLayout_Body_Group]
    });


    //************************************************************************************
    //function
    //************************************************************************************

    function Save_Company() {

        co.validate();
        if (co.hasErrors()) {

            return;
        }

        {
        var data_Company = co.getValues();
        isc.RPCManager.sendRequest(MyDsRequest(companyUrl, "POST", JSON.stringify(data_Company), "callback:show_CompanyActionResult(rpcResponse)"));
        }
    };

    function Edit_Company() {

//
// if (!co.validate()) {
// return;
// }
//
        var company_editURL = companyUrl;
        var Record = ListGrid_Company.getSelectedRecord();
        company_editURL += Record.id;
        var data_Company = co.getValues();
        isc.RPCManager.sendRequest(MyDsRequest(company_editURL, company_method, JSON.stringify(data_Company), "callback:show_CompanyActionResult(rpcResponse)"));

    }


    function show_CompanyNewForm() {
        company_method = "POST";
        Window_Company.setTitle("ایجاد"),
        DynamicForm_Company.clearValues();
        DynamicForm_AccountInfo_Company.clearValues();
        DynamicForm_Address_Company.clearValues();
        DynamicForm_ManagerInfo_Company.clearValues();

        Window_Company.show();
    };

    function show_Company_EditForm() {
        var record_company = ListGrid_Company.getSelectedRecord();
        if (record_company == null || record_company.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.not.selected.record"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var record = ListGrid_Company.getSelectedRecord();
            co.clearValues();
            co.clearErrors(true);
            company_method = "PUT";
            RestDataSource_Work_City_Company.fetchDataURL = stateUrl + "spec-list-by-stateId/" + record.address.stateId;
            DynamicForm_Address_Company.getItem("address.cityId").optionDataSource = RestDataSource_Work_City_Company;
            DynamicForm_Address_Company.getItem("address.cityId").fetchData();
             co.editRecord(record);
            Window_Company.setTitle("<spring:message code="edit"/>");
            Window_Company.show();
        }
    };

    function show_CompanyRemoveForm() {
        var record = ListGrid_Company.getSelectedRecord();
        if (record == null || record.id == null) {

            isc.Dialog.create({
                message: "<spring:message code="msg.not.selected.record"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            isc.MyYesNoDialog.create({
                message: "آیا رکورد انتخاب شده حذف گردد؟",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(MyDsRequest(companyUrl + record.id, "DELETE", null, "callback: show_CompanyActionResult(rpcResponse)"));
                    }
                }
            });
        }

    };

    function show_CompanyActionResult(resp) {
        var respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            ListGrid_Company.invalidateCache();
            var MyOkDialog_company = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",
            });
            setTimeout(function () {
                MyOkDialog_company.close();
            }, 3000);
            Window_Company.close();
        } else {
            var MyOkDialog_company = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });
            setTimeout(function () {
                MyOkDialog_company.close();
            }, 3000);
        }
    };

    function checkEmail_Company(email) {
        if (email.indexOf("@") == -1 || email.indexOf(".") == -1 || email.lastIndexOf(".") < email.indexOf("@"))
            return false;
        else
            return true;
    };

    function ValidateEmail(inputText) {
        var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        if (re.test(inputText.toLowerCase()))
            return true;
        else
            return false;

    };