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
            colWidths: ["1%", "10%", "1%", "10%", "1%", "10%"],
            cellPadding: 3,
            fields:
                [
                    {
                        name: "header_PersonnelInfo",
                        type: "HeaderItem",
                        defaultValue: "مشخصات شخصی",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "fullName",
                        title: "نام و نام خانوادگی : ",
                        canEdit: false,
                    },
                    {
                        name: "personnelNo",
                        title: "کد پرسنلی : ",
                        canEdit: false
                    },
                    {
                        name: "fatherName",
                        title: "نام پدر : ",
                        canEdit: false
                    },
                    {
                        name: "birth",
                        title: "تولد : ",
                        canEdit: false
                    },
                    {
                        name: "nationalCode",
                        title: "کد ملی : ",
                        canEdit: false
                    },
                    {
                        name: "birthCertificateNo",
                        title: "شماره شناسنامه",
                        canEdit: false
                    },
                    {
                        name: "educationLevelTitle",
                        title: "تحصیلات : ",
                        canEdit: false
                    },
                    {
                        name: "gender",
                        title: "جنسیت : ",
                        canEdit: false
                    },
                    {
                        name: "header_CompanyInfo",
                        type: "HeaderItem",
                        defaultValue: "مشخصات سازمانی",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "notExists",
                        title: "سرپرست : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "رابط : ",
                        canEdit: false
                    },
                    {
                        name: "employmentStatus",
                        title: "وضعیت اشتغال : ",
                        canEdit: false
                    },
                    {
                        name: "ccpAssistant",
                        title: "حوزه : ",
                        canEdit: false
                    }, {
                    name: "ccpAffairs",
                    title: "واحد : ",
                    canEdit: false
                },
                    {
                        name: "ccpSection",
                        title: "بخش : ",
                        canEdit: false
                    },
                    {
                        name: "companyName",
                        title: "شعبه : ",
                        canEdit: false
                    },
                    {
                        name: "postTitle",
                        title: "شغل : ",
                        canEdit: false
                    },
                    {
                        name: "jobTitle",
                        title: "سمت : ",
                        canEdit: false
                    },
                    {
                        name: "postGradeTitle",
                        title: "رده : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "رسته شغلی : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "طبقه شغلی : ",
                        canEdit: false
                    },
                    {
                        name: "personnelNo2",
                        title: "کد پرسنلی شش رقمی : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "پایه سمت : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "پایه شخص : ",
                        canEdit: false
                    },
                    {
                        name: "employmentTypeTitle",
                        title: "نوع استخدام : ",
                        canEdit: false
                    },
                    {
                        name: "employmentDate",
                        title: "تاریخ استخدام : ",
                        canEdit: false
                    },
                    {
                        name: "workPlaceTitle",
                        title: "محل جغرافیایی خدمت : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "عوامل : ",
                        canEdit: false
                    },
                    {
                        name: "workTurnTitle",
                        title: "تقسیم کارکنان : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "وضعیت خدمت : ",
                        canEdit: false
                    },
                    {
                        name: "header_ContactInfo",
                        type: "HeaderItem",
                        defaultValue: "اطلاعات تماس",
                        colSpan: 6,
                        startRow: true,
                        cellStyle: "lineField"
                    },
                    {
                        name: "tel",
                        title: "تلفن : ",
                        canEdit: false
                    },
                    {
                        name: "mobile",
                        title: "همراه : ",
                        canEdit: false
                    },
                    {
                        name: "email",
                        title: "پست الکترونیکی : ",
                        canEdit: false
                    },
                    {
                        name: "address",
                        title: "آدرس : ",
                        canEdit: false
                    }
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
            members: [DynamicForm_PersonnelInfo]
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

            let personnelId = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().id

            if (personnelId !== null) {

                isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "/byPersonnelId/" + personnelId, "GET", null, function (resp) {

                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                        let currentPersonnel = JSON.parse(resp.data);

                        currentPersonnel.fullName =
                            (currentPersonnel.firstName !== undefined ? currentPersonnel.firstName : "")
                            + " " +
                            (currentPersonnel.lastName !== undefined ? currentPersonnel.lastName : "");

                        currentPersonnel.birth = currentPersonnel.birthDate + " - " + currentPersonnel.birthPlace;

                        currentPersonnel.educationLevelTitle =
                            (currentPersonnel.educationLevelTitle !== undefined ? currentPersonnel.educationLevelTitle : "")
                            + " / " +
                            (currentPersonnel.educationMajorTitle !== undefined ? currentPersonnel.educationMajorTitle : "");

                        currentPersonnel.gender = currentPersonnel.gender + " - " + currentPersonnel.maritalStatusTitle;
                        DynamicForm_PersonnelInfo.clearValues();
                        DynamicForm_PersonnelInfo.editRecord(currentPersonnel);

                    }

                }));
            }
        }
    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>