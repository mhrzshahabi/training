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
                {name: "postCode"},
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


        var RestDataSource_PersonnelTraining = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "code"},
                {name: "titleClass"},
                {name: "hduration"},
                {name: "startDate"},
                {name: "endDate"},
                {name: "classStatusId"},
                {name: "classStatus"},
                {name: "scoreStateId"},
                {name: "scoreState"},
                {name: "erunType"}
            ]
        });


        var ListGrid_PersonnelTraining = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_PersonnelTraining,
            selectionType: "single",
            autoFetchData: false,
            showGridSummary: true,
            fields: [
                {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                {
                    name: "code",
                    title: "<spring:message code="class.code"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalPlanning(records)"
                },
                {
                    name: "courseId",
                    title: "courseId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "courseTitle",
                    title: "<spring:message code="course.title"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalPassed(records)"
                },
                {
                    name: "titleClass",
                    title: "<spring:message code='class.title'/>",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "hduration",
                    title: "<spring:message code="class.duration"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "startDate",
                    title: "<spring:message code='start.date'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "endDate",
                    title: "<spring:message code='end.date'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "classStatusId",
                    title: "classStatusId",
                    align: "center",
                    filterOperator: "equals",
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "classStatus",
                    title: "<spring:message code="class.status"/>",
                    align: "center",
                    filterOperator: "equals",
                    summaryFunction: "totalRejected(records)"
                },
                {
                    name: "scoreStateId",
                    title: "scoreStateId",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "scoreState",
                    title: "<spring:message code="score.state"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalAll(records)"
                },
                {
                    name: "erunType",
                    title: "<spring:message code="course_eruntype"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                }

            ]
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------
    {
//*****create fields*****
        var DynamicForm_PersonnelInfo = isc.DynamicForm.create({
            numCols: 6,
            colWidths: ["1%", "3%", "1%", "3%", "1%", "3%"],
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
                        title: "شماره شناسنامه : ",
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
                        name: "workYears",
                        title: "آموزش جاری : ",
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
                    },
                    {
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
                    title: "آموزش ها",
                    pane: ListGrid_PersonnelTraining
                },
                {
                    id: "PersonnelInfo_Tab_NeedAssessment",
                    title: "شایستگی",
                    pane: isc.ViewLoader.create({autoDraw: true, viewURL: "web/needsAssessment-reports"})
                }

            ],
            tabSelected: function () {
                set_PersonnelInfo_Details();
            }
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

            if (PersonnelInfoListGrid_PersonnelList.getSelectedRecord() !== null) {

                let personnelNo = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().personnelNo;
                let nationalCode = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().nationalCode;

                if (PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_Info") {
                    if (personnelNo !== null) {

                        isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "/byPersonnelNo/" + personnelNo, "GET", null, function (resp) {

                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                let currentPersonnel = JSON.parse(resp.data);

                                currentPersonnel.fullName =
                                    (currentPersonnel.firstName !== undefined ? currentPersonnel.firstName : "")
                                    + " " +
                                    (currentPersonnel.lastName !== undefined ? currentPersonnel.lastName : "");

                                currentPersonnel.birth =
                                    (currentPersonnel.birthDate !== undefined ? currentPersonnel.birthDate : "")
                                    + " - " +
                                    (currentPersonnel.birthPlace !== undefined ? currentPersonnel.birthPlace : "");

                                currentPersonnel.educationLevelTitle =
                                    (currentPersonnel.educationLevelTitle !== undefined ? currentPersonnel.educationLevelTitle : "")
                                    + " / " +
                                    (currentPersonnel.educationMajorTitle !== undefined ? currentPersonnel.educationMajorTitle : "");

                                currentPersonnel.gender =
                                    (currentPersonnel.gender !== undefined ? currentPersonnel.gender : "")
                                    + " - " +
                                    (currentPersonnel.maritalStatusTitle !== undefined ? currentPersonnel.maritalStatusTitle : "");

                                DynamicForm_PersonnelInfo.clearValues();
                                DynamicForm_PersonnelInfo.editRecord(currentPersonnel);
                            }

                        }));
                    }
                } else if (PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_Training") {
                    if (nationalCode !== null) {
                        RestDataSource_PersonnelTraining.fetchDataURL = classUrl + "personnel-training/" + nationalCode;
                        ListGrid_PersonnelTraining.invalidateCache();
                        ListGrid_PersonnelTraining.fetchData();
                    }
                } else if (PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_NeedAssessment") {
                    call_needsAssessmentReports(PersonnelInfoListGrid_PersonnelList);
                }
            }
        }

        //*****calculate total summary*****

        function totalPlanning(records) {
            let totalPlanning_ = 0;
            for (i = 0; i < records.length; i++) {
                if (records[i].classStatusId === 1)
                    totalPlanning_ += records[i].hduration;
            }
            return "جمع برنامه ریزی : " + totalPlanning_ + " ساعت ";
        }

        function totalPassed(records) {
            let totalPassed_ = 0;
            for (i = 0; i < records.length; i++) {
                if (records[i].classStatusId !== 1)
                    totalPassed_ += records[i].hduration;
            }
            return "جمع گذرانده یا در حال اجرا : " + totalPassed_ + " ساعت ";
        }

        function totalRejected(records) {
            let totalRejected_ = 0;
            for (i = 0; i < records.length; i++) {
                if (records[i].scoreStateId === 0)
                    totalRejected_ += records[i].hduration;
            }
            return "جمع مردودی یا غایبی : " + totalRejected_ + " ساعت ";
        }

        function totalAll(records) {
            let totalAll_ = 0;
            for (i = 0; i < records.length; i++) {
                totalAll_ += records[i].hduration;
            }
            return "جمع کل : " + totalAll_ + " ساعت ";
        }

        //***********************************
    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>