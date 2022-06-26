<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------


    //----------------------------------------------------Rest DataSource-----------------------------------------------

    let editOrSave="save"
    RestDataSource_Committee = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "complex", title: "گستردگي کميته", filterOperator: "iContains"},
            {name: "title", title: "نام", filterOperator: "iContains"},
            {name: "address", title: "آدرس", filterOperator: "iContains"},
            {name: "phone", title: "تلفن", filterOperator: "iContains"},
            {name: "fax", title: "فاکس", filterOperator: "iContains"},
            {name: "email", title: "ایمیل", filterOperator: "iContains"},
            {name: "createdBy", title: "ایجاد کننده", filterOperator: "iContains"},
            {name: "createdDate", title: "تاریخ ایجاد", filterOperator: "iContains"},
            {name: "lastModifiedBy", title: "ویرایش کننده", filterOperator: "iContains"},
            {name: "lastModifiedDate", title: "تاریخ ویرایش", filterOperator: "iContains"},
        ],
        fetchDataURL: committeeRequestUrl + "/spec-list"
    });

    let RestDataSource_committee_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });


    RestDataSource_Perssons = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "type"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "phone"},
            {name: "postTitle"},
            {name: "role"},

        ],


    });

    //----------------------------------------------------Request Window------------------------------------------------

    DynamicForm_Committee_Ex = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "complex",
                title: "گستردگي کميته",
                required: true,
                optionDataSource: RestDataSource_committee_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "title",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
            },
            {
                name: "title",
                title: "عنوان",
                length: 200,
                required: true},
            {
                name: "address",
                title: "آدرس",
                length: 150
            },
            {
                name: "phone",
                title: "تلفن",
                keyPressFilter: "[0-9/]",
                length: 20
            },
            {
                name: "fax",
                title: "فاکس",
                keyPressFilter: "[0-9/]",
                length: 30
            },
            {
                name: "email",
                title: "ایمیل",
                length: 150,
                validators: [TrValidators.EmailValidate],
                keyPressFilter: "[a-z|A-Z|0-9|.|@]",
            },

        ]
    });
    DynamicForm_Decision_base = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "itemFromDate",
                ID: "date_itemFromDate_base",
                title: "تاریخ شروع",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemFromDate_base', this, 'ymd', '/');
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
                name: "itemToDate",
                ID: "date_itemToDate_base",
                title: "تاریخ پایان ",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemToDate_base', this, 'ymd', '/');
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
                name: "baseTuitionFee",
                title: "پايه",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "professorTuitionFee",
                title: "استاد",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "knowledgeAssistantTuitionFee",
                title: "دانشيار",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "teacherAssistantTuitionFee",
                title: "استاديار",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "instructorTuitionFee",
                title: "مربي",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "educationalAssistantTuitionFee",
                title: "مربي آموزشيار",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true}
        ]
    });



    Save_Button_Add_Committee_Ex = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            saveCommitteeOfExperts();
        }
    });
    edit_Button_Add_Committee_Ex = isc.ToolStripButtonEdit.create({

        title: "ویرایش",
        click: function () {
            editCommitteeOfExperts();
        }
    });

    Cancel_Button_Add_Committee_Ex = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_Committee_Experts.close();
        }
    });



    //------------------------------------------------------List Grids--------------------------------------------------

    ListGrid_Committee_EX = isc.ListGrid.create({
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        // canAutoFitFields: true,
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Committee,
        autoFetchData: true,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        recordClick: function () {
            committeeSelectionUpdated_Tabs();
        },
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },
            {
                name: "complex",
                title: "گستردگي کميته",
                width: "10%",
                align: "center"
            },
            {
                name: "title",
                title: "عنوان",
                width: "10%",
                align: "center",
            },
            {
                name: "address",
                title: "آدرس",
                width: "10%",
                align: "center",
            },
            {
                name: "phone",
                title: "تلفن",
                width: "10%",
                align: "center",
            },
            {
                name: "fax",
                title: "فاکس",
                width: "10%",
                align: "center",
            },
            {
                name: "email",
                title: "ایمیل",
                width: "10%",
                align: "center",
            } ,
            {name: "createdBy",
                title: "ایجاد کننده",
                width: "10%",
                align: "center",

            },
            {name: "createdDate",
                title: "تاریخ ایجاد",
                width: "10%",
                align: "center",
                formatCellValue: function (value) {
                    if (value) {
                        let d = new Date(value);
                        return d.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }

            },
            {name: "lastModifiedBy",
                title: "ویرایش کننده",
                width: "10%",
                align: "center",
            },
            {name: "lastModifiedDate",
                title: "تاریخ ویرایش",
                width: "10%",
                align: "center",
                formatCellValue: function (value) {
                    if (value) {
                        let d = new Date(value);
                        return d.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }
            }
        ],

    });

    base_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    addChildDecision(DynamicForm_Decision_base,Window_base_Decision)
                }.bind(this)
            }),
            isc.ToolStripButtonRemove.create({
                title: "حذف",
                click: function () {
                    deleteChildDecision(ListGrid_Basic_Tuition)
                }.bind(this)
            })
        ]
    });

    ListGrid_Committee_Persons = isc.ListGrid.create({
        dataSource: RestDataSource_Perssons,
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        autoFetchData: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },

            {
                name: "firstName",
                title: "نام",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "lastName",
                title: "نام خانوادگی",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "nationalCode",
                title: "کد ملی",
                width: "10%",
                canFilter: false,
                align: "center"
            },
            {
                name: "personnelNo",
                title: "شماره پرسنلی",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "personnelNo2",
                title: "پرسنلی 6 رقمی",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "phone",
                title: "تلفن",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "postTitle",
                title: "عنوان پست",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "role",
                title: "نقش در کمیته",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "type",
                title: "نوع پرسنل ",
                width: "10%",
                align: "center",
                canFilter: false
            }
        ],
        gridComponents: [base_actions, "filterEditor", "header", "body", "summaryRow"]

    });

    //----------------------------------------------------Actions --------------------------------------------------

    ToolStripButton_Add_Committee = isc.ToolStripButtonCreate.create({
        title: "افزودن کمیته خبرگان",
        click: function () {
            addCommittee();
        }
    });

    ToolStripButton_Delete_Committee = isc.ToolStripButtonRemove.create({
        click: function () {
            deleteCommittee();
        }
    });

    ToolStripButton_Refresh_Committee = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Committee_EX.invalidateCache();
        }
    });



    //////////////////// tab ////////////////////////////////////////////


    Committee_Tabs = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {name: "TabPane_Committee_Persons", title: "اعضاي کميته", pane: ListGrid_Committee_Persons},
        ],
        tabSelected: function () {
            committeeSelectionUpdated_Tabs();
        }
    });



    //----------------------------------- layOut -----------------------------------------------------------------------

    HLayout_IButtons_Committee_Ex = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Save_Button_Add_Committee_Ex,
            Cancel_Button_Add_Committee_Ex
        ]
    });
    HLayout_IButtons_Decision_base = isc.HLayout.create({
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
                    saveChildDecision(ListGrid_Basic_Tuition,DynamicForm_Decision_base,Window_base_Decision,"base")
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    Window_base_Decision.close();
                }
            })
        ]
    });
    Window_Committee_Experts = isc.Window.create({
        title: "افزودن کمیته خبرگان",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Committee_Ex,
            HLayout_IButtons_Committee_Ex
        ]
    });

    Window_base_Decision = isc.Window.create({
        title: "افزودن مبلغ پایه حق التدریس",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Decision_base,
            HLayout_IButtons_Decision_base
        ]
    });

    ToolStrip_Actions_Committee = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Committee,
            ToolStripButton_Delete_Committee,
            edit_Button_Add_Committee_Ex,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Committee
                ]
            })
        ]
    });

    VLayout_Body_Committee = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_Committee,
            ListGrid_Committee_EX
        ]
    });

    HLayout_Tabs_Committee = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "80%",
        members: [Committee_Tabs]
    });

    VLayout_Body_Committee_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_Committee,
            HLayout_Tabs_Committee
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    function addCommittee() {
        editOrSave="save"
        DynamicForm_Committee_Ex.clearValues();
        DynamicForm_Committee_Ex.clearErrors();
        Window_Committee_Experts.show();
    }

    function editCommitteeOfExperts() {
        let record = ListGrid_Committee_EX.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            editOrSave="edit"
            DynamicForm_Committee_Ex.clearValues();
            DynamicForm_Committee_Ex.clearErrors();
            Window_Committee_Experts.show();
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl+"/get/"+record.id, "Get", null, function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    let currentCommittee = JSON.parse(resp.data);

                    DynamicForm_Committee_Ex.getItem("complex").setValue(currentCommittee.complex);
                    DynamicForm_Committee_Ex.getItem("title").setValue(currentCommittee.title);
                    DynamicForm_Committee_Ex.getItem("address").setValue(currentCommittee.address);
                    DynamicForm_Committee_Ex.getItem("phone").setValue(currentCommittee.phone);
                    DynamicForm_Committee_Ex.getItem("fax").setValue(currentCommittee.fax);
                    DynamicForm_Committee_Ex.getItem("email").setValue(currentCommittee.email);

                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));
        }


    }



    function saveCommitteeOfExperts() {

        if (!DynamicForm_Committee_Ex.validate())
            return;

        let data = DynamicForm_Committee_Ex.getValues();

            wait.show();
            if (editOrSave === "save"){
                isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl, "POST", JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Committee_Experts.close();
                        ListGrid_Committee_EX.invalidateCache();
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                    }
                }));

            }else if (editOrSave === "edit"){
                let record = ListGrid_Committee_EX.getSelectedRecord();
                data.id=record.id
                isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl, "PUT", JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        wait.close();
                        createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        Window_Committee_Experts.close();
                        ListGrid_Committee_EX.invalidateCache();
                    } else {
                        wait.close();
                        createDialog("info", "خطایی رخ داده است");
                    }
                }));

            }


    }

    <%--function addChildDecision(dynamicForm,window) {--%>
    <%--    dynamicForm.clearValues();--%>
    <%--    dynamicForm.clearErrors();--%>
    <%--    window.show();--%>
    <%--}--%>
    <%--function saveChildDecision(listGrid,dynamicForm,window,ref) {--%>
    <%--    let record = ListGrid_Decision_Header.getSelectedRecord();--%>
    <%--    if (record == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    if (!dynamicForm.validate())--%>
    <%--        return;--%>
    <%--    if(dynamicForm.getValue("itemToDate") < dynamicForm.getValue("itemFromDate")) {--%>
    <%--        createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    let data = dynamicForm.getValues();--%>
    <%--    data.ref =ref--%>
    <%--    data.educationalDecisionHeaderId =record.id--%>
    <%--    wait.show();--%>
    <%--    isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionRequestUrl, "POST", JSON.stringify(data), function (resp) {--%>
    <%--        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--            wait.close();--%>
    <%--            createDialog("info", "<spring:message code="global.form.request.successful"/>");--%>
    <%--            window.close();--%>
    <%--            listGrid.invalidateCache();--%>
    <%--        } else {--%>
    <%--            wait.close();--%>
    <%--            createDialog("info", "خطایی رخ داده است");--%>
    <%--        }--%>
    <%--    }));--%>


    <%--}--%>
    <%--function deleteChildDecision(listGrid) {--%>
    <%--    let record = listGrid.getSelectedRecord();--%>
    <%--    if (record == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--    } else {--%>
    <%--        let Dialog_dec_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",--%>
    <%--            "<spring:message code="verify.delete"/>");--%>
    <%--        Dialog_dec_remove.addProperties({--%>
    <%--            buttonClick: function (button, index) {--%>
    <%--                this.close();--%>
    <%--                if (index === 0) {--%>
    <%--                    wait.show();--%>
    <%--                    isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionRequestUrl + "/" + record.id, "DELETE", null, function (resp) {--%>
    <%--                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--                            wait.close();--%>
    <%--                            createDialog("info", "<spring:message code="global.form.request.successful"/>");--%>
    <%--                            listGrid.invalidateCache();--%>

    <%--                        } else {--%>
    <%--                            wait.close();--%>
    <%--                            createDialog("info", "خطایی رخ داده است");--%>
    <%--                        }--%>
    <%--                    }));--%>
    <%--                }--%>
    <%--            }--%>
    <%--        });--%>
    <%--    }--%>
    <%--}--%>

    function deleteCommittee() {
        let record = ListGrid_Committee_EX.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Competence_Request_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Competence_Request_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl + "/" + record.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                ListGrid_Committee_EX.invalidateCache();

                            } else {
                                wait.close();
                                createDialog("info", "رکورد مورد نظر دارای زیر مجموعه می باشد");
                            }
                        }));
                    }
                }
            });
        }
    }

    function committeeSelectionUpdated_Tabs() {

        let record = ListGrid_Committee_EX.getSelectedRecord();
        let tab = Committee_Tabs.getSelectedTab();

        if (record == null && tab.pane != null) {
            tab.pane.setData([]);
            return;
        }


        switch (tab.name) {
            case "TabPane_Committee_Persons": {
                RestDataSource_Perssons.fetchDataURL = committeeRequestUrl + "/listOfParts/"+record.id;
                ListGrid_Committee_Persons.invalidateCache();
                ListGrid_Committee_Persons.fetchData();
                break;
            }
            // case "TabPane_Basic_Tuition": {
            //     RestDataSource_Decision_Educational_history.fetchDataURL = educationalDecisionRequestUrl + "/list/history/"+record.id;
            //     ListGrid_Decision_Educational_history.invalidateCache();
            //     ListGrid_Decision_Educational_history.fetchData();
            //     break;
            // }

        }
    }


    // </script>