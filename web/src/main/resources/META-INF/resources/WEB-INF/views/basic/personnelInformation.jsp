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
                        defaultValue: "<spring:message code="personal.information"/>",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "fullName",
                        title: "<spring:message code="full.name"/> : ",
                        canEdit: false,
                    },
                    {
                        name: "personnelNo",
                        title: "<spring:message code="personnel.code"/> : ",
                        canEdit: false
                    },
                    {
                        name: "fatherName",
                        title: "<spring:message code="father.name"/> : ",
                        canEdit: false
                    },
                    {
                        name: "birth",
                        title: "<spring:message code="birth"/> : ",
                        canEdit: false
                    },
                    {
                        name: "nationalCode",
                        title: "<spring:message code="national.code"/> : ",
                        canEdit: false
                    },
                    {
                        name: "birthCertificateNo",
                        title: "<spring:message code="birth.certificate.no"/> : ",
                        canEdit: false
                    },
                    {
                        name: "educationLevelTitle",
                        title: "<spring:message code="education"/> : ",
                        canEdit: false
                    },
                    {
                        name: "gender",
                        title: "<spring:message code="gender"/> : ",
                        canEdit: false
                    },
                    {
                        name: "workYears",
                        title: "<spring:message code="current.education"/> : ",
                        canEdit: false
                    },
                    {
                        name: "header_CompanyInfo",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="company.profile"/>",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="boss"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="connective"/> : ",
                        canEdit: false
                    },
                    {
                        name: "employmentStatus",
                        title: "<spring:message code="employment.status"/> : ",
                        canEdit: false
                    },
                    {
                        name: "ccpAssistant",
                        title: "<spring:message code="area"/> : ",
                        canEdit: false
                    },
                    {
                        name: "ccpAffairs",
                        title: "<spring:message code="unit"/> : ",
                        canEdit: false
                    },
                    {
                        name: "ccpSection",
                        title: "<spring:message code="section"/> : ",
                        canEdit: false
                    },
                    {
                        name: "companyName",
                        title: "<spring:message code="branch"/> : ",
                        canEdit: false
                    },
                    {
                        name: "postTitle",
                        title: "<spring:message code="job"/> : ",
                        canEdit: false
                    },
                    {
                        name: "jobTitle",
                        title: "<spring:message code="post"/> : ",
                        canEdit: false
                    },
                    {
                        name: "postGradeTitle",
                        title: "<spring:message code="post.grade"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="job.group"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="business.class"/> : ",
                        canEdit: false
                    },
                    {
                        name: "personnelNo2",
                        title: "<spring:message code="personnel.code.six.digit"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="post.group"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="person.basic"/> : ",
                        canEdit: false
                    },
                    {
                        name: "employmentTypeTitle",
                        title: "<spring:message code="employment.type"/> : ",
                        canEdit: false
                    },
                    {
                        name: "employmentDate",
                        title: "<spring:message code="employment.date"/> : ",
                        canEdit: false
                    },
                    {
                        name: "workPlaceTitle",
                        title: "<spring:message code="geographical.location.of.service"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="agents"/> : ",
                        canEdit: false
                    },
                    {
                        name: "workTurnTitle",
                        title: "<spring:message code="division.of.staff"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="military"/> : ",
                        canEdit: false
                    },
                    {
                        name: "header_ContactInfo",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="contact.information"/>",
                        colSpan: 6,
                        startRow: true,
                        cellStyle: "lineField"
                    },
                    {
                        name: "tel",
                        title: "<spring:message code="telephone"/> : ",
                        canEdit: false
                    },
                    {
                        name: "mobile",
                        title: "<spring:message code="cellPhone"/> : ",
                        canEdit: false
                    },
                    {
                        name: "email",
                        title: "<spring:message code="email"/> : ",
                        canEdit: false
                    },
                    {
                        name: "address",
                        title: "<spring:message code="address"/> : ",
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
                    title: "<spring:message code="personnelReg.baseInfo"/>",
                    pane: VLayout_PersonnelInfo_Detail

                },
                {
                    id: "PersonnelInfo_Tab_Training",
                    title: "<spring:message code="trainings"/>",
                    pane: ListGrid_PersonnelTraining
                },
                {
                    id: "PersonnelInfo_Tab_NeedAssessment",
                    title: "<spring:message code="competence"/>",
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
        var nationalCode_Info, nationalCode_Training, nationalCode_Need;
        function set_PersonnelInfo_Details() {

            if (PersonnelInfoListGrid_PersonnelList.getSelectedRecord() !== null) {

                let personnelNo = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().personnelNo;
                let nationalCode = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().nationalCode;

                if (PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_Info") {
                    if (personnelNo !== null && nationalCode_Info !== nationalCode) {
                        nationalCode_Info = nationalCode;
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
                    if (nationalCode !== null && nationalCode_Training !== nationalCode) {
                        nationalCode_Training = nationalCode;
                        RestDataSource_PersonnelTraining.fetchDataURL = classUrl + "personnel-training/" + nationalCode;
                        ListGrid_PersonnelTraining.invalidateCache();
                        ListGrid_PersonnelTraining.fetchData();
                    }
                } else if (PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_NeedAssessment") {
                    if(nationalCode_Need !== nationalCode)
                    {
                        nationalCode_Need = nationalCode
                        call_needsAssessmentReports(PersonnelInfoListGrid_PersonnelList);
                    }
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