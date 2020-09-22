<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="application/javascript;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    
    function loadPersonnelInformationDetails() {
        this.tempPersonnel;
        this.tempListGrid_PersonnelTraining;


        // <<----------------------------------------------- Functions --------------------------------------------
        //{
            this.nationalCode_Info, this.personnelNo_Info, this.nationalCode_Training, this.personnelNo_Training, this.nationalCode_Need;

            this.set_PersonnelInfo_Details  = function set_PersonnelInfo_Details(selectedPersonnel) {

                if (selectedPersonnel !== undefined && selectedPersonnel !== null) {

                    let personnelId = selectedPersonnel.id !== undefined ? selectedPersonnel.id : 0;
                    let personnelNo = selectedPersonnel.personnelNo;
                    let nationalCode = selectedPersonnel.nationalCode;

                    if (this.PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_Info") {
                        //console.log(personnelNo,this.nationalCode_Info,this.personnelNo_Info,personnelNo,nationalCode);

                        if (personnelNo !== null && (this.nationalCode_Info === nationalCode || this.personnelNo_Info === personnelNo)) {
                            this.DynamicForm_PersonnelInfo.editRecord(this.tempPersonnel);
                        } else if (personnelNo !== null && (this.nationalCode_Info !== nationalCode || this.personnelNo_Info !== personnelNo)) {
                            this.DynamicForm_PersonnelInfo.clearValues();
                            this.nationalCode_Info = nationalCode;
                            this.personnelNo_Info = personnelNo;
                            me=this;
                            isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "/byPersonnelNo/" + personnelId +"/"+ personnelNo, "GET", null, function (resp) {

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

                                    me.tempPersonnel = currentPersonnel;
                                    me.DynamicForm_PersonnelInfo.editRecord(currentPersonnel);
                                }

                            }));
                        }
                    } else if (this.PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_Training") {
                        if (nationalCode !== null && (this.nationalCode_Training !== nationalCode || this.personnelNo_Training !== personnelNo)) {
                            this.nationalCode_Training = nationalCode;
                            this.personnelNo_Training = personnelNo;
                            this.RestDataSource_PersonnelTraining.fetchDataURL = classUrl + "personnel-training/" + nationalCode + "/" + personnelNo;
                            this.ListGrid_PersonnelTraining.invalidateCache();
                            this.ListGrid_PersonnelTraining.fetchData();
                        } else {
                            this.ListGrid_PersonnelTraining.setData(this.tempListGrid_PersonnelTraining);
                            this.ListGrid_PersonnelTraining.invalidateCache();
                        }
                    } else if (this.PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_NeedAssessment") {
                        if (this.nationalCode_Need !== nationalCode) {
                            this.nationalCode_Need = nationalCode;
                            call_needsAssessmentReports("0", true, selectedPersonnel);
                        }
                    }
                } else {
                    this.DynamicForm_PersonnelInfo.clearValues();
                    this.ListGrid_PersonnelTraining.setData([]);
                    this.nationalCode_Info = -1;
                    this.nationalCode_Training = -1;
                    this.nationalCode_Need = -1;
                }
            }

//!*****calculate total summary*****

            this.totalPlanning= function totalPlanning(records) {
                let totalPlanning_ = 0;
                for (let i = 0; i < records.length; i++) {
                    if (records[i].classStatusId === 1)
                        totalPlanning_ += records[i].hduration;
                }
                return "<spring:message code='planning.sum'/> : " + totalPlanning_ + " <spring:message code='hour'/> ";
            }

            this.totalPassed= function totalPassed(records) {
                let totalPassed_ = 0;
                for (let i = 0; i < records.length; i++) {
                    if (records[i].classStatusId !== 1)
                        totalPassed_ += records[i].hduration;
                }
                return "<spring:message code='passed.or.running.sum'/> : " + totalPassed_ + " <spring:message code='hour'/> ";
            }

            this.totalRejected= function totalRejected(records) {
                let totalRejected_ = 0;
                for (let i = 0; i < records.length; i++) {
                    if (records[i].scoreStateId === 403 || records[i].scoreStateId === 405 || records[i].scoreStateId === 449)
                        totalRejected_ += records[i].hduration;
                }
                return "<spring:message code='missing.or.absent.sum'/> : " + totalRejected_ + " <spring:message code='hour'/> ";
            }

            this.totalAll= function totalAll(records) {
                let totalAll_ = 0;
                for (let i = 0; i < records.length; i++) {
                    totalAll_ += records[i].hduration;
                }
                return "<spring:message code='total.sum'/> : " + totalAll_ + " <spring:message code='hour'/> ";
            }

