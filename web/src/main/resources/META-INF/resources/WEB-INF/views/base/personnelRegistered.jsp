<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    var personnelRegMethod = "POST";
    var personnelRegWait;
    var educationLevelUrlPerReg = educationLevelUrl;
    var educationMajorUrlPerReg = educationMajorUrl;
    var codeMeliCheckPerReg = true;
    var persianRegDateCheck = true;
    var persianRegEmpDateCheck = true;
    var mailCheckPerReg = true;
    var cellPhoneCheckPerReg = true;
    var duplicateCodePerReg = false;
    var tempNationalCode = "";


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
        fetchDataURL: postGradeUrl + "/iscList"
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
        fetchDataURL: postUrl + "/iscList"
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
            {name: "contactInfo.mobile", title: "<spring:message code="cellPhone"/>", filterOperator: "iContains"},
            {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains"},
            {name: "accountNumber", title: "<spring:message code="account.number"/>", filterOperator: "iContains"},

            {name: "version"}
        ],
        fetchDataURL: personnelRegUrl + "/spec-list"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_PersonnelReg_JspPersonnelReg = isc.Menu.create({
        width: 150,
        data: [
            <sec:authorize access="hasAuthority('Personnel_Registered_R')">
            {
                title: "<spring:message code='refresh'/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    ListGrid_personnelReg_refresh();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Personnel_Registered_C')">
            {
                title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                    ListGrid_personnelReg_add();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Personnel_Registered_U')">
            {
                title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                    ListGrid_personnelReg_edit();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Personnel_Registered_D')">
            {
                title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    ListGrid_personnelReg_remove();
                }
            },
            </sec:authorize>
            {isSeparator: true},
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
                // required: true,
                keyPressFilter: "[0-9]",
                hint: "SSN/کدملی",
                // length: "10",
                showHintInField: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code='national.code'/>",
                required: true,
                keyPressFilter: "[0-9]",
                // length: "10",
                blur: function () {
                    DynamicForm_PersonnelReg_BaseInfo.clearFieldErrors("nationalCode", true);
                    var codeCheckPerReg;
                    codeCheckPerReg = checkCodeMeliPerReg(DynamicForm_PersonnelReg_BaseInfo.getField("nationalCode")._value
                    ,DynamicForm_PersonnelReg_BaseInfo.getField("nationality")._value
                    );
                    codeMeliCheckPerReg = codeCheckPerReg;
                    if (codeCheckPerReg === false) {
                        DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("nationalCode", "<spring:message
                                                                        code='msg.national.code.validation'/>", true);
                    } else if (codeCheckPerReg === true) {
                        DynamicForm_PersonnelReg_BaseInfo.clearFieldErrors("nationalCode", true);
                        checkPersonalRegNationalCode(DynamicForm_PersonnelReg_BaseInfo.getValue("nationalCode"));
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
                    DynamicForm_PersonnelReg_BaseInfo.clearFieldErrors("birthDate", true);
                    var dateCheck;
                    dateCheck = checkBirthDate(DynamicForm_PersonnelReg_BaseInfo.getValue("birthDate"));
                    persianRegDateCheck = dateCheck;
                    if (dateCheck === false)
                        DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("birthDate", "<spring:message
                                                                            code='msg.correct.date'/>", true);
                    else if (dateCheck === true)
                        DynamicForm_PersonnelReg_BaseInfo.clearFieldErrors("birthDate", true);
                },
                editorExit: function () {
                    let result = reformat(DynamicForm_PersonnelReg_BaseInfo.getValue("birthDate"));
                    if (result) {
                        DynamicForm_PersonnelReg_BaseInfo.getItem("birthDate").setValue(result);
                        DynamicForm_PersonnelReg_BaseInfo.clearFieldErrors("birthDate", true);
                        persianRegDateCheck = true;
                    }
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
                editorType: "SelectItem",
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
                required: true,
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
                required: true,
                showHintInField: true,
                valueMap:
                    {
                        "ایرانی": "<spring:message code='nationality.iranian'/>",
                        "غیر ایرانی": "<spring:message code='nationality.notIranian'/>"
                    }
            },
            {
                name: "religion",
                title: "<spring:message code='religion'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                showHintInField: true
                ,
                valueMap:
                    {
                        "اسلام شیعه اثنی عشری": "<spring:message code='religion.shiite'/>",
                        "اسلام شیعه": "<spring:message code='religion.shia'/>",
                        "اسلام سنی": "<spring:message code='religion.sunni'/>",
                        "زرتشتی": "<spring:message code='religion.zoroastrianism'/>"
                    }
            },

            {
                name: "maritalStatus",
                title: "<spring:message code='marital.status'/>",
                textAlign: "center",
                width: "*",
                editorType: "SelectItem",
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
                editorType: "SelectItem",
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

            {
                name: "personnelNo2", title: "<spring:message code='personnel.no.6.digits'/>", keyPressFilter: "[0-9]",
                length: "6"
            },

            {
                name: "fatherName", title: "<spring:message code='father.name'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "50"
            },

            {
                name: "age", title: "<spring:message code='age'/>", keyPressFilter: "[0-9]",
                length: "2"
            },
            {
                name: "contactInfo.mobile",
                title: "<spring:message code='cellPhone'/>",
                keyPressFilter: "[0-9|-|+]",
                length: "11",
                required: true,
                // validators: [TrValidators.MobileValidate],
                changed: function () {
                    DynamicForm_PersonnelReg_BaseInfo.clearErrors();
                    var mobileCheck;
                    mobileCheck = checkMobilePerReg(DynamicForm_PersonnelReg_BaseInfo.getValue("contactInfo.mobile"));
                    cellPhoneCheckPerReg = mobileCheck;
                    if (mobileCheck === false)
                        DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("contactInfo.mobile", "<spring:message
                                                                           code='msg.mobile.validation'/>", true);
                    if (mobileCheck === true)
                        DynamicForm_PersonnelReg_BaseInfo.clearFieldErrors("contactInfo.mobile", true);
                }
            },
            {
                name: "insuranceCode", title: "<spring:message code='insurance.code'/>", keyPressFilter: "[0-9]",
                length: "10"
            },
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
                required: true,
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
            {
                name: "employmentDate", title: "<spring:message code='employment.date'/>",
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
                    DynamicForm_PersonnelReg_EmployEdu.clearFieldErrors("employmentDate", true);
                    var dateCheck;
                    dateCheck = checkBirthDate(DynamicForm_PersonnelReg_EmployEdu.getValue("employmentDate"));
                    persianRegEmpDateCheck = dateCheck;
                    if (dateCheck === false)
                        DynamicForm_PersonnelReg_EmployEdu.addFieldErrors("employmentDate", "<spring:message
                                                                            code='msg.correct.date'/>", true);
                    else if (dateCheck === true)
                        DynamicForm_PersonnelReg_EmployEdu.clearFieldErrors("employmentDate", true);
                },
                editorExit: function () {
                    let result = reformat(DynamicForm_PersonnelReg_EmployEdu.getValue("employmentDate"));
                    if (result) {
                        DynamicForm_PersonnelReg_EmployEdu.getItem("employmentDate").setValue(result);
                        DynamicForm_PersonnelReg_EmployEdu.clearFieldErrors("employmentDate", true);
                        persianRegEmpDateCheck = true;
                    }
                }
            },

            {
                name: "employmentStatus", title: "<spring:message code='employment.status'/>", valueMap:
                    {
                        "اشتغال": "<spring:message code='employmentStatus.employment'/>",
                        "بازنشسته": "<spring:message code='employmentStatus.retired'/>",
                        "فوت": "<spring:message code='employmentStatus.death'/>",
                        "اخراج": "<spring:message code='employmentStatus.layingOff'/>"
                    }
            },
            {
                name: "employmentType",
                title: "<spring:message code='employment.type'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                showHintInField: true,
                valueMap:
                    {
                        "دائم": "<spring:message code='employmentTypeTitle.permanent'/>",
                        "قراردادی": "<spring:message code='employmentTypeTitle.contractual'/>",
                        "موقت": "<spring:message code='employmentTypeTitle.temporary'/>",
                        "حق الزحمه": "<spring:message code='employmentTypeTitle.wage'/>"
                    }
            },

            {
                name: "contractNo", title: "<spring:message code='contract.no'/>", keyPressFilter: "[0-9]",
                length: "10"
            },

            {
                name: "contractDescription", title: "<spring:message code='contract.description'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "150"
            },

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

            {
                name: "jobNo", title: "<spring:message code='job.code'/>",
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
                ],
            },
            {
                name: "jobTitle", title: "<spring:message code='job.title'/>",
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
            {
                name: "workPlace", title: "<spring:message code='work.place'/>", valueMap:
                    {
                        "سرچشمه": "<spring:message code='workPlaceTitle.sarcheshmeh'/>",
                        "شهربابک": "<spring:message code='workPlaceTitle.shahrbabak'/>",
                        "سونگون": "<spring:message code='workPlaceTitle.songoon'/>",
                        "تهرات": "<spring:message code='workPlaceTitle.tehran'/>"
                    }
            },
            {
                name: "workTurn",
                title: "<spring:message code='work.turn'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                showHintInField: true, valueMap:
                    {
                        "عادیکار": "<spring:message code='workTurn.normal'/>",
                        "شیفت دو نوبتی منظم": "<spring:message code='workTurn.regularTwo'/>",
                        "شیفت 24/48": "<spring:message code='workTurn.shift24_48'/>",
                        "شبکار دائم": "<spring:message code='workTurn.nightmare'/>"
                    }
            },

            {
                name: "workYears", title: "<spring:message code='work.years'/>", keyPressFilter: "[0-9]",
                length: "2"
            },

            {
                name: "workMonths", title: "<spring:message code='work.months'/>", keyPressFilter: "[0-9]",
                length: "2"
            },

            {
                name: "workDays", title: "<spring:message code='work.days'/>", keyPressFilter: "[0-9]",
                length: "2"
            },
            {
                name: "enabled", title: "<spring:message code='active.status'/>", valueMap:
                    {"494": "<spring:message code='active'/>", "74": "<spring:message code='deActive'/>"}
            },
            {
                name: "deleted", title: "<spring:message code='delete.status'/>", valueMap:
                    {"75": "<spring:message code='deleted'/>", "76": "<spring:message code='notDeleted'/>"}
            }
        ]

    });

    var DynamicForm_PersonnelReg_OperationalUnit = isc.DynamicForm.create({
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
                name: "operationalUnit",
                title: "<spring:message code='operational.unit'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "70",
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

    var DynamicForm_PersonnelReg_ContactInfo = isc.DynamicForm.create({
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
                keyPressFilter: "[0-9|-]",
                validators: [TrValidators.PhoneValidate],
                blur: function () {
                    var phoneCheck;
                    phoneCheck = checkPhonePerReg(DynamicForm_PersonnelReg_ContactInfo.getValue("phone"));
                    if (phoneCheck === false)
                        DynamicForm_PersonnelReg_ContactInfo.addFieldErrors("phone", "<spring:message code='msg.invalid.phone.number'/>", true);
                    if (phoneCheck === true)
                        DynamicForm_PersonnelReg_ContactInfo.clearFieldErrors("phone", true);
                },
                length: "12"


            },
            {
                name: "fax",
                title: "<spring:message code='telefax'/>",
                keyPressFilter: "[0-9]",
                validators: [TrValidators.PhoneValidate],
                blur: function () {
                    var phoneCheck;
                    phoneCheck = checkPhonePerReg(DynamicForm_PersonnelReg_ContactInfo.getValue("fax"));
                    if (phoneCheck === false)
                        DynamicForm_PersonnelReg_ContactInfo.addFieldErrors("fax", "<spring:message code='msg.invalid.phone.number'/>", true);
                    if (phoneCheck === true)
                        DynamicForm_PersonnelReg_ContactInfo.clearFieldErrors("fax", true);
                },
                length: "12"

            },
            {
                name: "email",
                title: "<spring:message code='email'/>",
                showHintInField: true,
                length: "30",
                keyPressFilter: "[a-z|A-Z|0-9|.|@|-|_]",
                validators: [TrValidators.EmailValidate]
                , changed: function () {
                    DynamicForm_PersonnelReg_ContactInfo.clearFieldErrors("email", true);
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
        width: 850,
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
            ListGrid_personnelReg_refresh();
            Window_PersonnelReg_JspPersonnelReg.close();
        }
    });

    var IButton_PersonnelReg_Save_JspPersonnelReg = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        align: "center",
        icon: "[SKIN]/actions/save.png",
        click: async function () {
            DynamicForm_PersonnelReg_BaseInfo.clearErrors();
            if (codeMeliCheckPerReg === false) {
                DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("nationalCode", "<spring:message  code='msg.national.code.validation'/>", true);
                return;
            }
            if (duplicateCodePerReg === true) {
                DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("nationalCode", "<spring:message  code='msg.national.code.personalReg.duplicate'/>", true);
                return;
            }
            if (persianRegDateCheck === false) {
                DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("birthDate", "<spring:message  code='msg.correct.date'/>", true);
                return;
            }
            if (persianRegEmpDateCheck === false) {
                DynamicForm_PersonnelReg_EmployEdu.addFieldErrors("employmentDate", "<spring:message  code='msg.correct.date'/>", true);
                return;
            }
            if (cellPhoneCheckPerReg === false) {
                DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("contactInfo.mobile", "<spring:message code='msg.mobile.validation'/>", true);
                return;
            }
            if (mailCheckPerReg === false) {
                DynamicForm_PersonnelReg_ContactInfo.addFieldErrors("email", "<spring:message  code='msg.email.validation'/>", true);
                return;
            }
            DynamicForm_PersonnelReg_BaseInfo.validate();
            DynamicForm_PersonnelReg_EmployEdu.validate();
            DynamicForm_PersonnelReg_ContactInfo.validate();
            let this_mobile = DynamicForm_PersonnelReg_BaseInfo.getItem('contactInfo.mobile').getValue();
            wait.show();
            let resp = await fetch(rootUrl.concat("/contactInfo/nationalCodeOfMobile/").concat(this_mobile), {headers: {"Authorization": "Bearer <%= (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN) %>"}});
            const r = await resp.json();
            wait.close();
            let alreadyNCs = r.filter(d => d != DynamicForm_PersonnelReg_BaseInfo.getItem('nationalCode').getValue());
            if (alreadyNCs.size() > 0) {
                let msg = "<spring:message  code='msg.duplicate.mobile.number.SomeOne'/>".replace("{0}", alreadyNCs[0]);
                createDialog("warning", msg);
                DynamicForm_PersonnelReg_BaseInfo.addFieldErrors("contactInfo.mobile", msg, true);
                return;
            }
            if (DynamicForm_PersonnelReg_BaseInfo.hasErrors()) {
                personnelRegTabs.selectTab(0);
                return;
            } else if (DynamicForm_PersonnelReg_EmployEdu.hasErrors()) {
                personnelRegTabs.selectTab(1);
                return;
            } else if (DynamicForm_PersonnelReg_ContactInfo.hasErrors()) {
                personnelRegTabs.selectTab(3);
                return;
            } else {
                if (typeof DynamicForm_PersonnelReg_BaseInfo.getItem('personnelNo').getValue() == "undefined") {
                    DynamicForm_PersonnelReg_BaseInfo.setValue('personnelNo', DynamicForm_PersonnelReg_BaseInfo.getItem('nationalCode').getValue())
                }
                var data = PersonnelReg_vm.getValues();
                delete data.contactInfo.emobileForSMS;
                delete data.contactInfo.emobileForCN;
                var personnelRegSaveUrl = personnelRegUrl;
                personnelRegWait = createDialog("wait");
                if (personnelRegMethod.localeCompare("PUT") == 0) {
                    var personnelRegRecord = ListGrid_PersonnelReg_JspPersonnelReg.getSelectedRecord();
                    personnelRegSaveUrl += "/" + personnelRegRecord.id;
                }
                isc.RPCManager.sendRequest(TrDSRequest(personnelRegSaveUrl, personnelRegMethod, JSON.stringify(data), "callback: personnelReg_action_result(rpcResponse)"));
                // Window_PersonnelReg_JspPersonnelReg.close();
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
        width: 850,
        height: 250,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            ListGrid_personnelReg_refresh();
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
    var ToolStripButton_Add_List_JspPersonnelReg = isc.ToolStripButtonAdd.create({

        title: "<spring:message code='add.group'/>",
        click: function () {
            addRegisteredGroup();
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

    var ToolStripButton_Export2EXcel_JspPersonnelReg = isc.ToolStripButtonExcel.create({
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_PersonnelReg_JspPersonnelReg, personnelRegUrl + "/spec-list", 0, null, '', "لیست فراگیران متفرقه", null, null, 0, true);
        }
    });

    var ToolStrip_Actions_JspPersonnelReg = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Personnel_Registered_C')">
            ToolStripButton_Add_JspPersonnelReg,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Personnel_Registered_U')">
            ToolStripButton_Edit_JspPersonnelReg,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Personnel_Registered_D')">
            ToolStripButton_Remove_JspPersonnelReg,
            </sec:authorize>
            // ToolStripButton_Print_JspPersonnelReg
            <sec:authorize access="hasAuthority('Personnel_Registered_P')">
            ToolStripButton_Export2EXcel_JspPersonnelReg,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Personnel_Registered_C')">
            ToolStripButton_Add_List_JspPersonnelReg,
            </sec:authorize>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('Personnel_Registered_R')">
                    ToolStripButton_Refresh_JspPersonnelReg,
                    </sec:authorize>
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
        <sec:authorize access="hasAuthority('Personnel_Registered_R')">
        dataSource: RestDataSource_PersonnelReg_JspPersonnelReg,
        </sec:authorize>
        contextMenu: Menu_ListGrid_PersonnelReg_JspPersonnelReg,
        <sec:authorize access="hasAuthority('Personnel_Registered_U')">
        doubleClick: function () {
            ListGrid_personnelReg_edit();
        },
        </sec:authorize>
        selectionType: "single",


        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "personnelNo",
                title: "<spring:message code='personal.ID'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
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
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "nationalCode",
                title: "<spring:message code='national.code'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
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
            },
            {
                hidden: true,
                name: "contactInfo.mobile",
                title: "موبایل",
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

    let criteriaActivePersonnelRegistered_JspPersonnelReg = {
        _constructor: "AdvancedCriteria",
        operator: "and",
        criteria: [
            {fieldName: "deleted", operator: "isNull"}
        ]
    };

    ListGrid_PersonnelReg_JspPersonnelReg.implicitCriteria = criteriaActivePersonnelRegistered_JspPersonnelReg;

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
                        personnelRegWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(personnelRegUrl + "/" + record.id, "DELETE", null, "callback: personnelReg_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    };

    function ListGrid_personnelReg_edit() {
        DynamicForm_PersonnelReg_BaseInfo.clearValues();
        DynamicForm_PersonnelReg_EmployEdu.clearValues();
        DynamicForm_PersonnelReg_OperationalUnit.clearValues();
        DynamicForm_PersonnelReg_ContactInfo.clearValues();
        duplicateCodePerReg = false;
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
            // DynamicForm_PersonnelReg_BaseInfo.getField("nationalCode").disabled = true;
            personnelRegTabs.selectTab(0);
            tempNationalCode = DynamicForm_PersonnelReg_BaseInfo.getValue("nationalCode");
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
        DynamicForm_PersonnelReg_OperationalUnit.clearValues();
        DynamicForm_PersonnelReg_ContactInfo.clearValues();
        // DynamicForm_PersonnelReg_BaseInfo.getField("nationalCode").disabled = false;
        personnelRegTabs.selectTab(0);
        tempNationalCode = "";
        Window_PersonnelReg_JspPersonnelReg.show();
    };


    function addRegisteredGroup() {
        let TabSet_RegisteredGroupInsert_JspStudent = isc.TabSet.create({
            ID: "leftTabSet",
            autoDraw: false,
            tabBarPosition: "top",
            width: "100%",
            height: 115,
            tabs: [
                {
                    title: "فایل اکسل", width: 200, overflow: "hidden",
                    pane: isc.DynamicForm.create({
                        height: "100%",
                        width: "100%",
                        numCols: 4,
                        colWidths: ["10%", "40%", "20%", "20%"],
                        fields: [
                            {
                                ID: "DynamicForm_GroupInsert_FileUploader_JspRegisterd",
                                name: "DynamicForm_GroupInsert_FileUploader_JspRegisterd",
                                type: "imageFile",
                                title: "مسیر فایل",
                            },
                            {
                                type: "button",
                                startRow: false,
                                title: "آپلود فايل",
                                click: function () {
                                    let address = DynamicForm_GroupInsert_FileUploader_JspRegisterd.getValue();

                                    if (address == null) {
                                        createDialog("info", "فايل خود را انتخاب نماييد.");
                                    } else {
                                        var ExcelToJSON = function () {

                                            this.parseExcel = function (file) {
                                                var reader = new FileReader();
                                                var records = [];

                                                reader.onload = function (e) {
                                                    var data = e.target.result;
                                                    var workbook = XLSX.read(data, {
                                                        type: 'binary'
                                                    });
                                                    var isEmpty = true;

                                                    workbook.SheetNames.forEach(function (sheetName) {
                                                        // Here is your object
                                                        var XL_row_object = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
                                                        //var json_object = JSON.stringify(XL_row_object);

                                                        for (let i = 0; i < XL_row_object.length; i++) {
                                                            if (isNaN(Object.values(XL_row_object[i])[0])) {
                                                                continue;
                                                            } else if (GroupSelectedPersonnelRegisterLG.data.filter(function (item) {
                                                                return item.nationalCode == Object.values(XL_row_object[i])[0];
                                                            }).length == 0) {
                                                                let current = {
                                                                    nationalCode: Object.values(XL_row_object[i])[0],
                                                                    firstName: Object.values(XL_row_object[i])[1],
                                                                    lastName: Object.values(XL_row_object[i])[2],
                                                                    birthCertificateNo: Object.values(XL_row_object[i])[3],
                                                                    gender: Object.values(XL_row_object[i])[4],
                                                                    company: Object.values(XL_row_object[i])[5],
                                                                    mobile: Object.values(XL_row_object[i])[6],

                                                                };
                                                                records.add(current);
                                                                isEmpty = false;

                                                                continue;
                                                            } else {
                                                                isEmpty = false;

                                                                continue;
                                                            }
                                                        }

                                                        DynamicForm_GroupInsert_FileUploader_JspRegisterd.setValue('');
                                                    });

                                                    if (records.length > 0) {

                                                        let uniqueRecords = [];

                                                        for (let i = 0; i < records.length; i++) {
                                                            if (uniqueRecords.filter(function (item) {
                                                                return item.nationalCode == records[i].nationalCode;
                                                            }).length == 0) {
                                                                uniqueRecords.push(records[i]);
                                                            }
                                                        }


                                                        GroupSelectedPersonnelRegisterLG.setData(GroupSelectedPersonnelRegisterLG.data.concat(uniqueRecords));
                                                        GroupSelectedPersonnelRegisterLG.invalidateCache();
                                                        GroupSelectedPersonnelRegisterLG.fetchData();


                                                        checkPersonnelRegisteredResponse(checkPersonnelNationalCodes, uniqueRecords.map(function (item) {
                                                            return item.nationalCode;
                                                        }), false);


                                                        createDialog("info", "فایل به لیست اضافه شد.");
                                                    } else {
                                                        if (isEmpty) {
                                                            createDialog("info", "خطا در محتویات فایل");
                                                        } else {
                                                            createDialog("info", "پرسنل جدیدی برای اضافه کردن وجود ندارد.");
                                                        }

                                                    }

                                                };

                                                reader.onerror = function (ex) {
                                                    createDialog("info", "خطا در باز کردن فایل");
                                                };

                                                reader.readAsBinaryString(file);
                                            };
                                        };
                                        let split = $('[name="DynamicForm_GroupInsert_FileUploader_JspRegisterd"]')[0].files[0].name.split('.');

                                        if (split[split.length - 1] == 'xls' || split[split.length - 1] == 'csv' || split[split.length - 1] == 'xlsx') {
                                            var xl2json = new ExcelToJSON();
                                            xl2json.parseExcel($('[name="DynamicForm_GroupInsert_FileUploader_JspRegisterd"]')[0].files[0]);
                                        } else {
                                            createDialog("info", "فایل انتخابی نادرست است. پسوندهای فایل مورد تایید xlsx,xls,csv هستند.");
                                        }

                                    }
                                }
                            },
                            {
                                type: "button",
                                title: "فرمت فايل ورودی",
                                click: function () {
                                    window.open("excel/sample-personel-excel.xlsx");
                                }
                            }
                        ]
                    })
                }
            ]
        });

        let Win_student_GroupInsert = isc.Window.create({
            ID: "Win_student_GroupInsert",

            width: 1050,
            height: 750,
            minWidth: 700,
            minHeight: 500,
            autoSize: false,
            overflow: "hidden",
            title: "اضافه کردن گروهی",
            items: [isc.HLayout.create({
                width: 1050,
                height: "88%",
                autoDraw: false,
                overflow: "auto",
                align: "center",
                members: [
                    isc.TrLG.create({
                        ID: "GroupSelectedPersonnelRegisterLG",
                        showFilterEditor: false,
                        editEvent: "click",
                        //listEndEditAction: "next",
                        enterKeyEditAction: "nextRowStart",
                        canSort: false,
                        canEdit: true,
                        filterOnKeypress: true,
                        selectionType: "single",
                        fields: [
                            {name: "remove", tile: "<spring:message code="remove"/>", isRemoveField: true, width: "10%"},
                            {name: "nationalCode", title: "<spring:message code="national.code"/>", canEdit: false, autoFithWidth: true},
                            {name: "firstName", title: "<spring:message code="firstName"/>", canEdit: false, autoFithWidth: true},
                            {name: "lastName", title: "<spring:message code="lastName"/>", canEdit: false, autoFithWidth: true},
                            {name: "birthCertificateNo", title: "<spring:message code="birth.certificate.no"/>", canEdit: false, autoFithWidth: true},
                            {name: "gender", title: "<spring:message code="gender"/>", canEdit: false, autoFithWidth: true},
                            {name: "company", title: "<spring:message code="company"/>", canEdit: false, autoFithWidth: true},
                            {name: "mobile", title: "<spring:message code="mobile"/>", canEdit: false, autoFithWidth: true},
                            {name: "description", title: "<spring:message code="description"/>", canEdit: false, width: 300, align: "left"},
                            {name: "error", canEdit: false, hidden: true, autoFithWidth: true},
                            {name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".png", canEdit: false}
                        ],
                        gridComponents: [TabSet_RegisteredGroupInsert_JspStudent, "header", "body"],
                        canRemoveRecords: true,
                        deferRemoval: true,
                        removeRecordClick: function (rowNum) {
                            GroupSelectedPersonnelRegisterLG.data.removeAt(rowNum);
                        }
                    })
                ]
            }),
                isc.TrHLayoutButtons.create({
                    members: [
                        isc.IButtonSave.create({
                            top: 260,
                            title: "<spring:message code='save'/>",
                            align: "center",
                            icon: "[SKIN]/actions/save.png",
                            click: function () {

                                // let getEditCells=GroupSelectedPersonnelRegisterLG.getAllEditCells();
                                //
                                //
                                // if(getEditCells.size()!=0){
                                //     let value=GroupSelectedPersonnelRegisterLG.getEditValue(getEditCells[0][0],getEditCells[0][1]);
                                //
                                //     if(value == "" || value == null || typeof(value) == "undefined"){
                                //         GroupSelectedPersonnelRegisterLG.cancelEditing(getEditCells[0][0]);
                                //     }else{
                                //         if(GroupSelectedPersonnelRegisterLG.data.filter(function (item) {
                                //             return item.personnelNo==value;
                                //         }).length==0){
                                //             GroupSelectedPersonnelRegisterLG.saveAndEditNextRow();
                                //         }
                                //         else{
                                //             GroupSelectedPersonnelRegisterLG.cancelEditing(getEditCells[0][0]);
                                //         }
                                //     }
                                // }

                                let len = GroupSelectedPersonnelRegisterLG.data.length;
                                let list = GroupSelectedPersonnelRegisterLG.data;
                                let result = [];

                                for (let index = 0; index < len; index++) {
                                    if (list[index].nationalCode != "" && list[index].nationalCode != null && typeof (list[index].nationalCode) != "undefined") {
                                        if (result.filter(function (item) {
                                            return (item.firstName && item.firstName == GroupSelectedPersonnelRegisterLG.data[index].firstName) || (item.lastName && item.lastName == GroupSelectedPersonnelRegisterLG.data[index].lastName);
                                        }).length == 0) {
                                            result.push(list[index].nationalCode)
                                        }
                                    }
                                }

                                checkPersonnelRegisteredResponse(checkPersonnelNationalCodes, result, true);

                            }
                        }), isc.IButtonCancel.create({
                            top: 260,
                            title: "<spring:message code='cancel'/>",
                            align: "center",
                            icon: "[SKIN]/actions/cancel.png",
                            click: function () {
                                Win_student_GroupInsert.close();
                            }
                        })
                    ]
                })
            ]
        });
        TabSet_RegisteredGroupInsert_JspStudent.selectTab(0);
        Win_student_GroupInsert.show();
    }

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
        personnelRegWait.close();

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

    function checkCodeMeliPerReg(code,nationality) {
        if (nationality!=null && nationality==="غیر ایرانی"){
            return true;
        }

        if (code === undefined || code === null || code === "")
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

    function checkGender(gender) {
        if (gender === undefined || gender === null || gender === "")
            return false;
        if (gender === "مرد" || gender === "زن")
            return true;
        else
            return false;
    };

    function checkEmailPerReg(email) {
        return !(email.indexOf("@") === -1 || email.indexOf(".") === -1 || email.lastIndexOf(".") < email.indexOf("@"));
    };

    function checkMobilePerReg(mobile) {
        if (mobile === undefined || mobile === null || mobile === "")
            return false;
        else
            return mobile[0] === "0" && mobile[1] === "9" && mobile.length === 11;
    };

    function checkPhonePerReg(phone) {
        return (phone[0] === "0" && phone.length === 11) || (phone[0] !== "0" && phone.length === 8);
    };

    function checkPersonalRegNationalCode(nationalCode) {
        if (DynamicForm_PersonnelReg_BaseInfo.getItem("nationalCode").getValue() == tempNationalCode) {
            DynamicForm_PersonnelReg_BaseInfo.clearFieldErrors("nationalCode", true);
            return;
        }

        isc.RPCManager.sendRequest(TrDSRequest(personnelRegByNationalCodeUrl + "getOneByNationalCode/" + nationalCode, "GET", null, "callback: personalReg_findOne_result(rpcResponse)"));
    };

    function personalReg_findOne_result(rpcResponse) {
        // dummy = rpcResponse;
        // if (rpcResponse === null ||  rpcResponse === undefined || rpcResponse.data === "") {
        if (rpcResponse.status != 0) {
            duplicateCodePerReg = true;
            var ERROR = isc.Dialog.create({
                message: ("<spring:message code='msg.national.code.personalReg.duplicate'/>"),
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
    };

    function checkPersonnelRegisteredResponse(url, result, addStudentsInGroupInsert) {
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(url, "POST", JSON.stringify(result)
            , "callback: checkResultForAdd(rpcResponse," + JSON.stringify(result) + ",'" + url + "'," + addStudentsInGroupInsert + ")"));
    }

    function addValidRegisterdStudents(students) {
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(addPerssonelRegisteredList, "POST", JSON.stringify(students), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                GroupSelectedPersonnelRegisterLG.data.clearAll();
                Win_student_GroupInsert.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>", "<spring:message code="error"/>");
            } else {
                wait.close();
                createDialog("info", "<spring:message code="exception.data-validation"/>", "<spring:message code="error"/>");
            }
        }));


    }

    function checkResultForAdd(resp, result, url, insert) {

        if (generalGetResp(resp)) {
            if (resp.httpResponseCode === 200) {
                //------------------------------------*/

                let len = GroupSelectedPersonnelRegisterLG.data.length;
                let list = GroupSelectedPersonnelRegisterLG.data;
                let data = JSON.parse(resp.data);
                let allRowsOK = true;
                let students = [];

                function checkIfAlreadyExist(currentVal, data) {
                    return data.some(function (item) {
                        return (item.nationalCode === currentVal.nationalCode);
                    });
                }

                for (let i = 0; i < len; i++) {

                    let nationalCode = list[i].nationalCode;
                    let mobile = list[i].mobile;

                    if (!result.includes(nationalCode)) {
                        continue;
                    }


                    if (nationalCode !== "" && nationalCode != null && typeof (nationalCode) != "undefined") {
                        let person = data.filter(function (item) {
                            return item.nationalCode === nationalCode;
                        });


                        if (person.length === 0) {
                            if (insert && !checkIfAlreadyExist(list[i], students) && checkCodeMeliPerReg(list[i].nationalCode,null)
                                && checkGender(list[i].gender)
                                && checkMobilePerReg(list[i].mobile)
                            ) {
                                let mobile = {};
                                mobile.mobile = list[i].mobile;


                                students.add({
                                    "personnelNo": list[i].nationalCode,
                                    "firstName": list[i].firstName,
                                    "lastName": list[i].lastName,
                                    "nationalCode": list[i].nationalCode,
                                    "birthCertificateNo": list[i].birthCertificateNo,
                                    "gender": list[i].gender,
                                    "companyName": list[i].company,
                                    "contactInfo": mobile,
                                });

                            }
                            allRowsOK = false;
                            list[i].error = false;
                            list[i].hasWarning = "warning";
                            if (checkCodeMeliPerReg(list[i].nationalCode,null) && checkMobilePerReg(list[i].mobile) && checkGender(list[i].gender))
                                list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">شخصی با کد ملی وارد شده در سیستم وجود ندارد.</span>";
                            else {
                                if (!checkCodeMeliPerReg(list[i].nationalCode,null))
                                    list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">کد ملی وارد شده فرمت صحیحی ندارد.</span>";
                                if (!checkMobilePerReg(list[i].mobile))
                                    list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">شماره تلفن درست وارد نشده است.</span>";
                                if (!checkGender(list[i].gender))
                                    list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">جنسیت درست وارد نشده است.</span>";
                            }

                        } else {
                            person = person[0];

                            if (person.nationalCode === ""
                                || person.nationalCode == null
                                || typeof (person.nationalCode) == "undefined"
                                || person.firstName === ""
                                || person.firstName == null
                                || typeof (person.firstName) == "undefined"
                                || person.lastName === ""
                                || person.lastName == null
                                || typeof (person.lastName) == "undefined"
                                || person.contactInfo.mobile === ""
                                || person.contactInfo.mobile == null
                                || typeof (person.contactInfo.mobile) == "undefined"
                                || person.gender === ""
                                || person.gender == null
                                || typeof (person.gender) == "undefined"
                            ) {
                                allRowsOK = false;
                                list[i].firstName = person.firstName;
                                list[i].lastName = person.lastName;
                                list[i].nationalCode = person.nationalCode;
                                list[i].birthCertificateNo = person.birthCertificateNo;
                                list[i].gender = person.gender;
                                list[i].company = person.companyName;
                                list[i].mobile = person.contactInfo.mobile;

                                list[i].error = true;
                                list[i].hasWarning = "warning";
                                list[i].description = "<span style=\"color:white !important;background-color:#dc3545 !important;padding: 2px;\">اطلاعات شخص مورد نظر ثبت شده است ولی ناقص است.</span>";
                            } else if (checkIfAlreadyExist(person, GroupSelectedPersonnelRegisterLG.data)) {
                                allRowsOK = false;
                                list[i].firstName = person.firstName;
                                list[i].lastName = person.lastName;
                                list[i].nationalCode = person.nationalCode;
                                list[i].birthCertificateNo = person.birthCertificateNo;
                                list[i].gender = person.gender;
                                list[i].company = person.companyName;
                                list[i].mobile = person.contactInfo.mobile;
                                list[i].error = true;
                                list[i].hasWarning = "check";
                                list[i].description = "<span style=\"color:white !important;background-color:#11b40b !important;padding: 2px;\">این شخص قبلا اضافه شده است.</span>";
                            } else {
                                list[i].firstName = person.firstName;
                                list[i].lastName = person.lastName;
                                list[i].nationalCode = person.nationalCode;
                                list[i].error = false;
                                list[i].birthCertificateNo = person.birthCertificateNo;
                                list[i].gender = person.gender;
                                list[i].company = person.companyName;
                                list[i].mobile = person.contactInfo.mobile;
                                list[i].hasWarning = "check";
                                list[i].description = "";
                            }
                        }
                    }
                }

                if (students.getLength() > 0 /*allRowsOK*/ && insert) {

                    GroupSelectedPersonnelRegisterLG.endEditing();

                    wait.close();
                    addValidRegisterdStudents(students);


                } else {

                    GroupSelectedPersonnelRegisterLG.invalidateCache();
                    GroupSelectedPersonnelRegisterLG.fetchData();
                    wait.close();
                    if (insert) {
                        createDialog('info', 'شخصي جهت اضافه شدن وجود ندارد.');
                    }
                }

            } else {
                wait.close();
            }
        } else {
            wait.close();
        }
    }


    // </script>
