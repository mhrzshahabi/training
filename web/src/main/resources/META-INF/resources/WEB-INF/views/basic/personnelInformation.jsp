<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        PersonnelInfoDS_PersonnelList = isc.TrDS.create({
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


        PersonnelInfoListGrid_PersonnelList = isc.TrLG.create({
            dataSource: PersonnelInfoDS_PersonnelList,
            selectionType: "single",
            autoFetchData: true,
            fields: [
                {name: "id", hidden: true},
                {name: "firstName"},
                {name: "lastName"},
                {name: "nationalCode"},
                {name: "companyName"},
                {name: "personnelNo"},
                {name: "personnelNo2"},
                {name: "postTitle"},
                {name: "ccpArea"},
                {name: "ccpAssistant"},
                {name: "ccpAffairs"},
                {name: "ccpSection"},
                {name: "ccpUnit"}
            ],
            recordClick: function () {
                set_PersonnelInfo_Details();
            }
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------
    {
//*****create fields*****
        var DynamicForm_PersonnelInfo = isc.DynamicForm.create({
            numCols: 6,
            colWidths: ["3%", "18%", "3%", "18%", "3%", "18%"],
            cellPadding: 3,
            isGroup: true,
            groupTitle: "مشخصات شخصی",
            groupLabelBackgroundColor: "#b7dee8",
            groupBorderCSS: "1px solid #b7dee8",
            fields:
                [
                    {
                        name: "firstName",
                        title: "نام و نام خانوادگی : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "کد پرسنلی",
                        canEdit: false
                    },
                    {
                        name: "firstName",
                        title: "نام پدر",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "تولد",
                        canEdit: false
                    },
                    {
                        name: "firstName",
                        title: "کد ملی",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "شماره شناسنامه",
                        canEdit: false
                    },
                    {
                        name: "firstName",
                        title: "تحصیلات",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "جنسیت",
                        canEdit: false
                    }
                ]
        });

        var DynamicForm_PersonnelCompanyInfo = isc.DynamicForm.create({
            numCols: 6,
            colWidths: ["3%", "18%", "3%", "18%", "3%", "18%"],
            cellPadding: 3,
            isGroup: true,
            groupTitle: "مشخصات سازمانی",
            groupLabelBackgroundColor: "#d8e4bc",
            groupBorderCSS: "1px solid #d8e4bc",
            fields:
                [
                    {
                        name: "firstName",
                        title: "سرپرست : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "رابط : ",
                        canEdit: false
                    },
                    {
                        name: "firstName",
                        title: "وضعیت اشتغال : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "حوزه : ",
                        canEdit: false
                    },
                    {
                        name: "firstName",
                        title: "بخش : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "شعبه : ",
                        canEdit: false
                    },
                    {
                        name: "firstName",
                        title: "شغل : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "سمت : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "رده : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "رسته شغلی : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "طبقه شغلی : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "کدرسنلی شش رقمی : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "پایه سمت : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "پایه شخص : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "نوع استخدام : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "تاریخ استخدام : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "محل جغرافیایی خدمت : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "عوامل : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "تقسیم کارکنان : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "وضعیت خدمت : ",
                        canEdit: false
                    }
                ]
        });

        var DynamicForm_PersonnelContactInfo = isc.DynamicForm.create({
            numCols: 6,
            colWidths: ["3%", "18%", "3%", "18%", "3%", "18%"],
            cellPadding: 3,
            isGroup: true,
            groupTitle: "اطلاعات تماس",
            groupLabelBackgroundColor: "#b8cce4",
            groupBorderCSS: "1px solid #b8cce4",
            fields:
                [
                    {
                        name: "firstName",
                        title: "تلفن : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "همراه : ",
                        canEdit: false
                    },
                    {
                        name: "firstName",
                        title: "پست الکترونیکی : ",
                        canEdit: false
                    },
                    {
                        name: "lastName",
                        title: "آدرس : ",
                        canEdit: false
                    },
                ]
        });
    }
    // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>

    // <<-------------------------------------- Create - TabSet & Tab -----------------------------------------
    {
        var VLayout_PersonnelInfo_Detail = isc.VLayout.create({
            width: "100%",
            height: "100%",
            membersMargin: 5,
            members: [DynamicForm_PersonnelInfo, DynamicForm_PersonnelCompanyInfo, DynamicForm_PersonnelContactInfo]
        });

        var PersonnelInfo_Tab = isc.TabSet.create({
            ID: "PersonnelInfo_Tab",
            tabBarPosition: "top",
            tabs: [
                {
                    id: "PersonnelInfo_Tab_Info",
                    title: "اطلاعات شخصی",
                    pane: VLayout_PersonnelInfo_Detail

                },
                {
                    id: "PersonnelInfo_Tab_Training",
                    title: "آموزش ها"
                },
                {
                    id: "PersonnelInfo_Tab_NeedAssessment",
                    title: "شایستگی"
                }
            ]
        });
    }
    // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

    // <<------------------------------------------- Create - Layout ------------------------------------------
    {
        var HLayout_PersonnelInfo_List = isc.HLayout.create({
            width: "100%",
            height: "50%",
            showResizeBar: true,
            members: [PersonnelInfoListGrid_PersonnelList]
        });

        var HLayout_PersonnelInfo_Details = isc.HLayout.create({
            width: "100%",
            height: "50%",
            members: [PersonnelInfo_Tab]
        });

        var VLayout_PersonnelInfo_Data = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_PersonnelInfo_List, HLayout_PersonnelInfo_Details]
        });
    }
    // ---------------------------------------------- Create - Layout ---------------------------------------->>

    // <<----------------------------------------------- Functions --------------------------------------------
    {
        function set_PersonnelInfo_Details() {

            let selectedPersonnel = PersonnelInfoListGrid_PersonnelList.getSelectedRecord();

            console.log(selectedPersonnel);

            if (selectedPersonnel !== null) {
                DynamicForm_PersonnelInfo.clearValues();
                DynamicForm_PersonnelInfo.editRecord(selectedPersonnel);
            }

        }
    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>