//!***********************************

            this.show_ClassInformation= function show_ClassInformation(record, rowNum, colNum) {
                if (colNum === 1) {
                    this.window_class_Information.setTitle(record.courseTitle);
                    this.window_class_Information.show();

                    this.set_PersonnelInfo_CourseInfo();
                }
            }

//!***********************************

//!*****get selected course information*****
            this.courseId_Tab_Course, this.courseId_Tab_Records, this.classId_Tab_Class;

            this.set_PersonnelInfo_CourseInfo= function set_PersonnelInfo_CourseInfo() {

                if (this.ListGrid_PersonnelTraining.getSelectedRecord() !== null) {
                    let courseId = this.ListGrid_PersonnelTraining.getSelectedRecord().courseId;
                    let classId = this.ListGrid_PersonnelTraining.getSelectedRecord().id;

                    if (this.PersonnelInfo_ClassInfo_Tab.getSelectedTab().id === "ClassInfo_Tab_Course") {
                        if (courseId !== null && this.courseId_Tab_Course !== courseId) {
                            this.courseId_Tab_Course = courseId;
                            this.DynamicForm_PersonnelInfo_CourseInfo.clearValues();
                            me=this;
                            isc.RPCManager.sendRequest(TrDSRequest(personnelInformationUrl + "/findCourseByCourseId/" + courseId, "GET", null, function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                    let currentCourse = JSON.parse(resp.data);
                                    me.DynamicForm_PersonnelInfo_CourseInfo.editRecord(currentCourse);
                                }
                            }));
                        }
                    } else if (this.PersonnelInfo_ClassInfo_Tab.getSelectedTab().id === "ClassInfo_Tab_Class") {
                        if (classId !== null && this.classId_Tab_Class !== classId) {
                            this.classId_Tab_Class = classId;
                            this.DynamicForm_PersonnelInfo_ClassInfo.clearValues();
                            me=this;
                            isc.RPCManager.sendRequest(TrDSRequest(personnelInformationUrl + "/findClassByClassId/" + classId, "GET", null, function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    let currentClass = JSON.parse(resp.data);
                                    me.DynamicForm_PersonnelInfo_ClassInfo.editRecord(currentClass);
                                }
                            }));
                        }
                    } else if (this.PersonnelInfo_ClassInfo_Tab.getSelectedTab().id === "ClassInfo_Tab_Records") {
                        if (courseId !== null && this.courseId_Tab_Records !== courseId) {
                            this.courseId_Tab_Records = courseId;
                            this.RestDataSource_PersonnelInfo_class.fetchDataURL = personnelInformationUrl + "/findClassByCourseId/" + courseId;
                            this.ListGrid_PersonnelInfo_class.invalidateCache();
                            this.ListGrid_PersonnelInfo_class.fetchData();
                        }
                    }
                }
            }

            this.exportToExcel=function exportToExcel() {
                let nationalCode = null;
                let personnelNo = null;
                let restUrl = null;
                //ExportToFile.downloadExcelFromClient(this.ListGrid_PersonnelTraining, PersonnelInfoListGrid_PersonnelList, '', "اطلاعات پرسنل - آموزش ها");
                let tab = mainTabSet.tabs[mainTabSet.selectedTab];
                if (tab.title == '<spring:message code="personnel.information"/>') {
                    nationalCode = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().nationalCode;
                    personnelNo = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().personnelNo;
                    restUrl = classUrl + "personnel-training/" + nationalCode + "/" + personnelNo;
                    ExportToFile.downloadExcelRestUrl(null, this.ListGrid_PersonnelTraining, restUrl, 0, PersonnelInfoListGrid_PersonnelList, '', "اطلاعات پرسنل - آموزش ها", this.ListGrid_PersonnelTraining.getCriteria(), null);

                } else if (tab.title == '<spring:message code="class"/>') {
                    let fName = null;
                    let lName = null;
                    let personnelNo2 = null;
                    let titr = null;
                    let PageName = null;
                    if(StudentsLG_student) {
                        if ((( SelectedPersonnelsLG_student && listGridType == "SelectedPersonnelsLG_student" )
                            ||(PersonnelsLG_student && listGridType == "PersonnelsLG_student")
                            ||(PersonnelsRegLG_student && listGridType == "PersonnelsRegLG_student"))
                            && Object.keys(selectedRow).length != 0) {
                            fName = selectedRow.firstName;
                            lName = selectedRow.lastName;
                            nationalCode = selectedRow.nationalCode;
                            personnelNo = selectedRow.personnelNo;
                            personnelNo2 = selectedRow.personnelNo2;
                            if(listGridType == "SelectedPersonnelsLG_student")
                                PageName = "کلاس - فراگیر - افزودن فراگیر - افراد انتخاب شده - آموزش ها";
                            else
                                PageName = "کلاس - فراگیر - افزودن فراگیر - همه افراد - آموزش ها";
                        } else if(StudentsLG_student.getSelectedRecord() !== null) {
                            fName = StudentsLG_student.getSelectedRecord().student.firstName;
                            lName = StudentsLG_student.getSelectedRecord().student.lastName;
                            nationalCode = StudentsLG_student.getSelectedRecord().student.nationalCode;
                            personnelNo = StudentsLG_student.getSelectedRecord().student.personnelNo;
                            personnelNo2 = StudentsLG_student.getSelectedRecord().student.personnelNo2;
                            PageName = "کلاس - فراگیر - آموزش ها";
                        }
                        fName = fName ? "نام فراگیر: " + fName : "";
                        lName = lName ? "   نام خانوداگی فراگیر: " + lName: "";
                        nationalCode =  nationalCode ? "   کد ملی: " + nationalCode: "";
                        personnelNo = personnelNo ?  "   شماره پرسنلی: " + personnelNo : "";
                        personnelNo2 =  personnelNo2 ?  "   پرسنلی 6 رقمی: " + personnelNo2 : "";
                        titr = fName+lName+nationalCode+personnelNo+personnelNo2;
                        restUrl = classUrl + "personnel-training/" + nationalCode + "/" + personnelNo;
                        ExportToFile.downloadExcelRestUrl(null, this.ListGrid_PersonnelTraining, restUrl, 0, null, titr, PageName, this.ListGrid_PersonnelTraining.getCriteria(), null);

                    }
                }
            }
            this.tabSelectedPersonnelInfo_Tab=function tabSelectedPersonnelInfo_Tab(){
                let tab = mainTabSet.tabs[mainTabSet.selectedTab];
                if (tab.title == '<spring:message code="personnel.information"/>') {
                    this.set_PersonnelInfo_Details(PersonnelList_Tab.getSelectedTab().id === "PersonnelList_Tab_Personnel" ? PersonnelInfoListGrid_PersonnelList.getSelectedRecord() : PersonnelInfoListGrid_RegisteredPersonnelList.getSelectedRecord());
                } else if (tab.title == '<spring:message code="class"/>') {

                    //if (ClassStudentWin_student.isVisible()) {
                        this.set_PersonnelInfo_Details(selectedRecord_addStudent_class);
                    /*} else {
                        let record = {
                            firstName: StudentsLG_student.getSelectedRecord().student.firstName,
                            lastName: StudentsLG_student.getSelectedRecord().student.lastName,
                            postTitle: StudentsLG_student.getSelectedRecord().postTitle,
                            ccpArea: StudentsLG_student.getSelectedRecord().ccpArea,
                            ccpAffairs: StudentsLG_student.getSelectedRecord().ccpAffairs,
                            personnelNo: StudentsLG_student.getSelectedRecord().student.personnelNo,
                            nationalCode: StudentsLG_student.getSelectedRecord().nationalCode,
                            postCode: StudentsLG_student.getSelectedRecord().postCode,
                        }


                        this.set_PersonnelInfo_Details(record);
                    }*/

                }
            }
        //}

        // ------------------------------------------------- Functions ------------------------------------------>>

        // <<-------------------------------------- Create - ToolStripButton --------------------------------------
        //{
            this.ToolStrip_Personnel_Info_Training_Action = isc.ToolStrip.create({
                width: "100%",
                membersMargin: 5,
                members: [
                    isc.ToolStripButtonExcel.create({
                        click: function () {
                            this.exportToExcel();
                        }.bind(this)
                    })
                ]
            });

        //}
        // ---------------------------------------- Create - ToolStripButton ------------------------------------>>

        // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
        //{
            this.RestDataSource_PersonnelTraining = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true},
                    {name: "courseId"},
                    {name: "courseTitle"},
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

            this.ListGrid_PersonnelTraining = isc.TrLG.create({
                width: "100%",
                height: "100%",
                dataSource: this.RestDataSource_PersonnelTraining,
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
                        summaryFunction:function (records) {
                            return this.totalPlanning(records)
                        }.bind(this)
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
                        summaryFunction: function(records){
                            return this.totalPassed(records)
                        }.bind(this)
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
                        autoFitWidth: true,
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
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
                        summaryFunction: function(records){
                            return this.totalRejected(records)
                        }.bind(this)
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
                        summaryFunction: function(records){
                            return this.totalAll(records)
                        }.bind(this)
                    },
                    {
                        name: "erunType",
                        title: "<spring:message code="course_eruntype"/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }

                ],
                gridComponents: [this.ToolStrip_Personnel_Info_Training_Action, "filterEditor", "header", "body", "summaryRow"],
                cellClick: function (record, rowNum, colNum) {
                    this.show_ClassInformation(record, rowNum, colNum);
                }.bind(this),
                dataArrived: function() {
                    this.tempListGrid_PersonnelTraining = this.ListGrid_PersonnelTraining.data.getAllRows();
                }.bind(this)
            });

            this.RestDataSource_PersonnelInfo_class = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true},
                    {name: "titleClass"},
                    {name: "startDate"},
                    {name: "endDate"},
                    {name: "code"},
                    {name: "term.titleFa"},
                    {name: "course.titleFa"},
                    {name: "course.id"},
                    {name: "course.code"},
                    {name: "evaluation"},
                    {name: "institute.titleFa"},
                    {name: "studentCount"},
                    {name: "numberOfStudentEvaluation"},
                    {name: "classStatus"},
                    {name: "trainingPlaceIds"},
                    {name: "instituteId"},
                    {name: "workflowEndingStatusCode"},
                    {name: "workflowEndingStatus"}
                ]
            });

            this.ListGrid_PersonnelInfo_class = isc.TrLG.create({
                width: "100%",
                height: "100%",
                dataSource: this.RestDataSource_PersonnelInfo_class,
                canAddFormulaFields: false,
                autoFetchData: false,
                showFilterEditor: true,
                allowAdvancedCriteria: true,
                allowFilterExpressions: true,
                filterOnKeypress: true,
                sortField: 0,
                fields: [
                    {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        filterOnKeypress: false
                    },
                    {
                        name: "titleClass",
                        title: "titleClass",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        hidden: true,
                        filterOnKeypress: false
                    },
                    {
                        name: "course.titleFa",
                        title: "<spring:message code='course.title'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        sortNormalizer: function (record) {
                            return record.course.titleFa;
                        }.bind(this),
                        filterOnKeypress: false
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterOnKeypress: false
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterOnKeypress: false
                    },
                    {
                        name: "studentCount",
                        title: "<spring:message code='student.count'/>",
                        filterOperator: "iContains",
                        autoFitWidth: false,
                        filterOnKeypress: false
                    },
                    {
                        name: "institute.titleFa",
                        title: "<spring:message code='presenter'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        filterOnKeypress: false
                    },
                    {
                        name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                        valueMap: {
                            "1": "برنامه ریزی",
                            "2": "در حال اجرا",
                            "3": "پایان یافته"
                        }
                    },
                    {
                        name: "workflowEndingStatusCode",
                        title: "workflowCode",
                        align: "center",
                        filterOperator: "iContains",
                        hidden: true,
                        filterOnKeypress: false
                    },
                    {
                        name: "workflowEndingStatus",
                        title: "<spring:message code="ending.class.status"/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterOnKeypress: false
                    }
                ],
                gridComponents: [
                    isc.ToolStrip.create({
                        width: "100%",
                        membersMargin: 5,
                        members: [
                            isc.ToolStripButtonExcel.create({
                                click: function () {
                                    let courseId = me.ListGrid_PersonnelTraining.getSelectedRecord().courseId;
                                    let pageName = "لیست سوابق برگزاری دوره «" + me.ListGrid_PersonnelTraining.getSelectedRecord().courseTitle+"»";
                                    let restUrl = personnelInformationUrl + "/findClassByCourseId/" + courseId;
                                    ExportToFile.downloadExcelRestUrl(null, me.ListGrid_PersonnelInfo_class,  restUrl, 0, null, '', pageName, me.ListGrid_PersonnelInfo_class.getCriteria(), null);
                                }
                            })
                        ]
                    }),
                    "filterEditor",
                    "header",
                    "body"
                ]
            });

        //}
        // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

        // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------
        //{
            this.DynamicForm_PersonnelInfo = isc.DynamicForm.create({
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
                            canEdit: false
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
                        <%--{--%>
                        <%--name: "notExists",--%>
                        <%--title: "<spring:message code="boss"/> : ",--%>
                        <%--canEdit: false--%>
                        <%--},--%>
                        <%--{--%>
                        <%--name: "notExists",--%>
                        <%--title: "<spring:message code="connective"/> : ",--%>
                        <%--canEdit: false--%>
                        <%--},--%>
                        {
                            name: "employmentStatus",
                            title: "<spring:message code="employment.status"/> : ",
                            canEdit: false
                        },
                        {
                            name: "companyName",
                            title: "<spring:message code="company.name"/> : ",
                            canEdit: false
                        },
                        {
                            name: "department.hozeTitle",
                            title: "<spring:message code="complex"/> : ",
                            canEdit: false
                        },
                        {
                            name: "department.moavenatTitle",
                            title: "<spring:message code="assistance"/> : ",
                            canEdit: false
                        },
                        {
                            name: "department.omorTitle",
                            title: "<spring:message code="affairs"/> : ",
                            canEdit: false
                        },
                        {
                            name: "department.vahedTitle",
                            title: "<spring:message code="unit"/> : ",
                            canEdit: false
                        },
                        {
                            name: "department.ghesmatTitle",
                            title: "<spring:message code="section"/> : ",
                            canEdit: false
                        },
                        {
                            name: "post.job.code",
                            title: "<spring:message code="job.code"/> : ",
                            canEdit: false
                        },
                        {
                            name: "post.job.titleFa",
                            title: "<spring:message code="job.title"/> : ",
                            canEdit: false
                        },
                        {
                            name: "post.code",
                            title: "<spring:message code="post.code"/> : ",
                            canEdit: false
                        },
                        {
                            name: "post.titleFa",
                            title: "<spring:message code="post.title"/> : ",
                            canEdit: false
                        },
                        {
                            name: "post.postGrade.code",
                            title: "<spring:message code="post.code"/> : ",
                            canEdit: false
                        },
                        {
                            name: "post.postGrade.titleFa",
                            title: "<spring:message code="post.grade"/> : ",
                            canEdit: false
                        },
                        <%--{--%>
                        <%--name: "notExists",--%>
                        <%--title: "<spring:message code="job.group"/> : ",--%>
                        <%--canEdit: false--%>
                        <%--},--%>
                        <%--{--%>
                        <%--name: "notExists",--%>
                        <%--title: "<spring:message code="business.class"/> : ",--%>
                        <%--canEdit: false--%>
                        <%--},--%>
                        {
                            name: "personnelNo2",
                            title: "<spring:message code="personnel.code.six.digit"/> : ",
                            canEdit: false
                        },
                        <%--{--%>
                        <%--name: "notExists",--%>
                        <%--title: "<spring:message code="post.group"/> : ",--%>
                        <%--canEdit: false--%>
                        <%--},--%>
                        <%--{--%>
                        <%--name: "notExists",--%>
                        <%--title: "<spring:message code="person.basic"/> : ",--%>
                        <%--canEdit: false--%>
                        <%--},--%>
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
                        <%--{--%>
                        <%--name: "notExists",--%>
                        <%--title: "<spring:message code="agents"/> : ",--%>
                        <%--canEdit: false--%>
                        <%--},--%>
                        {
                            name: "workTurnTitle",
                            title: "<spring:message code="division.of.staff"/> : ",
                            canEdit: false
                        },
                        {
                            name: "militaryStatus",
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
                            name: "phone",
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

            this.DynamicForm_PersonnelInfo_CourseInfo = isc.DynamicForm.create({
                numCols: 6,
                colWidths: ["1%", "1%", "1%", "1%", "1%", "1%"],
                cellPadding: 3,
                fields:
                    [
                        {
                            name: "header_BasicInfo",
                            type: "HeaderItem",
                            defaultValue: "<spring:message code="basic.information"/>",
                            startRow: true,
                            colSpan: 6,
                            cellStyle: "lineField"
                        },
                        {
                            name: "titleFa",
                            title: "<spring:message code="course.title"/> : ",
                            canEdit: false
                        },
                        {
                            name: "code",
                            title: "<spring:message code="course.code"/> : ",
                            canEdit: false
                        },
                        {
                            name: "theoryDuration",
                            title: "<spring:message code="course_theoryDuration"/> : ",
                            canEdit: false
                        },
                        {
                            name: "category.titleFa",
                            title: "<spring:message code="group"/> : ",
                            canEdit: false
                        },
                        {
                            name: "subCategory.titleFa",
                            title: "<spring:message code="subcategory"/> : ",
                            canEdit: false
                        },
                        {
                            name: "erunType.titleFa",
                            title: "<spring:message code="course_eruntype"/> : ",
                            canEdit: false
                        },
                        {
                            name: "elevelType.titleFa",
                            title: "<spring:message code="cousre_elevelType"/> : ",
                            canEdit: false
                        },
                        {
                            name: "etheoType.titleFa",
                            title: "<spring:message code="course_etheoType"/> : ",
                            canEdit: false
                        },
                        {
                            name: "etechnicalType.titleFa",
                            title: "<spring:message code="course_etechnicalType"/> : ",
                            canEdit: false
                        },
                        {
                            name: "evaluation",
                            title: "<spring:message code="evaluation.level"/> : ",
                            valueMap: {
                                "1": "واکنش",
                                "2": "یادگیری",
                                "3": "رفتاری",
                                "4": "نتایج"
                            },
                            canEdit: false
                        },
                        {
                            name: "behavioralLevel",
                            title: "<spring:message code="behavioral.Level"/> : ",
                            valueMap: {
                                "1": "مشاهده",
                                "2": "مصاحبه",
                                "3": "کار پروژه ای"
                            },
                            canEdit: false
                        },
                        {
                            name: "scoringMethod",
                            title: "<spring:message code="scoring.Method"/> : ",
                            valueMap: {
                                "1": "ارزشی",
                                "2": "نمره از صد",
                                "3": "نمره از بیست",
                                "4": "بدون نمره"
                            },
                            canEdit: false
                        },
                        {
                            name: "minTeacherDegree",
                            title: "<spring:message code="course_minTeacherDegree"/> : ",
                            canEdit: false
                        },
                        {
                            name: "minTeacherExpYears",
                            title: "<spring:message code="course_minTeacherExpYears"/> : ",
                            canEdit: false
                        },
                        {
                            name: "minTeacherEvalScore",
                            title: "<spring:message code="course_minTeacherEvalScore"/> : ",
                            canEdit: false
                        },
                        {
                            name: "header_MainObjective",
                            type: "HeaderItem",
                            defaultValue: "<spring:message code="course_mainObjective"/>",
                            startRow: true,
                            colSpan: 6,
                            cellStyle: "lineField"
                        },
                        {
                            name: "mainObjective",
                            title: "",
                            type: "TextAreaItem",
                            startRow: true,
                            colSpan: 5,
                            rowSpan: 4,
                            height: "*",
                            width: "100%",
                            length: 5000,
                            canEdit: false
                        },
                        {
                            name: "header_goals",
                            type: "HeaderItem",
                            defaultValue: "<spring:message code="course.goals"/>",
                            colSpan: 6,
                            startRow: true,
                            cellStyle: "lineField"
                        },
                        {
                            name: "goals",
                            title: "",
                            type: "TextAreaItem",
                            startRow: true,
                            colSpan: 5,
                            rowSpan: 4,
                            height: "*",
                            width: "100%",
                            length: 5000,
                            canEdit: false
                        },
                        {
                            name: "header_preCourses",
                            type: "HeaderItem",
                            defaultValue: "<spring:message code="prerequisites"/>",
                            colSpan: 6,
                            startRow: true,
                            cellStyle: "lineField"
                        },
                        {
                            name: "preCourses",
                            title: "",
                            type: "TextAreaItem",
                            startRow: true,
                            colSpan: 5,
                            rowSpan: 4,
                            height: "*",
                            width: "100%",
                            length: 5000,
                            canEdit: false
                        }
                    ]
            });

            this.DynamicForm_PersonnelInfo_ClassInfo = isc.DynamicForm.create({
                numCols: 6,
                colWidths: ["1%", "1%", "1%", "1%", "1%", "1%"],
                cellPadding: 3,
                fields:
                    [
                        {
                            name: "header_BasicInfo",
                            type: "HeaderItem",
                            defaultValue: "<spring:message code="basic.information"/>",
                            startRow: true,
                            colSpan: 6,
                            cellStyle: "lineField"
                        },
                        {
                            name: "titleClass",
                            title: "<spring:message code="class.title"/> : ",
                            canEdit: false
                        },
                        {
                            name: "code",
                            title: "<spring:message code="class.code"/> : ",
                            canEdit: false
                        },
                        {
                            name: "hduration",
                            title: "<spring:message code="duration"/> : ",
                            canEdit: false,
                            mapValueToDisplay: function (value) {
                                if (isNaN(value)) {
                                    return "";
                                }
                                return value + " ساعت ";
                            }.bind(this)
                        },
                        {
                            name: "minCapacity",
                            title: "<spring:message code="minCapacity"/> : ",
                            canEdit: false
                        },
                        {
                            name: "maxCapacity",
                            title: "<spring:message code="maxCapacity"/> : ",
                            canEdit: false
                        },
                        {
                            name: "teacher",
                            title: "<spring:message code="teacher"/> : ",
                            canEdit: false
                        },
                        {
                            name: "supervisor",
                            title: "<spring:message code="supervisor"/> : ",
                            valueMap: {
                                1: "آقای دکتر سعیدی",
                                2: "خانم شاکری",
                                3: "خانم اسماعیلی",
                                4: "خانم احمدی",
                            },
                            canEdit: false
                        },
                        {
                            name: "institute.titleFa",
                            title: "<spring:message code="institute"/> : ",
                            canEdit: false
                        },
                        {
                            name: "classStatus",
                            title: "<spring:message code="class.status"/> : ",
                            valueMap: {
                                "1": "برنامه ریزی",
                                "2": "در حال اجرا",
                                "3": "پایان یافته",
                            },
                            canEdit: false
                        },
                        {
                            name: "teachingType",
                            title: "<spring:message code="teaching.type"/> : ",
                            valueMap: [
                                "حضوری",
                                "غیر حضوری",
                                "مجازی",
                                "عملی و کارگاهی"
                            ],
                            canEdit: false
                        },
                        {
                            name: "topology",
                            title: "<spring:message code="place.shape"/> : ",
                            valueMap: {
                                "1": "U شکل",
                                "2": "عادی",
                                "3": "مدور",
                                "4": "سالن"
                            },
                            canEdit: false
                        },
                        {
                            name: "scoringMethod",
                            title: "<spring:message code="scoring.Method"/> : ",
                            valueMap: {
                                "1": "ارزشی",
                                "2": "نمره از صد",
                                "3": "نمره از بیست",
                                "4": "بدون نمره"
                            },
                            canEdit: false
                        },
                        {
                            name: "header_Time",
                            type: "HeaderItem",
                            defaultValue: "<spring:message code="class.meeting.time"/>",
                            startRow: true,
                            colSpan: 6,
                            cellStyle: "lineField"
                        },
                        {
                            name: "term.titleFa",
                            title: "<spring:message code="term"/> : ",
                            canEdit: false
                        },
                        {
                            name: "startDate",
                            title: "<spring:message code="start.date"/> : ",
                            canEdit: false
                        },
                        {
                            name: "endDate",
                            title: "<spring:message code="end.date"/> : ",
                            canEdit: false
                        },
                        {
                            name: "teachingBrand",
                            title: "<spring:message code="teaching.method"/> : ",
                            valueMap: {
                                1: "تمام وقت",
                                2: "نیمه وقت",
                                3: "پاره وقت"
                            },
                            canEdit: false
                        },
                        {
                            name: "classSessionTimes",
                            title: "<spring:message code="sessions.time"/> : ",
                            startRow: true,
                            colSpan: 3,
                            canEdit: false
                        },
                        {
                            name: "classDays",
                            title: "<spring:message code="week.days"/> : ",
                            startRow: true,
                            colSpan: 3,
                            canEdit: false
                        }
                    ]
            });

        //}
        // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>

        // <<-------------------------------------- Create - TabSet & Tab -----------------------------------------
        //{
            this.VLayout_PersonnelInfo_Detail = isc.VLayout.create({
                width: "100%",
                height: "100%",
                membersMargin: 5,
                members: [this.DynamicForm_PersonnelInfo]
            });

            this.PersonnelInfo_ClassInfo_Tab = isc.TabSet.create({
                //ID: "PersonnelInfo_ClassInfo_Tab",
                width: "100%",
                height: 500,
                tabBarPosition: "top",
                tabs: [
                    {
                        id: "ClassInfo_Tab_Course",
                        title: "<spring:message code="course"/>",
                        pane: this.DynamicForm_PersonnelInfo_CourseInfo
                    },
                    {
                        id: "ClassInfo_Tab_Class",
                        title: "<spring:message code="class"/>",
                        pane: this.DynamicForm_PersonnelInfo_ClassInfo
                    },
                    {
                        id: "ClassInfo_Tab_Records",
                        title: "<spring:message code="course.records"/>",
                        pane: this.ListGrid_PersonnelInfo_class
                    }
                ],
                tabSelected: function () {
                    this.set_PersonnelInfo_CourseInfo();
                }.bind(this)
            });

            this.window_class_Information = isc.Window.create({
                title: "",
                width: "70%",
                minWidth: 500,
                height: 500,
                visibility: "hidden",
                items: [this.PersonnelInfo_ClassInfo_Tab]
            });

            this.PersonnelInfo_Tab = isc.TabSet.create({
                //ID: "PersonnelInfo_Tab",
                tabBarPosition: "top",

                tabs: [
                    {
                        id: "PersonnelInfo_Tab_Info",
                        title: "<spring:message code="personnelReg.baseInfo"/>",
                        pane: this.VLayout_PersonnelInfo_Detail,

                    },
                    {
                        id: "PersonnelInfo_Tab_Training",
                        title: "<spring:message code="trainings"/>",
                        pane: this.ListGrid_PersonnelTraining,
                    },
                    {
                        id: "PersonnelInfo_Tab_NeedAssessment",
                        title: "<spring:message code="competence"/>",
                        pane: isc.ViewLoader.create({autoDraw: true, viewURL: "web/needsAssessment-reports"}),
                    }

                ],
                tabSelected: function () {
                    //console.log(me);
                    this.tabSelectedPersonnelInfo_Tab();
                }.bind(this)
            });
      //  }
        // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

        // <<------------------------------------------- Create - Layout ------------------------------------------
        {

        }
        // ---------------------------------------------- Create - Layout ---------------------------------------->>



    }
    // </script>