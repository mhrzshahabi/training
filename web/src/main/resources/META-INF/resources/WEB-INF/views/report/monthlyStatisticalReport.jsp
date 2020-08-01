<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        var RestDataSource_Complex_MSReport = isc.TrDS.create({
            fields: [
                {name: "complexTitle", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: departmentUrl + "/all-field-values?fieldName=complexTitle"
        });

        var RestDataSource_Assistant_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpAssistant", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
        });

        var RestDataSource_Affairs_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpAffairs", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAffairs"
        });

        var RestDataSource_Section_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpSection", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpSection"
        });

        var RestDataSource_Unit_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpUnit", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: departmentUrl +  "/all-field-values?fieldName=ccpUnit"
        });

        var RestDataSource_MSReport = isc.TrDS.create({
            fields:
                [
                    {name: "ccp_unit"},
                    {name: "present"},
                    {name: "Overtime"},
                    {name: "UnjustifiedAbsence"},
                    {name: "AcceptableAbsence"}
                ]
        });


        var RestDataSource_PostGrade_MSReport = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "code",
                    title: "<spring:message code="post.grade.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: viewPostGradeUrl + "/iscList"
        });

        var RestDataSource_Student_MSReport = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "fullName", title: "<spring:message code="full.name"/>"},
                {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
                {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
                {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
                {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
                {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: studentUrl + "spec-list/"
        });

        var RestDataSource_Course_MSReport = isc.TrDS.create({
            fields: [
                {name: "id", type: "Integer", primaryKey: true},
                {name: "code", title: "<spring:message code="corse_code"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "titleFa", title: "<spring:message code="course_fa_name"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "titleEn", title: "<spring:message code="course_en_name"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "categoryId"},
                {name: "subCategory.titleFa"},
                {name: "erunType.titleFa"},
                {name: "elevelType.titleFa"},
                {name: "etheoType.titleFa"},
                {name: "theoryDuration"},
                {name: "etechnicalType.titleFa"},
                {name: "minTeacherDegree"},
                {name: "minTeacherExpYears"},
                {name: "minTeacherEvalScore"},
                // {name: "know   ledge"},
                // {name: "skill"},
                // {name: "attitude"},
                {name: "needText"},
                {name: "description"},
                {name: "workflowStatus"},
                {name: "workflowStatusCode"},
                {name: "hasGoal"},
                {name: "hasSkill"},
                {
                    name: "evaluation",
                },
                {
                    name: "behavioralLevel",
                }
                // {name: "version"},
            ],
            fetchDataURL: courseUrl + "spec-list",
        });

        var RestDataSource_Class_MSReport = isc.TrDS.create({
            fields: [
                {name: "id", type: "Integer", primaryKey: true},
                {name: "code", title: "<spring:message code="class.code"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "titleClass", title: "<spring:message code="course_fa_name"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "startDate", title: "<spring:message code="start.date"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "endDate", title: "<spring:message code="end.date"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "studentCount", title: "<spring:message code="student.count"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "course.titleFa", title: "<spring:message code="course.title"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "teacher.personality.lastNameFa", title: "<spring:message code="course_fa_name"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "teacher", title: "<spring:message code="teacher"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"},
                {name: "group", title: "<spring:message code="group"/>",
                    align: "center",
                    autoFitWidth: true,
                    filterOperator: "iContains"}
            ],
            fetchDataURL: classUrl + "spec-list"
        });


        var ListGrid_MSReport = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_MSReport,
            canAddFormulaFields: false,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
            showGridSummary: true,
            initialSort: [
                {property: "complex_title", direction: "ascending"},
                {property: "ccp_assistant", direction: "ascending"},
                {property: "ccp_affairs", direction: "ascending"},
                {property: "ccp_unit", direction: "ascending"},
                {property: "ccp_section", direction: "ascending"}
            ],
            fields: [
                {
                    name: "complex_title",
                    title: "<spring:message code="complex"/>",
                    align: "center",
                    filterOperator: "iContains",
                    showGridSummary: true,
                    //summaryFunction: "totalSummary()"
                },
                {
                    name: "ccp_assistant",
                    title: "<spring:message code="assistance"/>",
                    align: "center",
                    filterOperator: "iContains",
                    showGridSummary: true,
                    //summaryFunction: "totalSummary()"
                },
                {
                    name: "ccp_affairs",
                    title: "<spring:message code="affairs"/>",
                    align: "center",
                    filterOperator: "iContains",
                    showGridSummary: true,
                    //summaryFunction: "totalSummary()"
                },
                {
                    name: "ccp_unit",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains",
                    showGridSummary: true,
                    //summaryFunction: "totalSummary()"
                },
                {
                    name: "ccp_section",
                    title: "<spring:message code="section"/>",
                    align: "center",
                    filterOperator: "iContains",
                    showGridSummary: true,
                    summaryFunction: "totalSummary()"
                },
                {
                    name: "present",
                    title: "<spring:message code="sum.of.present.hours"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalPresent(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "overtime",
                    title: "<spring:message code="total.hours.of.overtime"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalOvertime(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                },
                {
                    name: "unjustifiedAbsence",
                    title: "<spring:message code="sum.of.unjustified.absence.hours"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalUnjustifiedAbsence(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                }, {
                    name: "acceptableAbsence",
                    title: "<spring:message code="sum.of.justified.absence.hours"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalAcceptableAbsence(records)",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9|:]"
                    }
                }
            ]
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------
    {
        //*****report main dynamic form*****
        var DynamicForm_MSReport = isc.DynamicForm.create({
            width: "280px",
            height: "100%",
            overflow:"auto",
            padding: 5,
            cellPadding: 5,
            numCols: 2,
            colWidths: ["30%", "69%","1%"],
            fields: [
                {
                    name: "firstDate_MSReport",
                    title: "<spring:message code="start.date"/>",
                    ID: "firstDate_MSReport",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('firstDate_MSReport', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        checkFirstDate();
                        MSReport_check_date();
                    }
                },
                {
                    name: "secondDate_MSReport",
                    title: "<spring:message code="end.date"/>",
                    ID: "secondDate_MSReport",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('secondDate_MSReport', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        checkSecondDate();
                        MSReport_check_date();
                    }

                },
                {
                    name: "complex_MSReport",
                    ID: "complex_MSReport",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="complex"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Complex_MSReport,
                    textAlign: "center",
                    valueField: "value",
                    displayField: "value"
                },
                {
                    name: "Assistant",
                    ID: "Assistant",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="assistance"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Assistant_MSReport,
                    textAlign: "center",
                    valueField: "value",
                    displayField: "value"
                },
                {
                    name: "Affairs",
                    ID: "Affairs",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="affairs"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Affairs_MSReport,
                    textAlign: "center",
                    valueField: "value",
                    displayField: "value"
                },
                {
                    name: "Unit",
                    ID: "Unit",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="unit"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Unit_MSReport,
                    textAlign: "center",
                    valueField: "value",
                    displayField: "value"
                },
                {
                    name: "Section",
                    ID: "Section",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="section"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Section_MSReport,
                    textAlign: "center",
                    valueField: "value",
                    displayField: "value"
                },
                {type: "SpacerItem"},
                {
                    name: "Technical",
                    //emptyDisplayValue: "همه",
                    operator: "inSet",
                    multiple: true,
                    title: "نوع تخصص",
                    type: "SelectItem",
                    //displayField: "ccpSection",
                    //valueField: "ccpSection",
                    textAlign: "center",
                    //pickListFields: [
                    //    {name: "ccpSection"}
                    //],
                    //filterFields: ["ccpSection"],
                    valueMap: {
                        "1": "عمومی",
                        "2": "فنی",
                        "3": "مدیریتی",
                    },
                },
                {
                    name: "Course",
                    //emptyDisplayValue: "همه",
                    operator: "inSet",
                    multiple: true,
                    title: "<spring:message code="course"/>",
                    autoFetchData: false,
                    //useClientFiltering: true,
                    optionDataSource: RestDataSource_Course_MSReport,
                    displayField: "code",
                    valueField: "id",
                    textAlign: "center",
                    pickListWidth: 600,
                    pickListFields: [
                        {name: "code"},
                        {name: "titleFa"},
                        {name: "titleEn"},
                    ],
                    filterFields: ["code","titleFa","titleEn"]
                },
                {
                    name: "Class",
                    //emptyDisplayValue: "همه",
                    operator: "inSet",
                    multiple: true,
                    title: "<spring:message code="class"/>",
                    autoFetchData: false,
                    //useClientFiltering: true,
                    optionDataSource: RestDataSource_Class_MSReport,
                    displayField: "code",
                    valueField: "id",
                    textAlign: "center",
                    pickListWidth: 1200,
                    pickListFields: [
                        {name: "code"},
                        {name: "course.titleFa"},
                        {name: "startDate"},
                        {name: "endDate"},
                        {name: "studentCount"},
                        {name: "group"},
                        {name: "teacher",sortNormalizer(record){
                                return record.teacher.personality.lastNameFa;
                            },},
                    ],
                    filterFields: ["code","course.titleFa","startDate","endDate","group","teacher"]
                },
                {
                    name: "PostGrade",
                    //emptyDisplayValue: "همه",
                    title: "<spring:message code="post.grade"/>",
                    optionDataSource: RestDataSource_PostGrade_MSReport,
                    autoFetchData: false,
                    pickListWidth: 300,
                    operator: "inSet",
                    multiple: true,
                    type: "SelectItem",
                    textMatchStyle: "substring",
                    valueField: "id",
                    displayField: "titleFa",
                    textAlign: "center",
                },
                {
                    name: "Personnel",
                    //emptyDisplayValue: "همه",
                    operator: "inSet",
                    multiple: true,
                    title: "<spring:message code="student"/>",
                    autoFetchData: false,
                    //useClientFiltering: true,
                    optionDataSource: RestDataSource_Student_MSReport,
                    displayField: "fullName",
                    valueField: "id",
                    textAlign: "center",
                    pickListWidth: 1200,
                    pickListFields: [
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
                        {name: "ccpUnit"},
                    ],
                    filterFields: ["firstName","lastName","nationalCode","companyName","personnelNo","personnelNo2","postTitle","ccpArea","ccpAssistant","ccpAffairs","ccpSection","ccpUnit"]
                },
                {
                    type: "button",
                    width: "100%",
                    height: 30,
                    colSpan: 2,
                    align: "left",
                    title: "<spring:message code="search"/>",
                    click: function () {
                        searchResult();
                    }
                },
                {
                    type: "button",
                    width: "100%",
                    height: 30,
                    colSpan: 2,
                    align: "left",
                    title: "<spring:message code="global.form.print.excel"/>",
                    click: function () {
                        // console.log(ListGrid_StudentClass_StudentClassJSP.getFields().subList(1,10));
                        // exportToExcel(ListGrid_StudentClass_StudentClassJSP.getFields().subList(1,10) ,ListGrid_StudentClass_StudentClassJSP.getData().localData)
                        ExportToFile.downloadExcelFromClient(ListGrid_MSReport,null,"","گزارش آماری ماهیانه");
                    }
                },
            ]
        });


        var VLayout_DynamicForm_MSReport = isc.VLayout.create({
            width: "280px",
            height: "100%",
            members: [DynamicForm_MSReport]
        });

        var VLayout_ListGrid_MSReport = isc.VLayout.create({
            width: "95%",
            height: "100%",
            border: "1px solid gray",
            members: [ListGrid_MSReport]
        });

        var Hlayout_Body_MSReport = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [VLayout_DynamicForm_MSReport, VLayout_ListGrid_MSReport]
        })

    }
    // ----------------------------------- Create - DynamicForm & Window & Layout --------------------------->>

    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****check date is valid*****
        function checkFirstDate() {

            DynamicForm_MSReport.clearFieldErrors("firstDate_MSReport", true);

            if (DynamicForm_MSReport.getValue("firstDate_MSReport") === undefined || !checkDate(DynamicForm_MSReport.getValue("firstDate_MSReport"))) {
                DynamicForm_MSReport.addFieldErrors("firstDate_MSReport", "<spring:message code="msg.correct.date"/>", true);
            } else {
                DynamicForm_MSReport.clearFieldErrors("firstDate_MSReport", true);
            }
        }

        function checkSecondDate() {

            DynamicForm_MSReport.clearFieldErrors("secondDate_MSReport", true);

            if (DynamicForm_MSReport.getValue("secondDate_MSReport") === undefined || !checkDate(DynamicForm_MSReport.getValue("secondDate_MSReport"))) {
                DynamicForm_MSReport.addFieldErrors("secondDate_MSReport", "<spring:message code="msg.correct.date"/>", true);
            } else {
                DynamicForm_MSReport.clearFieldErrors("secondDate_MSReport", true);
            }
        }

        function MSReport_check_date() {

            if (DynamicForm_MSReport.getValue("firstDate_MSReport") !== undefined && DynamicForm_MSReport.getValue("secondDate_MSReport") !== undefined) {
                if (DynamicForm_MSReport.getValue("firstDate_MSReport") > DynamicForm_MSReport.getValue("secondDate_MSReport")) {
                    DynamicForm_MSReport.addFieldErrors("firstDate_MSReport", "<spring:message code="start.date.must.be.shorter.than.end.date"/>");
                    DynamicForm_MSReport.addFieldErrors("secondDate_MSReport", "<spring:message code="start.date.must.be.shorter.than.end.date"/> ");
                } else {
                    DynamicForm_MSReport.clearFieldErrors("firstDate_MSReport", true);
                    DynamicForm_MSReport.clearFieldErrors("secondDate_MSReport", true);
                }
            }

        }

        //***************************

        //*****search report result*****
        function searchResult() {

            checkSecondDate();
            checkFirstDate();
            MSReport_check_date();

            if (DynamicForm_MSReport.hasErrors())
                return;

            var reportParameters = {
                firstDate: firstDate_MSReport._value.replace(/\//g, "^"),
                secondDate: secondDate_MSReport._value.replace(/\//g, "^"),
                complex_title: DynamicForm_MSReport.getValue("complex_MSReport") !== undefined ? DynamicForm_MSReport.getValue("complex_MSReport") : "همه",
                assistant: DynamicForm_MSReport.getValue("Assistant") !== undefined ? DynamicForm_MSReport.getValue("Assistant") : "همه",
                affairs: DynamicForm_MSReport.getValue("Affairs") !== undefined ? DynamicForm_MSReport.getValue("Affairs") : "همه",
                section: DynamicForm_MSReport.getValue("Section") !== undefined ? DynamicForm_MSReport.getValue("Section") : "همه",
                unit: DynamicForm_MSReport.getValue("Unit") !== undefined ? DynamicForm_MSReport.getValue("Unit") : "همه",
                technical: DynamicForm_MSReport.getValue("Technical") != null ? '*'+(DynamicForm_MSReport.getValue("Technical")?.toString()??'')+'@' : "*@",
                course: DynamicForm_MSReport.getValue("Course") != null ? '*'+(DynamicForm_MSReport.getValue("Course")?.toString()??'')+'@' : "*@",
                class: DynamicForm_MSReport.getValue("Class") != null ? '*'+(DynamicForm_MSReport.getValue("Class")?.toString()??'')+'@' : "*@",
                postGrade: DynamicForm_MSReport.getValue("PostGrade") != null ? '*'+(DynamicForm_MSReport.getValue("PostGrade")?.toString()??'')+'@' : "*@",
                personnel: DynamicForm_MSReport.getValue("Personnel") != null ? '*'+(DynamicForm_MSReport.getValue("Personnel")?.toString()??'')+'@' : "*@"
            };


            RestDataSource_MSReport.fetchDataURL = monthlyStatistical + "list" + "/" + JSON.stringify(reportParameters);
            ListGrid_MSReport.invalidateCache();
            ListGrid_MSReport.fetchData();

        }

        //*****calculate total summary*****
        function totalSummary() {
            return "جمع کل :";
        }

        function totalPresent(records) {

            let hours = 0;
            let minutes = 0;
            for (let i = 0; i < records.length; i++) {
                if (records[i].present !== "0") {
                    hours += parseInt(records[i].present.split(":")[0]);
                    minutes += parseInt(records[i].present.split(":")[1]);
                }
            }

            hours += Math.floor(minutes / 60);
            minutes = minutes % 60;

            return String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0');
        }

        function totalOvertime(records) {

            let hours = 0;
            let minutes = 0;
            for (let i = 0; i < records.length; i++) {
                if (records[i].overtime !== "0") {
                    hours += parseInt(records[i].overtime.split(":")[0]);
                    minutes += parseInt(records[i].overtime.split(":")[1]);
                }
            }

            hours += Math.floor(minutes / 60);
            minutes = minutes % 60;

            return String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0');
        }

        function totalUnjustifiedAbsence(records) {

            let hours = 0;
            let minutes = 0;
            for (let i = 0; i < records.length; i++) {
                if (records[i].unjustifiedAbsence !== "0") {
                    hours += parseInt(records[i].unjustifiedAbsence.split(":")[0]);
                    minutes += parseInt(records[i].unjustifiedAbsence.split(":")[1]);
                }
            }

            hours += Math.floor(minutes / 60);
            minutes = minutes % 60;

            return String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0');
        }

        function totalAcceptableAbsence(records) {

            let hours = 0;
            let minutes = 0;
            for (let i = 0; i < records.length; i++) {
                if (records[i].acceptableAbsence !== "0") {
                    hours += parseInt(records[i].acceptableAbsence.split(":")[0]);
                    minutes += parseInt(records[i].acceptableAbsence.split(":")[1]);
                }
            }

            hours += Math.floor(minutes / 60);
            minutes = minutes % 60;

            return String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0');
        }

        //***********************************

    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>