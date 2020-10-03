<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    {
        var url = '';
        let oPersonnelInformationDetails=null;
        // <<-------------------------------------- Create - ToolStripButton --------------------------------------
        {
            //*****toolStrip*****
            var ToolStripButton_Refresh_PI = isc.ToolStripButtonRefresh.create({
                title: "<spring:message code="refresh"/>",
                click: function () {

                    if (PersonnelList_Tab.getSelectedTab().id === "PersonnelList_Tab_Personnel") {
                        PersonnelInfoListGrid_PersonnelList.invalidateCache();
                        if (oPersonnelInformationDetails!=null && typeof (oPersonnelInformationDetails.set_PersonnelInfo_Details) != 'undefined') {
                            oPersonnelInformationDetails.set_PersonnelInfo_Details(null);
                        }
                    } else {
                        PersonnelInfoListGrid_RegisteredPersonnelList.invalidateCache();
                        if (oPersonnelInformationDetails!=null && typeof (oPersonnelInformationDetails.set_PersonnelInfo_Details) != 'undefined') {
                            oPersonnelInformationDetails.set_PersonnelInfo_Details(null);
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
                    },
                    {
                        name: "mobile",
                        title: "<spring:message code="mobile"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: personnelUrl + "/iscList"
            });


            /*var PersonnelInfoDS_WebService_PersonnelList = isc.TrDS.create({
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
            });*/

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
                    {name: "ccpUnit"},
                    {name: "mobile"}
                ],
                recordClick: function () {
                    if (oPersonnelInformationDetails!=null && typeof (oPersonnelInformationDetails.set_PersonnelInfo_Details) != 'undefined') {
                        oPersonnelInformationDetails.set_PersonnelInfo_Details(this.getSelectedRecord());
                    }
                }
            });

            let criteriaActivePersonnel = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "deleted", operator: "equals", value: 0}
                ]
            };

            PersonnelInfoListGrid_PersonnelList.implicitCriteria = criteriaActivePersonnel;

            /*var PersonnelInfoListGrid_WebService_PersonnelList = isc.TrLG.create({
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
                    {name: "companyName", canFilter: false, canSort: false},
                    {
                        name: "personnelNo"

                    },
                    {
                        name: "personnelNo2", canFilter: false, canSort: false
                    },
                    {name: "postTitle"},
                    {
                        name: "postCode",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {name: "ccpArea", canFilter: false, canSort: false},
                    {name: "ccpAssistant", canFilter: false, canSort: false},
                    {name: "ccpAffairs", canFilter: false, canSort: false},
                    {name: "ccpSection"},
                    {name: "ccpUnit"}
                ],
                recordClick: function () {
                    if (oPersonnelInformationDetails!=null && typeof (oPersonnelInformationDetails.set_PersonnelInfo_Details) != 'undefined') {
                        oPersonnelInformationDetails.set_PersonnelInfo_Details(this.getSelectedRecord());
                    }
                }
            });*/


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
                    },
                    {
                        name: "mobile",
                        title: "<spring:message code="mobile"/>",
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
                    if (oPersonnelInformationDetails!=null && typeof (oPersonnelInformationDetails.set_PersonnelInfo_Details) != 'undefined') {
                        oPersonnelInformationDetails.set_PersonnelInfo_Details(this.getSelectedRecord());
                    }
                }
            });

            let criteriaActivePersonnelRegistered = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "deleted", operator: "isNull"}
                ]
            };

            PersonnelInfoListGrid_RegisteredPersonnelList.implicitCriteria = criteriaActivePersonnelRegistered;
        }
        // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

        // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------
        {
            /*var Window_WebService_PersonnelInformation = isc.Window.create({
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
            });*/


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
                if (oPersonnelInformationDetails!=null && typeof (oPersonnelInformationDetails.set_PersonnelInfo_Details) != 'undefined') {
                    oPersonnelInformationDetails.set_PersonnelInfo_Details(this.getSelectedTab().id === "PersonnelList_Tab_Personnel" ? PersonnelInfoListGrid_PersonnelList.getSelectedRecord() : PersonnelInfoListGrid_RegisteredPersonnelList.getSelectedRecord());
                }
            }
        });

        // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

        // <<------------------------------------------- Create - Layout ------------------------------------------
        {
            var btnRemoveCriteria = isc.ToolStripButtonRemove.create({
                title: 'حذف فیلتر گروهي',
                enabled: false,
                click: function () {
                    PersonnelInfoListGrid_PersonnelList.fetchData();
                    PersonnelInfoListGrid_RegisteredPersonnelList.fetchData();

                    btnRemoveCriteria.disable();
                }
            })
            //*****class HLayout & VLayout*****
            var HLayout_Actions_PI = isc.HLayout.create({
                width: "100%",
                height: "1%",
                membersMargin: 5,
                members: [
                    btnRemoveCriteria,
                    isc.ToolStripButtonAdd.create({
                        title: 'فیلتر گروهي',
                        click: function () {
                            if (PersonnelList_Tab.getSelectedTab().id === "PersonnelList_Tab_Personnel") {
                                groupFilter("فیلتر گروهی", personnelUrl + "/checkPersonnelNos",checkPersonnelNosResponse, true, true, 0,false);
                            } else {
                                groupFilter("فیلتر گروهی", personnelRegUrl + "/checkPersonnelNos", checkRegisterPersonnelNosResponse, true, true, 0,false);
                            }

                        }
                    }),
                    isc.ToolStripButtonExcel.create({
                        title: 'ارسال لیست فیلتر شده به اکسل',
                        click: function () {
                            if (PersonnelList_Tab.getSelectedTab().id === "PersonnelList_Tab_Personnel") {
                                let implicitCriteria = JSON.parse(JSON.stringify(PersonnelInfoListGrid_PersonnelList.getImplicitCriteria())) ;
                                let criteria = PersonnelInfoListGrid_PersonnelList.getCriteria();

                                if(PersonnelInfoListGrid_PersonnelList.getCriteria().criteria){
                                    for (let i = 0; i < criteria.criteria.length ; i++) {
                                        implicitCriteria.criteria.push(criteria.criteria[i]);
                                    }
                                }

                                ExportToFile.downloadExcelRestUrl(null, PersonnelInfoListGrid_PersonnelList, personnelUrl + "/iscList", 0, null, '', "گزارش پرسنل شرکتي", implicitCriteria, null);
                            } else {
                                ExportToFile.downloadExcel(null, PersonnelInfoListGrid_RegisteredPersonnelList, 'registeredPersonnelInformationReport', 0, null, '', "گزارش پرسنل افراد متفرقه", PersonnelInfoListGrid_RegisteredPersonnelList.data.criteria, null);
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
                //members: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/test/"})]
            });
            if (!loadjs.isDefined('personnel-information-details')) {
                loadjs('<spring:url value='web/personnel-information-details/' />', 'personnel-information-details');
            }

            loadjs.ready('personnel-information-details', function() {
                oPersonnelInformationDetails=new loadPersonnelInformationDetails();
                HLayout_PersonnelInfo_Details.addMember(oPersonnelInformationDetails.PersonnelInfo_Tab);
            });

            /*isc.FileLoader.loadJSFile("web/test")
            HLayout_PersonnelInfo_Details.addMember(ListGrid_PersonnelTraining);
            x();*/


            var VLayout_PersonnelInfo_Data = isc.VLayout.create({
                width: "100%",
                height: "100%",
                members: [VLayout_PersonnelInfo_List, HLayout_PersonnelInfo_Details]
            });
        }
        // ---------------------------------------------- Create - Layout ---------------------------------------->>

        // <<----------------------------------------------- Functions --------------------------------------------
        {
            function checkPersonnelNosResponse(url, result, addStudentsInGroupInsert) {

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(url, "POST", JSON.stringify(result)
                    , "callback: checkPersonnelNos_PI(rpcResponse," + JSON.stringify(result) + ",'" + url + "'," + addStudentsInGroupInsert +")"));

            }

            function checkRegisterPersonnelNosResponse(url, result, addStudentsInGroupInsert) {

                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(url, "POST", JSON.stringify(result)
                    , "callback: checkPersonnelNos_PIR(rpcResponse," + JSON.stringify(result) + ",'" + url + "'," + addStudentsInGroupInsert +")"));
            }



            function checkPersonnelNos_PI(resp, result, url, insert) {
                if (generalGetResp(resp)) {
                    if (resp.httpResponseCode === 200) {
                        //------------------------------------*/
                        let len = GroupSelectedPersonnelsLG_student.data.length;
                        let list = GroupSelectedPersonnelsLG_student.data;
                        let data = JSON.parse(resp.data);
                        let allRowsOK = true;
                        var students = [];

                        for (let i = 0; i < len; i++) {
                            let personnelNo = list[i].personnelNo;

                            if(!result.includes(personnelNo)){
                                continue;
                            }

                            if (personnelNo != "" && personnelNo != null && typeof (personnelNo) != "undefined") {
                                let person = data.filter(function (item) {
                                    return item.personnelNo == personnelNo || item.personnelNo2 == personnelNo;
                                });

                                if (person.length == 0) {
                                    allRowsOK = false;
                                    list[i].error = true;
                                    list[i].hasWarning = "warning";
                                    list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">شخصی با کد پرسنلی وارد شده وجود ندارد.</span>";
                                } else {
                                    person = person[0];

                                    list[i].firstName = person.firstName;
                                    list[i].lastName = person.lastName;
                                    list[i].nationalCode = person.nationalCode;
                                    list[i].personnelNo1 = person.personnelNo;
                                    list[i].personnelNo2 = person.personnelNo2;
                                    list[i].isInNA = person.isInNA;
                                    list[i].scoreState = person.scoreState;
                                    list[i].error = false;
                                    list[i].hasWarning = "check";
                                    list[i].description = "";

                                    if (students.filter(function (item) {
                                        return item.personnelNo2 == person.personnelNo2 || item.personnelNo == person.personnelNo;
                                    }).length == 0) {
                                        students.add(list[i].personnelNo);
                                    }
                                }
                            }
                        }
                        if (students.getLength() > 0/*allRowsOK*/ && insert) {

                            advancedCriteriaPersonnelInformation = {
                                operator: "or",
                                criteria: [
                                    {fieldName: "personnelNo", operator: "inSet", value: students},
                                    {fieldName: "personnelNo2", operator: "inSet", value:  students}
                                ]
                            };
                            PersonnelInfoListGrid_PersonnelList.fetchData(advancedCriteriaPersonnelInformation);
                            ClassStudentWin_student_GroupInsert.close();
                            btnRemoveCriteria.enable();

                            wait.close();

                        } else {
                            GroupSelectedPersonnelsLG_student.invalidateCache();
                            GroupSelectedPersonnelsLG_student.fetchData();

                            wait.close();
                        }


                    }else{
                        wait.close();
                    }
                }else{
                    wait.close();
                }
            }

            function checkPersonnelNos_PIR(resp, result, url, insert) {
                if (generalGetResp(resp)) {
                    if (resp.httpResponseCode === 200) {
                        //------------------------------------*/
                        let len = GroupSelectedPersonnelsLG_student.data.length;
                        let list = GroupSelectedPersonnelsLG_student.data;
                        let data = JSON.parse(resp.data);
                        let allRowsOK = true;
                        var students = [];

                        for (let i = 0; i < len; i++) {
                            let personnelNo = list[i].personnelNo;

                            if(!result.includes(personnelNo)){
                                continue;
                            }

                            if (personnelNo != "" && personnelNo != null && typeof (personnelNo) != "undefined") {
                                let person = data.filter(function (item) {
                                    return item.personnelNo == personnelNo || item.personnelNo2 == personnelNo;
                                });

                                if (person.length == 0) {
                                    allRowsOK = false;
                                    list[i].error = true;
                                    list[i].hasWarning = "warning";
                                    list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">شخصی با کد پرسنلی وارد شده وجود ندارد.</span>";
                                } else {
                                    person = person[0];

                                    list[i].firstName = person.firstName;
                                    list[i].lastName = person.lastName;
                                    list[i].nationalCode = person.nationalCode;
                                    list[i].personnelNo1 = person.personnelNo;
                                    list[i].personnelNo2 = person.personnelNo2;
                                    list[i].isInNA = person.isInNA;
                                    list[i].scoreState = person.scoreState;
                                    list[i].error = false;
                                    list[i].hasWarning = "check";
                                    list[i].description = "";

                                    if (students.filter(function (item) {
                                        return item.personnelNo2 == person.personnelNo2 || item.personnelNo == person.personnelNo;
                                    }).length == 0) {
                                        students.add(list[i].personnelNo);
                                    }
                                }
                            }
                        }
                        if (students.getLength() > 0/*allRowsOK*/ && insert) {

                            advancedCriteriaPersonnelInformation = {
                                operator: "or",
                                criteria: [
                                    {fieldName: "personnelNo", operator: "inSet", value: result},
                                    {fieldName: "personnelNo2", operator: "inSet", value: result}
                                ]
                            };
                            PersonnelInfoListGrid_RegisteredPersonnelList.fetchData(advancedCriteriaPersonnelInformation);
                            ClassStudentWin_student_GroupInsert.close();
                            btnRemoveCriteria.enable();

                            wait.close();

                        } else {
                            GroupSelectedPersonnelsLG_student.invalidateCache();
                            GroupSelectedPersonnelsLG_student.fetchData();

                            wait.close();
                        }


                    }else{
                        wait.close();
                    }
                }else{
                    wait.close();
                }
            }

        }
        // ------------------------------------------------- Functions ------------------------------------------>>

    }
    // </script>