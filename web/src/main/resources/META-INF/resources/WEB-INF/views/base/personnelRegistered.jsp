<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// script

    var personnelRegMethod = "POST";
    var personnelRegWait;
    var educationLevelUrlPerReg = educationUrl + "level/";
    var educationMajorUrlPerReg = educationUrl + "major/";
    var codeMeliCheckPerReg = true;
    var persianRegDateCheck = true;
    var persianRegEmpDateCheck = true;
    var mailCheckPerReg = true;
    var cellPhoneCheckPerReg = true;



    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_JobDS_PerReg = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: jobUrl + "/iscList"
    });

    var RestDataSource_company_PerReg = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "workDomain", title: "<spring:message code="workDomain"/>", filterOperator: "iContains"},
            {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains"},
        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: companyUrl + "spec-list"
    });

    var RestDataSource_Education_Level_PerReg = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", filterOperator: "iContains"},
            {name: "titleEn", filterOperator: "iContains"},
            {name: "code", filterOperator: "iContains"}
        ],
        // fetchDataURL: educationLevelUrlPerReg + "level/spec-list"

        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: educationLevelUrlPerReg + "spec-list?_startRow=0&_endRow=55",
        autoFetchData: true
    });

    var RestDataSource_Education_Major_PerReg = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleEn", filterOperator: "iContains"},
            {name: "titleFa", filterOperator: "iContains"}
        ],
        // fetchDataURL: educationMajorUrlPerReg + "major/spec-list"

        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: educationMajorUrlPerReg + "spec-list?_startRow=0&_endRow=100",
        autoFetchData: true
    });

    var RestDataSource_PostGrade_PerReg = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.grade.code"/>", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: postGradeUrl + "iscList"
    });

    var RestDataSource_Post_PerReg = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains"
            },
            {
                name: "titleFa",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains"
            },
            {
                name: "job.titleFa",
                title: "<spring:message code="job.title"/>",
                filterOperator: "iContains"
            },
            {
                name: "postGrade.titleFa", title: "<spring:message
        code="post.grade.title"/>", filterOperator: "iContains"
            },
        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: postUrl + "iscList"
    });

    var RestDataSource_Egender_PerReg = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa", filterOperator: "iContains"}],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: enumUrl + "eGender/spec-list"
    });

    var RestDataSource_Emarried_PerReg = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa", filterOperator: "iContains"}],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: enumUrl + "eMarried/spec-list"
    });

    var RestDataSource_Emilitary_PerReg = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa", filterOperator: "iContains"}],
        canAddFormulaFields: false,
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        fetchDataURL: enumUrl + "eMilitary/spec-list"
    });

    var RestDataSource_PersonnelReg_JspPersonnelReg = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains"},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains"},
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains"
            },
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains"},
            {
                name: "employmentStatus",
                title: "<spring:message code="employment.status"/>",
                filterOperator: "iContains"
            },
            {name: "complex", title: "<spring:message code="complex"/>", filterOperator: "iContains"},
            {name: "workPlace", title: "<spring:message code="work.place"/>", filterOperator: "iContains"},
            {name: "workTurn", title: "<spring:message code="work.turn"/>", filterOperator: "iContains"},
            {
                name: "birthCertificateNo",
                title: "<spring:message code="birth.certificate.no"/>",
                filterOperator: "iContains"
            },
            {name: "fatherName", title: "<spring:message code="father.name"/>", filterOperator: "iContains"},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains"},
            {name: "postGradeTitle", title: "<spring:message code="post.grade"/>", filterOperator: "iContains"},
            {name: "birthDate", title: "<spring:message code="birth.date"/>", filterOperator: "iContains"},
            {name: "age", title: "<spring:message code="age"/>", filterOperator: "iContains"},
            {name: "birthPlace", title: "<spring:message code="birth.place"/>", filterOperator: "iContains"},
            {name: "active", title: "<spring:message code="active.status"/>"},
            {name: "deleted", title: "<spring:message code="deleted.status"/>"},
            {name: "employmentDate", title: "<spring:message code="employment.date"/>", filterOperator: "iContains"},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains"},
            {
                name: "postAssignmentDate",
                title: "<spring:message code="post.assignment.date"/>",
                filterOperator: "iContains"
            },
            {name: "operationalUnit", title: "<spring:message code="operational.unit"/>", filterOperator: "iContains"},
            {name: "employmentType", title: "<spring:message code="employment.type"/>", filterOperator: "iContains"},
            {name: "maritalStatus", title: "<spring:message code="marital.status"/>", filterOperator: "iContains"},
            {name: "educationLevel", title: "<spring:message code="education.level"/>", filterOperator: "iContains"},
            {name: "jobNo", title: "<spring:message code="job.code"/>", filterOperator: "iContains"},
            {name: "jobTitle", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},            //
            {name: "contractNo", title: "<spring:message code="contract.no"/>", filterOperator: "iContains"},
            {name: "educationMajor", title: "<spring:message code="education.major"/>", filterOperator: "iContains"},
            {name: "gender", title: "<spring:message code="gender"/>", filterOperator: "iContains"},
            {name: "militaryStatus", title: "<spring:message code="military"/>", filterOperator: "iContains"},
            {
                name: "educationLicenseType",
                title: "<spring:message code="education.license.type"/>",
                filterOperator: "iContains"
            },
            {name: "departmentTitle", title: "<spring:message code="department"/>", filterOperator: "iContains"},
            {name: "departmentCode", title: "<spring:message code="department.code"/>", filterOperator: "iContains"},
            {
                name: "contractDescription",
                title: "<spring:message code="contract.description"/>",
                filterOperator: "iContains"
            },
            {name: "workYears", title: "<spring:message code="work.years"/>", filterOperator: "iContains"},
            {name: "workMonths", title: "<spring:message code="work.months"/>", filterOperator: "iContains"},
            {name: "workDays", title: "<spring:message code="work.days"/>", filterOperator: "iContains"},
            {name: "insuranceCode", title: "<spring:message code="insurance.code"/>", filterOperator: "iContains"},
            {name: "postGradeCode", title: "<spring:message code="post.grade.code"/>", filterOperator: "iContains"},
            {name: "ccpCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains"},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
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
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
            {name: "ccpTitle", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains"},

            {name: "religion", title: "<spring:message code="religion"/>", filterOperator: "iContains"},
            {name: "nationality", title: "<spring:message code="nationality"/>", filterOperator: "iContains"},
            {name: "address", title: "<spring:message code="home.address"/>", filterOperator: "iContains"},
            {name: "phone", title: "<spring:message code="telephone"/>", filterOperator: "iContains"},
            {name: "fax", title: "<spring:message code="fax"/>", filterOperator: "iContains"},
            {name: "mobile", title: "<spring:message code="cellPhone"/>", filterOperator: "iContains"},
            {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains"},
            {name: "accountNumber", title: "<spring:message code="account.number"/>", filterOperator: "iContains"},

            {name: "version"}
        ],
        fetchDataURL: personnelRegUrl + "spec-list"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_PersonnelReg_JspPersonnelReg = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_personnelReg_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_personnelReg_add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_personnelReg_edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>", click: function () {
                ListGrid_personnelReg_remove();
            }
        }, {isSeparator: true},
            <%--    {--%>
            <%--    title: "<spring:message code='print.pdf'/>", icon: "<spring:url value="pdf.png"/>", click: function () {--%>
            <%--        ListGrid_personnelReg_print("pdf");--%>
            <%--    }--%>
            <%--}, {--%>
            <%--    title: "<spring:message code='print.excel'/>", icon: "<spring:url value="excel.png"/>", click: function () {--%>
            <%--        ListGrid_personnelReg_print("excel");--%>
            <%--    }--%>
            <%--}, {--%>
            <%--    title: "<spring:message code='print.html'/>", icon: "<spring:url value="html.png"/>", click: function () {--%>
            <%--        ListGrid_personnelReg_print("html");--%>
            <%--    }--%>
            <%--}--%>
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//

    var PersonnelReg_vm = isc.ValuesManager.create({});

    var DynamicForm_PersonnelReg_BaseInfo = isc.DynamicForm.create({
        valuesManager: PersonnelReg_vm,
        width: "800",
        titleWidth: "120",
        height: "190",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        margin: 50,
        padding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personnelNo",
                title: "<spring:message code='personnel.no'/>",
                required: true,
                keyPressFilter: "[0-9]",
                hint: "SSN/کدملی",
                length: "10",
                showHintInField: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code='national.code'/>",
                required: true,
                keyPressFilter: "[0-9]",
                length: "10",
                changed: function () {
                    var codeCheckPerReg;
                    codeCheckPerReg = checkCodeMeliPerReg(DynamicForm_PersonnelReg_BaseInfo.getValue("nationalCode"));
                    codeMeliCheckPerReg = codeCheckPerReg;
                    if (codeCheckPerReg === false) {
                        DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("nationalCode", "<spring:message
                                                                        code='msg.national.code.validation'/>", true);
                    }
                    if (codeCheck === true) {
                        DynamicForm_PersonnelReg_BaseInfo.clearFieldErrors("nationalCode", true);
                        // fillPersonalInfoFields(DynamicForm_PersonnelReg_BaseInfo.getValue("nationalCode"));
                    }
                }
            },
            {
                name: "firstName",
                title: "<spring:message code='firstName'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                // hint: "Persian/فارسی",
                length: "30",
                showHintInField: true
            },
            {
                name: "lastName",
                title: "<spring:message code='lastName'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                // hint: "Persian/فارسی",
                length: "50",
                showHintInField: true
            },
            {
                name: "birthCertificateNo",
                title: "<spring:message code='birth.certificate'/>",
                required: true,
                keyPressFilter: "[0-9]",
                length: "10"
            },
            {
                name: "birthDate",
                title: "<spring:message code='birth.date'/>",
                ID: "birthDate_jspPersonnelReg",
                // hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('birthDate_jspPersonnelReg', this, 'ymd', '/');
                    }
                }],
                changed: function () {
                    var dateCheck;
                    dateCheck = checkBirthDate(DynamicForm_PersonnelReg_BaseInfo.getValue("birthDate"));
                    persianRegDateCheck = dateCheck;
                    if (dateCheck === false)
                        DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("birthDate", "<spring:message
                                                                            code='msg.correct.date'/>", true);
                    else if (dateCheck === true)
                        DynamicForm_PersonnelReg_BaseInfo.clearFieldErrors("birthDate", true);
                }
            },
            {
                name: "birthPlace",
                title: "<spring:message code='birth.location'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                // hint: "Persian/فارسی",
                length: "50",
                showHintInField: true
            },
            {
                name: "gender",
                title: "<spring:message code='gender'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_Egender_PerReg,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "nationality",
                title: "<spring:message code='nationality'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                showHintInField: true,
                valueMap:
                    {
                        "ایرانی": "<spring:message code='nationality.iranian'/>",
                        "غیر ایرانی": "<spring:message code='nationality.notIranian'/>"}
            },
            {
                name: "religion",
                title: "<spring:message code='religion'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                showHintInField: true
                ,
                valueMap:
                    { "اسلام شیعه اثنی عشری": "<spring:message code='religion.shiite'/>",
                        "اسلام شیعه": "<spring:message code='religion.shia'/>",
                        "اسلام سنی": "<spring:message code='religion.sunni'/>",
                        "زرتشتی": "<spring:message code='religion.zoroastrianism'/>"}
            },

            {
                name: "maritalStatus",
                title: "<spring:message code='marital.status'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_Emarried_PerReg,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "militaryStatus",
                width: "*",
                title: "<spring:message code='military'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_Emilitary_PerReg,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}]
            },

            {name: "personnelNo2", title: "<spring:message code='personnel.no.6.digits'/>", keyPressFilter: "[0-9]",
                length: "6"},

            {name: "fatherName", title: "<spring:message code='father.name'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "50" },

            {name: "age", title: "<spring:message code='age'/>", keyPressFilter: "[0-9]",
                length: "2"},
            {name: "insuranceCode", title: "<spring:message code='insurance.code'/>",  keyPressFilter: "[0-9]",
                length: "10"},

            {name: "postAssignmentDate", title: "version", canEdit: false, hidden: true},
            {name: "educationLicenseTypeTitle", title: "version", canEdit: false, hidden: true},
            {name: "departmentTitle", title: "version", canEdit: false, hidden: true},
            {name: "departmentCode", title: "version", canEdit: false, hidden: true},
            {name: "postGradeCode", title: "version", canEdit: false, hidden: true},
            {name: "ccpCode", title: "version", canEdit: false, hidden: true},
            {name: "ccpUnit", title: "version", canEdit: false, hidden: true},
            {name: "ccpTitle", title: "version", canEdit: false, hidden: true},
            {name: "version", title: "version", canEdit: false, hidden: true},
        ]

    });


    var DynamicForm_PersonnelReg_EmployEdu = isc.DynamicForm.create({
        valuesManager: PersonnelReg_vm,
        width: "800",
        titleWidth: "120",
        height: "190",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        margin: 50,
        padding: 5,
        fields: [

            {
                name: "companyName",
                title: "<spring:message code='company'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_company_PerReg,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {name: "employmentDate", title: "<spring:message code='employment.date'/>",
                ID: "employmentDate_jspPersonnelReg",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('employmentDate_jspPersonnelReg', this, 'ymd', '/');
                    }
                }],
                changed: function () {
                    var dateCheck;
                    dateCheck = checkBirthDate(DynamicForm_PersonnelReg_BaseInfo.getValue("employmentDate"));
                    persianRegEmpDateCheck = dateCheck;
                    if (dateCheck === false)
                        DynamicForm_PersonnelReg_EmployEdu.addFieldErrors("employmentDate", "<spring:message
                                                                            code='msg.correct.date'/>", true);
                    else if (dateCheck === true)
                        DynamicForm_PersonnelReg_EmployEdu.clearFieldErrors("employmentDate", true);
                }},
            {name: "employmentStatus", title: "<spring:message code='employment.status'/>" , valueMap:
                    {
                        "اشتغال": "<spring:message code='employmentStatus.employment'/>",
                        "بازنشسته": "<spring:message code='employmentStatus.retired'/>",
                        "فوت": "<spring:message code='employmentStatus.death'/>",
                        "اخراج": "<spring:message code='employmentStatus.layingOff'/>"}
                        },
            {
                name: "employmentTypeTitle",
                title: "<spring:message code='employment.type'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                showHintInField: true,
                valueMap:
                    {
                        "دائم": "<spring:message code='employmentTypeTitle.permanent'/>",
                        "قراردادی": "<spring:message code='employmentTypeTitle.contractual'/>",
                        "موقت": "<spring:message code='employmentTypeTitle.temporary'/>",
                        "حق الزحمه": "<spring:message code='employmentTypeTitle.wage'/>"}
            },

            {name: "contractNo", title: "<spring:message code='contract.no'/>", keyPressFilter: "[0-9]",
                length: "10"},

            {name: "contractDescription", title: "<spring:message code='contract.description'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "150"},

            {
                name: "educationLevel",
                title: "<spring:message code='education.level'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_Education_Level_PerReg,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },

            {
                name: "educationMajor",
                title: "<spring:message code='education.major'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_Education_Major_PerReg,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },

            {name: "jobNo",  title: "<spring:message code='job.code'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "code",
                valueField: "code",
                optionDataSource: RestDataSource_JobDS_PerReg,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    },
                    {
                        name: "code",
                        width: "30%",
                        filterOperator: "iContains"
                    }
                ],},
            {name: "jobTitle", title: "<spring:message code='job.title'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_JobDS_PerReg,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ],
            },
            {
                name: "postCode", title: "<spring:message code='post.code'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "code",
                valueField: "code",
                optionDataSource: RestDataSource_Post_PerReg,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    },
                    {
                        name: "code",
                        width: "30%",
                        filterOperator: "iContains"
                    }
                ],
            },

            {
                name: "postTitle",
                title: "<spring:message code='post'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_Post_PerReg,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ],
                // changed: function () {
                //
                //     // DynamicForm_PersonnelReg_EmployEdu.setValue("postCode", RestDataSource_Post_PerReg.getValue("code"));
                //     DynamicForm_PersonnelReg_EmployEdu.setValue("postCode", RestDataSource_Post_PerReg.getSelectedRecord().code);
                // }

                // click: function (form, item, icon) {
                //
                //     DynamicForm_PersonnelReg_EmployEdu.setValue("postCode", RestDataSource_Post_PerReg.getSelectedRecord().code);
                // },

                },
            {
                name: "postGradeTitle",
                title: "<spring:message code='post.grade'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "titleFa",
                optionDataSource: RestDataSource_PostGrade_PerReg,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {name: "workPlaceTitle", title: "<spring:message code='work.place'/>" , valueMap:
                    {
                        "سرچشمه": "<spring:message code='workPlaceTitle.sarcheshmeh'/>",
                        "شهربابک": "<spring:message code='workPlaceTitle.shahrbabak'/>",
                        "سونگون": "<spring:message code='workPlaceTitle.songoon'/>",
                        "تهرات": "<spring:message code='workPlaceTitle.tehran'/>"}
                    },
            {
                name: "workTurn",
                title: "<spring:message code='work.turn'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                showHintInField: true , valueMap:
                    {
                        "عادیکار": "<spring:message code='workTurn.normal'/>",
                        "شیفت دو نوبتی منظم": "<spring:message code='workTurn.regularTwo'/>",
                        "شیفت 24/48": "<spring:message code='workTurn.shift24_48'/>",
                        "شبکار دائم": "<spring:message code='workTurn.nightmare'/>"}
            },

            {name: "workYears", title: "<spring:message code='work.years'/>",  keyPressFilter: "[0-9]",
                length: "2"},

            {name: "workMonths", title: "<spring:message code='work.months'/>",  keyPressFilter: "[0-9]",
                length: "2"},

            {name: "workDays", title: "<spring:message code='work.days'/>",  keyPressFilter: "[0-9]",
                length: "2"},
            {name: "active", title: "<spring:message code='active.status'/>",  valueMap:
                    {"-1": "<spring:message code='active'/>", "0": "<spring:message code='deActive'/>"}
            },
            {name: "deleted", title: "<spring:message code='delete.status'/>",  valueMap:
                    {"-1": "<spring:message code='deleted'/>", "0": "<spring:message code='notDeleted'/>"}
            }
        ]

    });


    var DynamicForm_PersonnelReg_OperationalUnit= isc.DynamicForm.create({
        valuesManager: PersonnelReg_vm,
        width: "800",
        titleWidth: "120",
        height: "190",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        margin: 50,
        padding: 5,
        fields: [

            {
                name: "operationalUnitTitle",
                title: "<spring:message code='operational.unit'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                showHintInField: true
            },

            {
                name: "ccpArea",
                title: "<spring:message code='area'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "70",
                showHintInField: true
            },
            {
                name: "ccpAssistant",
                title: "<spring:message code='assistance'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "70",
                showHintInField: true
            },
            {
                name: "ccpAffairs",
                title: "<spring:message code='affairs'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "70",
                showHintInField: true
            },
            {
                name: "ccpSection",
                title: "<spring:message code='section'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "70",
                showHintInField: true
            },
        ]

    });

    var DynamicForm_PersonnelReg_ContactInfo= isc.DynamicForm.create({
        valuesManager: PersonnelReg_vm,
        width: "800",
        titleWidth: "120",
        height: "190",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        margin: 50,
        padding: 5,
        fields: [

            {
                name: "address",
                title: "<spring:message code='home.address'/>",
                type: "textArea",
                length: "255"
            },
            {
                name: "phone",
                title: "<spring:message code='telephone'/>",
                keyPressFilter: "[0-9]",
                length: "11"
            },
            {
                name: "fax",
                title: "<spring:message code='telefax'/>"
            },
            {
                name: "mobile",
                title: "<spring:message code='cellPhone'/>",
                keyPressFilter: "[0-9]",
                length: "11",
                hint: "*********09",
                showHintInField: true,
                errorMessage: "<spring:message code='msg.mobile.validation'/>"
                , changed: function () {
                    var mobileCheck;
                    mobileCheck = checkMobile(DynamicForm_PersonnelReg_ContactInfo.getValue("mobile"));
                    cellPhoneCheckPerReg = mobileCheck;
                    if (mobileCheck === false)
                        DynamicForm_PersonnelReg_ContactInfo.addFieldErrors("mobile", "<spring:message
                                                                           code='msg.mobile.validation'/>", true);
                    if (mobileCheck === true)
                        DynamicForm_PersonnelReg_ContactInfo.clearFieldErrors("mobile", true);
                }
            },
            {
                name: "email",
                title: "<spring:message code='email'/>",
                showHintInField: true,
                length: "30"
                , changed: function () {
                    var emailCheck;
                    emailCheck = checkEmailPerReg(DynamicForm_PersonnelReg_ContactInfo.getValue("email"));
                    mailCheckPerReg = emailCheck;
                    if (emailCheck === false)
                        DynamicForm_PersonnelReg_ContactInfo.addFieldErrors("email",
                            "<spring:message code='msg.email.validation'/>", true);
                    if (emailCheck === true)
                        DynamicForm_PersonnelReg_ContactInfo.clearFieldErrors("email", true);
                }
            },

            {
                name: "accountNumber",
                title: "<spring:message code='account.number'/>",
                keyPressFilter: "[0-9]",
                length: "13"
            },
        ]

    });

        var personnelRegTabs = isc.TabSet.create({
        width: 820,
        titleWidth: 120,
        height: 400,
        showTabScroller: false,
        tabs: [
            {
            title: "<spring:message code='personnelReg.baseInfo'/>",
            pane: DynamicForm_PersonnelReg_BaseInfo
        },
            {
                title: "<spring:message code='personnelReg.employEdu'/>",
                pane: DynamicForm_PersonnelReg_EmployEdu
            },
            {
                title: "<spring:message code='operational.unit'/>",
                pane: DynamicForm_PersonnelReg_OperationalUnit
            },
            {
                title: "<spring:message code='contact.information'/>",
                pane: DynamicForm_PersonnelReg_ContactInfo
            },
        ]
    });

    var IButton_PersonnelReg_Exit_JspPersonnelReg = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "[SKIN]/actions/cancel.png",
        click: function () {
            Window_PersonnelReg_JspPersonnelReg.close();
        }
    });

    var IButton_PersonnelReg_Save_JspPersonnelReg = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        align: "center",
        icon: "[SKIN]/actions/save.png",
        click: function () {
            if (codeMeliCheckPerReg === false) {
                DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("nationalCode", "<spring:message
                                                                        code='msg.national.code.validation'/>", true);
                return;
            }
            if (persianRegDateCheck === false) {
                DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("birthDate", "<spring:message
                                                                            code='msg.correct.date'/>", true);
                return;
            }
            if (persianRegEmpDateCheck === false) {
                DynamicForm_PersonnelReg_EmployEdu.addFieldErrors("employmentDate", "<spring:message
                                                                            code='msg.correct.date'/>", true);
                return;
            }
            if (cellPhoneCheckPerReg === false) {
                DynamicForm_PersonnelReg_ContactInfo.addFieldErrors("mobile", "<spring:message
                                                                            code='msg.mobile.validation'/>", true);
                return;
            }
            if (mailCheckPerReg === false) {
                DynamicForm_PersonnelReg_ContactInfo.addFieldErrors("email", "<spring:message
                                                                            code='msg.email.validation'/>", true);
                return;
            }
            DynamicForm_PersonnelReg_BaseInfo.validate();
            DynamicForm_PersonnelReg_EmployEdu.validate();
            DynamicForm_PersonnelReg_ContactInfo.validate();
            if (DynamicForm_PersonnelReg_BaseInfo.hasErrors()) {
                personnelRegTabs.selectTab(0);
                return;
            } else if (DynamicForm_PersonnelReg_EmployEdu.hasErrors()) {
                personnelRegTabs.selectTab(1);
                return;
            }else if (DynamicForm_PersonnelReg_ContactInfo.hasErrors()) {
                personnelRegTabs.selectTab(3);
                return;
            }
            else {
                var data = PersonnelReg_vm.getValues();
                var personnelRegSaveUrl = personnelRegUrl;
                if (personnelRegMethod.localeCompare("PUT") == 0) {
                    var personnelRegRecord = ListGrid_PersonnelReg_JspPersonnelReg.getSelectedRecord();
                    personnelRegSaveUrl += personnelRegRecord.id;
                }
                isc.RPCManager.sendRequest(TrDSRequest(personnelRegSaveUrl, personnelRegMethod, JSON.stringify(data), "callback: personnelReg_action_result(rpcResponse)"));
                Window_PersonnelReg_JspPersonnelReg.close();
            }
        }
    });

    var HLayOut_PersonnelRegSaveOrExit_JspPersonnelReg = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "800",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_PersonnelReg_Save_JspPersonnelReg, IButton_PersonnelReg_Exit_JspPersonnelReg]
    });

    var Window_PersonnelReg_JspPersonnelReg = isc.Window.create({
        title: "<spring:message code='student'/>",
        width: 800,
        height: 200,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [personnelRegTabs, HLayOut_PersonnelRegSaveOrExit_JspPersonnelReg]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Refresh_JspPersonnelReg = isc.ToolStripButtonRefresh.create({
        <%--icon: "<spring:url value="refresh.png"/>",--%>
        <%--title: "<spring:message code='refresh'/>",--%>
        click: function () {
            ListGrid_personnelReg_refresh();
        }
    });

    var ToolStripButton_Edit_JspPersonnelReg = isc.ToolStripButtonEdit.create({

        // title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_personnelReg_edit();
        }
    });

    var ToolStripButton_Add_JspPersonnelReg = isc.ToolStripButtonAdd.create({

        // title: "<spring:message code='create'/>",
        click: function () {
            ListGrid_personnelReg_add();
        }
    });

    var ToolStripButton_Remove_JspPersonnelReg = isc.ToolStripButtonRemove.create({
        // icon: "[SKIN]/actions/remove.png",
        // title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_personnelReg_remove();
        }
    });

    var ToolStripButton_Print_JspPersonnelReg = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            ListGrid_personnelReg_print("pdf");
        }
    });

    var ToolStrip_Actions_JspPersonnelReg = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [

            ToolStripButton_Add_JspPersonnelReg,
            ToolStripButton_Edit_JspPersonnelReg,
            ToolStripButton_Remove_JspPersonnelReg,
            // ToolStripButton_Print_JspPersonnelReg
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_JspPersonnelReg,
                ]
            })
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Listgrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_PersonnelReg_JspPersonnelReg = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_PersonnelReg_JspPersonnelReg,
        contextMenu: Menu_ListGrid_PersonnelReg_JspPersonnelReg,
        doubleClick: function () {
            ListGrid_personnelReg_edit();
        },

        selectionType: "single",


        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "personnelNo",
                title: "<spring:message code='personal.ID'/>",
                align: "center"
                , filterOperator: "iContains"
            },
            {
                name: "firstName",
                title: "<spring:message code='firstName'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "lastName",
                title: "<spring:message code='lastName'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "birthCertificateNo",
                title: "<spring:message code='birth.certificate'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "nationalCode",
                title: "<spring:message code='national.code'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "companyName",
                title: "<spring:message code='company.name'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "educationMajor",
                title: "<spring:message code='personnelReg.educationMajorTitle'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "educationLevel",
                title: "<spring:message code='personnelReg.educationLevelTitle'/>",
                align: "center",
                filterOperator: "iContains"
            }

        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,

        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    var HLayout_Actions_PersonnelReg_JspPersonnelReg = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspPersonnelReg]
    });

    var HLayout_Grid_PersonnelReg_JspPersonnelReg = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_PersonnelReg_JspPersonnelReg]
    });

    var VLayout_Body_PersonnelReg_JspPersonnelReg = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_PersonnelReg_JspPersonnelReg
            , HLayout_Grid_PersonnelReg_JspPersonnelReg
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_personnelReg_remove() {
        var record = ListGrid_PersonnelReg_JspPersonnelReg.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.no.records.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.ask'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='msg.remove.title'/>",
                buttons: [isc.Button.create({title: "<spring:message code='yes'/>"}), isc.Button.create({
                    title: "<spring:message code='no'/>"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        personnelRegWait = isc.Dialog.create({
                            message: "<spring:message code='msg.waiting'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='message'/>"
                        });
                        isc.RPCManager.sendRequest(TrDSRequest(personnelRegUrl + record.id, "DELETE", null, "callback: personnelReg_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    };

    function ListGrid_personnelReg_edit() {
        DynamicForm_PersonnelReg_BaseInfo.clearValues();
        DynamicForm_PersonnelReg_EmployEdu.clearValues();
        var record = ListGrid_PersonnelReg_JspPersonnelReg.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.no.records.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            personnelRegMethod = "PUT";
            PersonnelReg_vm.editRecord(record);
            personnelRegTabs.selectTab(0);
            Window_PersonnelReg_JspPersonnelReg.show();
        }
    };

    function ListGrid_personnelReg_refresh() {
        ListGrid_PersonnelReg_JspPersonnelReg.invalidateCache();
        // ListGrid_PersonnelReg_JspPersonnelReg.filterByEditor();
    };

    function ListGrid_personnelReg_add() {
        personnelRegMethod = "POST";
        DynamicForm_PersonnelReg_BaseInfo.clearValues();
        DynamicForm_PersonnelReg_EmployEdu.clearValues();
        personnelRegTabs.selectTab(0);
        Window_PersonnelReg_JspPersonnelReg.show();
    };

    function ListGrid_personnelReg_print(type) {
        var advancedCriteria = ListGrid_PersonnelReg_JspPersonnelReg.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/personnelRegistered/printWithCriteria/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"}
                ]
        });
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.submitForm();
    };

    function personnelReg_action_result(resp) {

        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            var responseID = JSON.parse(resp.data).id;
            var gridState = "[{id:" + responseID + "}]";
            <%--var OK = isc.Dialog.create({--%>
            <%--    message: "<spring:message code='msg.operation.successful'/>",--%>
            <%--    icon: "[SKIN]say.png",--%>
            <%--    title: "<spring:message code='msg.command.done'/>"--%>
            <%--});--%>
            // setTimeout(function () {
            //     OK.close();
            //     ListGrid_personnelReg_refresh();
            //     ListGrid_PersonnelReg_JspPersonnelReg.setSelectedState(gridState);
            // }, 1000);

            simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");

            ListGrid_personnelReg_refresh();
            ListGrid_PersonnelReg_JspPersonnelReg.setSelectedState(gridState);
            Window_PersonnelReg_JspPersonnelReg.close();
        } else {
            var ERROR = isc.Dialog.create({
                message: ("<spring:message code='msg.operation.error'/>"),
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }

    };

    function personnelReg_delete_result(resp) {
        personnelRegWait.close();
        if (resp.httpResponseCode == 200) {
            ListGrid_PersonnelReg_JspPersonnelReg.invalidateCache();
            <%--var OK = isc.Dialog.create({--%>
            <%--    message: "<spring:message code='msg.record.remove.successful'/>",--%>
            <%--    icon: "[SKIN]say.png",--%>
            <%--    title: "<spring:message code='msg.command.done'/>"--%>
            <%--});--%>
            <%--setTimeout(function () {--%>
            <%--    OK.close();--%>
            <%--}, 3000);--%>
            simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
            ListGrid_personnelReg_refresh();

        } else if (resp.data == false) {
            var ERROR = isc.Dialog.create({
                message: "<spring:message code='msg.student.remove.error'/>",
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        } else {
            var ERROR = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.failed'/>",
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
    };


    function checkCodeMeliPerReg(code) {
        if (code === "undefined" || code === null || code === "")
            return false;
        var L = code.length;

        if (L < 8 || parseFloat(code, 10) === 0)
            return false;
        code = ('0000' + code).substr(L + 4 - 10);
        if (parseFloat(code.substr(3, 6), 10) === 0)
            return false;
        var c = parseFloat(code.substr(9, 1), 10);
        var s = 0;
        for (var i = 0; i < 9; i++) {
            s += parseFloat(code.substr(i, 1), 10) * (10 - i);
        }
        s = s % 11;
        return (s < 2 && c === s) || (s >= 2 && c === (11 - s));
    };

    function checkEmailPerReg(email) {
        return !(email.indexOf("@") === -1 || email.indexOf(".") === -1 || email.lastIndexOf(".") < email.indexOf("@"));
    };