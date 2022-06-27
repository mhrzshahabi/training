<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------

    let personnelTypeEx ;
    let personnelIdEx;

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
    DynamicForm_Committee_personnel = isc.DynamicForm.create({
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
                name: "personnel",
                title: "انتخاب پرسنل",
                colSpan: 2,
                align: "center",
                width: 170,
                type: "button",
                startRow: false,
                endRow: false,
                click: function () {
                     showPersonnelWin();
                }
            },
            {
                name: "personnelName",
                canEdit: false,
                title: "فرد انتخاب شده",
                required: true
            },
            {
                name: "role",
                length: 150,
                title: "نقش در کمیته",
                required: true
            },

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



    let PersonnelRegDS_student_ex = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "companyName",
                title: "<spring:message code="company.name"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains"
            },
            {
                name: "postTitle",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },

        ],
        // autoFetchData: true,
        fetchDataURL: personnelRegUrl + "/spec-list",
    });



    let PersonnelsRegLG_student_ex = isc.TrLG.create({
        ID: "PersonnelsRegLG_student",
        dataSource: PersonnelRegDS_student_ex,
        selectionType: "single",
        fields: [
            //{name: "id", hidden: true},
            {name: "firstName"},
            {name: "lastName"},
            {
                name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName", hidden: true},
            {
                name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle"}
        ],




     });

    var SynonymPersonnelsDS_student_ex = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "companyName",
                title: "<spring:message code="company.name"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains"
            },
            {
                name: "postTitle",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            }

        ],
        fetchDataURL: personnelUrl + "/Synonym/iscList"
    });


    let SynonymPersonnelsLG_student_ex = isc.TrLG.create({
        ID: "SynonymPersonnelsLG_student",
        dataSource: SynonymPersonnelsDS_student_ex,
        selectionType: "single",
        fields: [
            {name: "id", hidden: true},
            {name: "firstName"},
            {name: "lastName"},
            {
                name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName", hidden: true},
            {
                name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle"}
        ],

    });







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

    Committee_Persons_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    addToCommitteePersonnel()
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
        gridComponents: [Committee_Persons_actions, "filterEditor", "header", "body", "summaryRow"]

    });



    let registered_List_VLayout_ex = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    title: "<spring:message code="all.persons"/>",
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        PersonnelsRegLG_student_ex
                    ]
                }]
            }),
        ]
    });
    let synonym_Personnel_List_VLayout_ex = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            isc.SectionStack.create({
                sections: [{
                    title: "<spring:message code="all.persons"/>",
                    expanded: true,
                    canCollapse: false,
                    align: "center",
                    items: [
                        SynonymPersonnelsLG_student_ex
                    ]
                }]
            }),
        ]
    });


    let personnelTabs_ex = isc.TabSet.create({
        height: "50%",
        width: "100%",
        showTabScroller: false,
        tabs: [
            {
                name:"PersonnelList_Tab_synonym_Personnel",
                title: "<spring:message code='PersonnelList_Tab_synonym_Personnel'/>",
                pane: synonym_Personnel_List_VLayout_ex
            },
            {
                name:"personnel.tab.registered",
                title: "<spring:message code='personnel.tab.registered'/>",
                pane: registered_List_VLayout_ex
            }

        ]
        ,tabSelected: function () {

            let tab = personnelTabs_ex.getSelectedTab();



            switch (tab.name) {
                case "personnel.tab.registered": {
                    PersonnelsRegLG_student_ex.invalidateCache();
                    PersonnelsRegLG_student_ex.fetchData();
                    break;
                }
                case "PersonnelList_Tab_synonym_Personnel": {
                    SynonymPersonnelsLG_student_ex.invalidateCache();
                    SynonymPersonnelsLG_student_ex.fetchData();

                    break;
                }

            }
        }
    });


    var personnelTabs_exHlayout = isc.TrHLayoutButtons.create({
        members: [
            isc.IButtonSave.create({
                top: 100,
                title: "<spring:message code='save'/>",
                align: "center",
                icon: "[SKIN]/actions/save.png",
                click: function () {
                    let tab = personnelTabs_ex.getSelectedTab();
                    switch (tab.name) {
                        case "personnel.tab.registered": {
                            let record = PersonnelsRegLG_student_ex.getSelectedRecord();
                            if (record == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else {
                                 personnelTypeEx ="registered";
                                 personnelIdEx=record.id;
                                DynamicForm_Committee_personnel.getItem("personnelName").setValue(record.firstName + " "+record.lastName);
                            }

                            break;
                        }
                        case "PersonnelList_Tab_synonym_Personnel": {

                            let record = SynonymPersonnelsLG_student_ex.getSelectedRecord();
                            if (record == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else {
                                personnelTypeEx ="Synonym";
                                personnelIdEx=record.id;
                                DynamicForm_Committee_personnel.getItem("personnelName").setValue(record.firstName + " "+record.lastName);
                            }

                            break;
                        }

                    }




                    ClassStudentWin_student_ex.close();
                }
            }),
            isc.IButtonCancel.create({
                top: 100,
                title: "<spring:message code='cancel'/>",
                align: "center",
                icon: "[SKIN]/actions/cancel.png",
                click: function () {
                    ClassStudentWin_student_ex.close();
                }
            }),
        ]
    });


    let ClassStudentWin_student_ex = isc.Window.create({
        width: 1000,
        title:"انتخاب پرسنل",
        height: 768,
        minWidth: 1000,
        minHeight: 600,
        autoSize: false,
        items: [
            personnelTabs_ex,
            personnelTabs_exHlayout
        ]
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
    HLayout_IButtons_committee_persons = isc.HLayout.create({
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
                    savePartOfCommitte()
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    Window_base_Decision_committee_persons.close();
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

    Window_base_Decision_committee_persons = isc.Window.create({
        title: "افزودن اعضای کمیته",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Committee_personnel,
            HLayout_IButtons_committee_persons
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
    function showPersonnelWin() {
        SynonymPersonnelsLG_student_ex.invalidateCache();
        // SynonymPersonnelsLG_student_ex.fetchData();
        PersonnelsRegLG_student_ex.invalidateCache();
        // PersonnelsRegLG_student_ex.fetchData();
         ClassStudentWin_student_ex.show();

    }

    function addToCommitteePersonnel() {
        let record = ListGrid_Committee_EX.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            DynamicForm_Committee_personnel.clearValues();
            DynamicForm_Committee_personnel.clearErrors();
            Window_base_Decision_committee_persons.show();
        }
    }
    function savePartOfCommitte() {
        let record = ListGrid_Committee_EX.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        if (!DynamicForm_Committee_personnel.validate())
            return;

        let data = DynamicForm_Committee_personnel.getValues();

        data.personnelType =personnelTypeEx
        data.personnelId =personnelIdEx
        data.parentId =record.id
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(committeeRequestUrl+"/addPart", "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                Window_base_Decision_committee_persons.close();
                DynamicForm_Committee_personnel.invalidateCache();
                ListGrid_Committee_Persons.invalidateCache();
            } else {
                wait.close();
                createDialog("info", "خطایی رخ داده است");
            }
        }));


    }
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