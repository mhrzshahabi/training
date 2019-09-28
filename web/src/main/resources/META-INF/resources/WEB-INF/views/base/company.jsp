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
        fetchDataURL: stateUrl + "spec-list"
    });


     var RestDataSource_company = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "عنوان ", filterOperator: "contains"},
            {name: "workDomain", title: "حوزه کاری", filterOperator: "contains"},
            {name: "email", title: "ایمیل", filterOperator: "contains"},
               ],
        fetchDataURL: companyUrl + "spec-list",
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
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "workDomain",
                title: "حوزه کاری",
               // textAlign: "center",
                required: true,
                width: "*",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "email",
                title: "ایمیل",
              //  textAlign: "center",
                required: true,
                width: "*",

            }
        ]
    });



        var DynamicForm_AccountInfo_Company = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "co",
        numCols: 6,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},

            {
                name: "accountInfo.bank",
                title: "<spring:message code='bank'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "accountInfo.bankBranch",
                title: "<spring:message code='bank.branch'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "accountInfo.bankBranchCode",
                title: "<spring:message code='bank.branch.code'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },


            {
                name: "accountInfo.accountNumber",
                title: "<spring:message code='account.number'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "accountInfo.cartNumber",
                title: "<spring:message code='cart.number'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "accountInfo.shabaNumber",
                title: "<spring:message code='shaba.number'/>",
                type: 'text',
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
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "co",
        titleAlign: "left",
        numCols: 6,
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "manager.firstNameFa",
                title: "نام",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "manager.lastNameFa",
                title: "نام خانوادگی",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "manager.nationalCode",
                title: "شماره ملی",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
             {
                name: "manager.contactInfo.email",
                title: "ایمیل",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
             {
                name: "manager.contactInfo.mobile",
                title: "موبایل",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
           ]
        });



        var DynamicForm_Address_Company = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "co",
        numCols: 6,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "addressInfoTuple.restAddr",
                title: "آدرس",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                width: "*"
            },
            {
                name: "addressInfoTuple.postCode",
                title: "کد پستی",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                width: "*"
            },
            {
                name: "addressInfoTuple.phone",
                title: "تلفن",
                type: 'text',
                length: "30",
                width: "*"
            },
            {
                name: "addressInfoTuple.fax",
                title: "فکس",
               // type: "textArea",
                width: "*",
                length: "255"
            },
            {
                name: "addressInfoTuple.webSite",
                title: "وب سایت",
                type: 'text',
                width: "*",
                keyPressFilter: "[0-9]",
                length: "11"
            },
          {
                name: "addressInfoTuple.stateId",
                title: "استان",
                textAlign: "center",
                optionDataSource:  RestDataSource_Work_State_Company,
                required: true,
                width: "*",
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "name",
                valueField: "id",
                filterFields: ["name"],
                changed: function (form, item, value) {
                    DynamicForm_Address_Company.getItem("addressInfoTuple.city.name").clearValue();
                    DynamicForm_Address_Company.getItem("addressInfoTuple.city.name").setValue();
                    RestDataSource_Work_City_Company.fetchDataURL = stateUrl + "spec-list-by-stateId/" + value;
                    DynamicForm_Address_Company.getItem("addressInfoTuple.city.name").optionDataSource =  RestDataSource_Work_City_Company;
                    DynamicForm_Address_Company.getItem("addressInfoTuple.city.name").fetchData();
                },
            },
                {
                name: "addressInfoTuple.cityId",
                title: "<spring:message code='city'/>",
                prompt: "ابتدا شهر را انتخاب کنید",
                textAlign: "center",
                destroyed: true,
                required: true,
                width: "*",
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
        height: "10%",
        membersMargin: 10,
        members: [DynamicForm_Company]
    });


     var TabSet_Company_JspCompany = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset:2,
        height: "20%",
        tabs: [
            {
                title: "<spring:message code='account.information'/>", canClose: false,
              pane: DynamicForm_AccountInfo_Company,
            },
            {
                title: "اطلاعات مدیر", canClose: false,
             pane: DynamicForm_ManagerInfo_Company,
            },
            // {
            //     title: "آدرس", canClose: false,
            //   pane: DynamicForm_Address_Company,
            // }
        ]
    });

     var Window_Company = isc.Window.create({
       // placement: "fillScreen",
         width: "50%",
          height: "50%",
       //  height: "500",
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
           height: "340",
            members: [
             HLayOut_Company,
             TabSet_Company_JspCompany,
                isc.MyHLayoutButtons.create({
                members: [isc.MyButton.create({
                    title: "<spring:message code="save"/>",
                    icon: "pieces/16/save.png",
                    click: function () {
                     save_Company();
                    //  if (committee_method == "PUT") {
                    //   // edit_Committee();
                    // } else {
                    //  //   save_Committee();
                    // }


                    }
                }), isc.MyButton.create({
                    title: "<spring:message code="cancel"/>",
                    icon: "<spring:url value="remove.png"/>",
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

        }
    });
    var ToolStripButton_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/>",
        click: function () {
           show_Company_Edit();
        }
    });
    var ToolStripButton_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code="create"/>",
        click: function () {
            company_method = "POST";
              show_CompanyNewForm();
                      }
    });
    var ToolStripButton_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/>",
        click: function () {

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

       function save_Company() {
         //  var companyData=DynamicForm_Company.getValues();


             var data_Company = co.getValues();
             console.log(data_Company);

              isc.RPCManager.sendRequest(MyDsRequest(companyUrl, company_method, JSON.stringify(data_Company), "callback:show_CompanyActionResult(rpcResponse)"));
    };



    function show_CompanyNewForm() {
        company_method = "POST";
        Window_Company.setTitle("ایجاد"),
        DynamicForm_Company.clearValues();
        DynamicForm_AccountInfo_Company.clearValues();

        Window_Company.show();

    };



       function show_Company_Edit() {
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
            //          co.clearValues();
        //   co.clearErrors(true);
           company_method = "PUT";
           co.editRecord(record_company);
           Window_Company.setTitle("<spring:message code="edit"/>");
           Window_Company.show();

        }
    };

     function show_CompanyActionResult(resp) {
        var respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            ListGrid_Term.invalidateCache();
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",
            });
            setTimeout(function () {
                MyOkDialog_term.close();
            }, 3000);
            Window_term.close();
        } else {
            var MyOkDialog_term = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });
            setTimeout(function () {
                MyOkDialog_term.close();
            }, 3000);
        }
    };