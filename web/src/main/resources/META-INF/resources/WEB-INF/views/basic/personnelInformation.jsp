<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    var url = '';
    // <<-------------------------------------- Create - ToolStripButton --------------------------------------
        {
            //*****toolStrip*****
            var ToolStripButton_Refresh_PI = isc.ToolStripButtonRefresh.create({
                title: "<spring:message code="refresh"/>",
                click: function () {
                    if(typeof(set_PersonnelInfo_Details)!='undefined') {
                        if (PersonnelList_Tab.getSelectedTab().id === "PersonnelList_Tab_Personnel") {
                            PersonnelInfoListGrid_PersonnelList.invalidateCache();
                            set_PersonnelInfo_Details(PersonnelInfoListGrid_PersonnelList);
                        } else {
                            PersonnelInfoListGrid_RegisteredPersonnelList.invalidateCache();
                            set_PersonnelInfo_Details(PersonnelInfoListGrid_RegisteredPersonnelList);
                        }
                    }
                }
            });

            var ToolStrip_Personnel_Info = isc.ToolStrip.create({
                width: "100%",
                membersMargin: 5,
                members: [
                    isc.ToolStrip.create({
                        width: "100%",
                        align: "left",
                        border: '0px',
                        members: [
                            ToolStripButton_Refresh_PI
                        ]
                    })
                ]
            });
        }
        // ---------------------------------------- Create - ToolStripButton ------------------------------------>>

        // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
        {
            var PersonnelInfoDS_PersonnelList = isc.TrDS.create({
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
                    {
                        name: "postCode",
                        title: "<spring:message code="post.code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "ccpArea",
                        title: "<spring:message code="reward.cost.center.area"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpAssistant",
                        title: "<spring:message code="reward.cost.center.assistant"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpAffairs",
                        title: "<spring:message code="reward.cost.center.affairs"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpSection",
                        title: "<spring:message code="reward.cost.center.section"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpUnit",
                        title: "<spring:message code="reward.cost.center.unit"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: personnelUrl + "/iscList"
            });


            var PersonnelInfoDS_WebService_PersonnelList = isc.TrDS.create({
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
                    {
                        name: "postCode",
                        title: "<spring:message code="post.code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "ccpArea",
                        title: "<spring:message code="reward.cost.center.area"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpAssistant",
                        title: "<spring:message code="reward.cost.center.assistant"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpAffairs",
                        title: "<spring:message code="reward.cost.center.affairs"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpSection",
                        title: "<spring:message code="reward.cost.center.section"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpUnit",
                        title: "<spring:message code="reward.cost.center.unit"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: masterDataUrl + "/personnel/iscList"
            });

            var PersonnelInfoListGrid_PersonnelList = isc.TrLG.create({
                dataSource: PersonnelInfoDS_PersonnelList,
                selectionType: "single",
                autoFetchData: true,
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
                    {name: "companyName"},
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
                    {name: "postTitle"},
                    {
                        name: "postCode",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {name: "ccpArea"},
                    {name: "ccpAssistant"},
                    {name: "ccpAffairs"},
                    {name: "ccpSection"},
                    {name: "ccpUnit"}
                ],
                recordClick: function () {
                    if(typeof(set_PersonnelInfo_Details)!='undefined')
                    {
                        set_PersonnelInfo_Details(this.getSelectedRecord());
                    }
                }
            });

            let criteriaActivePersonnel = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "active", operator: "equals", value: 1}
                ]
            };

            PersonnelInfoListGrid_PersonnelList.implicitCriteria = criteriaActivePersonnel;

            var PersonnelInfoListGrid_WebService_PersonnelList = isc.TrLG.create({
                dataSource: PersonnelInfoDS_WebService_PersonnelList,
                selectionType: "single",
                autoFetchData: true,
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
                    {name: "companyName" , canFilter:false,canSort:false},
                    {
                        name: "personnelNo"

                    },
                    {
                        name: "personnelNo2", canFilter:false,canSort:false
                    },
                    {name: "postTitle"},
                    {
                        name: "postCode",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {name: "ccpArea", canFilter:false,canSort:false},
                    {name: "ccpAssistant", canFilter:false,canSort:false},
                    {name: "ccpAffairs", canFilter:false,canSort:false},
                    {name: "ccpSection"},
                    {name: "ccpUnit"}
                ],
                recordClick: function () {
                    if(typeof(set_PersonnelInfo_Details)!='undefined')
                    {
                        set_PersonnelInfo_Details();
                    }
                }
            });



            PersonnelInfoDS_RegisteredPersonnelList = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "firstName",
                        title: "<spring:message code="firstName"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "lastName",
                        title: "<spring:message code="lastName"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "nationalCode",
                        title: "<spring:message code="national.code"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "companyName",
                        title: "<spring:message code="company.name"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "personnelNo",
                        title: "<spring:message code="personnel.no"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "personnelNo2",
                        title: "<spring:message code="personnel.no.6.digits"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "postTitle",
                        title: "<spring:message code="post"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpArea",
                        title: "<spring:message code="reward.cost.center.area"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpAssistant",
                        title: "<spring:message code="reward.cost.center.assistant"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpAffairs",
                        title: "<spring:message code="reward.cost.center.affairs"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpSection",
                        title: "<spring:message code="reward.cost.center.section"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ccpUnit",
                        title: "<spring:message code="reward.cost.center.unit"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: personnelRegUrl + "/spec-list"
            });


            PersonnelInfoListGrid_RegisteredPersonnelList = isc.TrLG.create({
                dataSource: PersonnelInfoDS_RegisteredPersonnelList,
                selectionType: "single",
                autoFetchData: true,
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
                    {name: "postTitle"},
                    {name: "ccpArea"},
                    {name: "ccpAssistant", hidden: true},
                    {name: "ccpAffairs", hidden: true},
                    {name: "ccpSection", hidden: true},
                    {name: "ccpUnit", hidden: true}
                ],
                recordClick: function () {
                    if(typeof(set_PersonnelInfo_Details)!='undefined') {
                        set_PersonnelInfo_Details(this);
                    }
                }
            });
        }
        // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

        // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------
        {
            var Window_WebService_PersonnelInformation = isc.Window.create({
                title: "<spring:message code='personal'/>",
                width: "100%",
                height: "100%",
                minWidth: "100%",
                minHeight: "100%",
                autoSize: false,
                items: [
                    PersonnelInfoListGrid_WebService_PersonnelList,
                    isc.HLayout.create({
                        width: "100%",
                        height: "6%",
                        autoDraw: false,
                        align: "center",
                        members: [
                            isc.IButton.create({
                                title: "<spring:message code='close'/>",
                                icon: "[SKIN]/actions/cancel.png",
                                width: "70",
                                align: "center",
                                click: function () {
                                    Window_WebService_PersonnelInformation.close();
                                }
                            })
                        ]
                    })

                ]
            });


        }
        // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>

        // <<-------------------------------------- Create - TabSet & Tab -----------------------------------------

    var PersonnelList_Tab = isc.TabSet.create({
        ID: "PersonnelList_Tab",
        tabBarPosition: "top",
        tabs: [
            {
                id: "PersonnelList_Tab_Personnel",
                title: "<spring:message code='personnel.tab.persone'/>",
                pane: PersonnelInfoListGrid_PersonnelList
            },
            {
                id: "PersonnelList_Tab_RegisteredPersonnel",
                title: "<spring:message code='personnel.tab.registered'/>",
                pane: PersonnelInfoListGrid_RegisteredPersonnelList
            }
        ],
        tabSelected: function () {
            if(typeof(set_PersonnelInfo_Details)!='undefined') {
                set_PersonnelInfo_Details(this.getSelectedTab().id === "PersonnelList_Tab_Personnel" ? PersonnelInfoListGrid_PersonnelList : PersonnelInfoListGrid_RegisteredPersonnelList);
            }
        }
    });

        // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

        // <<------------------------------------------- Create - Layout ------------------------------------------
        {
            //*****class HLayout & VLayout*****
            var HLayout_Actions_PI = isc.HLayout.create({
                width: "100%",
                height: "1%",
                membersMargin: 5,
                members: [
                    isc.ToolStripButtonAdd.create({
                        title: 'فیلتر گروهي',
                        click: function () {
                            if(PersonnelList_Tab.getSelectedTab().id === "PersonnelList_Tab_Personnel" )
                            {
                                groupFilter("فیلتر گروهی", personnelRegUrl, checkPersonnelNosResponse);
                            }
                            else
                            {
                                groupFilter("فیلتر گروهی", personnelRegUrl, checkRegisterPersonnelNosResponse);
                            }

                        }
                    }),
                    isc.ToolStripButtonExcel.create({
                        title: 'ارسال لیست فیلتر شده به اکسل',
                        click: function () {
                            if(PersonnelList_Tab.getSelectedTab().id === "PersonnelList_Tab_Personnel" )
                            {
                                ExportToFile.showDialog(null, PersonnelInfoListGrid_PersonnelList, 'personnelInformationReport', 0, null, '', "گزارش پرسنل شرکتي", PersonnelInfoListGrid_PersonnelList.data.criteria, null);
                            }
                            else
                            {
                                ExportToFile.showDialog(null, PersonnelInfoListGrid_RegisteredPersonnelList, 'registeredPersonnelInformationReport', 0, null, '', "گزارش پرسنل افراد متفرقه", PersonnelInfoListGrid_RegisteredPersonnelList.data.criteria, null);
                            }
                        }
                    }),
                    ToolStrip_Personnel_Info]
            });

            var Hlayout_Grid_PI = isc.HLayout.create({
                width: "100%",
                height: "99%",
                members: [PersonnelList_Tab]
            });

            var VLayout_PersonnelInfo_List = isc.VLayout.create({
                width: "100%",
                height: "50%",
                showResizeBar: true,
                members: [HLayout_Actions_PI, Hlayout_Grid_PI]
            });


            var HLayout_PersonnelInfo_Details = isc.HLayout.create({
                width: "100%",
                height: "50%",
                members: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/personnel-information-details/"})]
            });

            var VLayout_PersonnelInfo_Data = isc.VLayout.create({
                width: "100%",
                height: "100%",
                members: [VLayout_PersonnelInfo_List, HLayout_PersonnelInfo_Details]
            });
        }
        // ---------------------------------------------- Create - Layout ---------------------------------------->>

        // <<----------------------------------------------- Functions --------------------------------------------
        {
            function checkPersonnelNosResponse(url, result) {
                advancedCriteriaPersonnelInformation = {
                    operator: "or",
                    criteria: [
                        {fieldName: "personnelNo", operator: "inSet", value: result},
                        {fieldName: "personnelNo2", operator: "inSet", value: result}
                    ]
                };
                PersonnelInfoListGrid_PersonnelList.fetchData(advancedCriteriaPersonnelInformation);
                ClassStudentWin_student_GroupInsert.close();
            }

            function checkRegisterPersonnelNosResponse(url, result) {
                advancedCriteriaPersonnelInformation = {
                    operator: "or",
                    criteria: [
                        {fieldName: "personnelNo", operator: "inSet", value: result},
                        {fieldName: "personnelNo2", operator: "inSet", value: result}
                    ]
                };
                PersonnelInfoListGrid_RegisteredPersonnelList.fetchData(advancedCriteriaPersonnelInformation);
                ClassStudentWin_student_GroupInsert.close();
            }
        }
    // ------------------------------------------------- Functions ------------------------------------------>>


    // </script>