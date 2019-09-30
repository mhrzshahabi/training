<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    <%
        final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    %>

    var instituteMethod = "POST";
    var reqMethod = "POST";
    var instituteWait;
    var institute_Institute_Url = rootUrl + "/institute/";
    var institute_Institute_Account_Url = rootUrl + "/institute-account/";
    var institute_Bank_Url = rootUrl + "/bank/";
    var institute_BankBranch_Url = rootUrl + "/bank-branch/";
    var mailCheck = true;

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//


    var RestDataSource_Institute_Institute = isc.MyRestDataSource.create({
        fields: [

            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "stateId"},
            {name: "cityId"},
            {name: "state.name"},
            {name: "city.name"},
            {name: "restAddress"},
            {name: "postCode"},
            {name: "phone"},
            {name: "mobile"},
            {name: "fax"},
            {name: "email"},
            {name: "webSite"},
            {name: "teacherNumPHD"},
            {name: "empNumPHD"},
            {name: "teacherNumLicentiate"},
            {name: "empNumLicentiate"},
            {name: "teacherNumMaster"},
            {name: "empNumMaster"},
            {name: "teacherNumAssociate"},
            {name: "empNumAssociate"},
            {name: "teacherNumDiploma"},
            {name: "empNumDiploma"},
            {name: "managerId"},
            {name: "manager.firstNameFa"},
            {name: "manager.lastNameFa"},
            {name: "manager.nationalCode"},
            {name: "parentInstituteId"},
            {name: "parentInstitute.titleFa"},
            {name: "einstituteType.titleFa"},
            {name: "elicenseType.titleFa"},
            {name: "version"}
        ],
        fetchDataURL: institute_Institute_Url + "spec-list"
    });

    var RestDataSource_Institute_Institute_Account = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "instituteId"},
            {name: "bank.titleFa"},
            {name: "bankBranch.titleFa"},
            {name: "bankId"},
            {name: "bankBranchId"},
            {name: "accountNumber"},
            {name: "cartNumber"},
            {name: "shabaNumber"},
            {name: "accountOwnerName"},
            {name: "isEnable"},
            {name: "description"}
        ],
        fetchDataURL: institute_Institute_Url + "account-dummy"
    });

    var RestDataSource_Institute_TrainingPlace = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "institute.titleFa"},
            {name: "instituteId"},
            {name: "capacity"},
            {name: "ePlaceType.titleFa"},
            {name: "eArrangementType.titleFa"},
            {name: "description"}
        ],
        fetchDataURL: institute_Institute_Url + "training-place/0"
    });
    var RestDataSource_Institute_TrainingPlace_Equipment = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: institute_Institute_Url + "training-place-equipment/0"
    });

    var RestDataSource_Institute_Institite_Equipment = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: institute_Institute_Url + "equipment-dummy"
    });
    var RestDataSource_Institute_Institite_UnAttachedEquipment = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: institute_Institute_Url + "0/unattached-equipments"
    });

    var RestDataSource_Institute_Institite_Teacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "teacherCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"},
            {name: "economicalCode"},
            {name: "economicalRecordNumber"}
        ],
        fetchDataURL: institute_Institute_Url + "teacher-dummy"
    });
    var RestDataSource_Institute_Institite_UnAttachedTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "teacherCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"},
            {name: "economicalCode"},
            {name: "economicalRecordNumber"}
        ],
        fetchDataURL: institute_Institute_Url + "0/unattached-teachers"
    });

    var RestDataSource_Institute_City = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: cityUrl + "spec-list"
    });
    var RestDataSource_Institute_State = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: stateUrl + "spec-list"
    });

    var RestDataSource_Institute_Bank = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "ebankTypeId"},
            {name: "ebankType.titleFa"}
        ],
        fetchDataURL: institute_Bank_Url + "spec-list"
    });
    var RestDataSource_Institute_BankBranch = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "code"},
            {name: "titleFa"},
            {name: "c_title_en"},
            {name: "bankId"},
            {name: "bank.titleFa"},
            {name: "addressId"},
            {name: "address.restAddress"}
        ],
        fetchDataURL: institute_Bank_Url + "bank-branches"
    });

    var RestDataSource_Institute_EPlaceType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "ePlaceType/spec-list"
    });
    var RestDataSource_Institute_EArrangementType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eArrangementType/spec-list"
    });
    var RestDataSource_Institute_EInstituteType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eInstituteType/spec-list"
    });
    var RestDataSource_Institute_ELicenseType = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eLicenseType/spec-list"
    });

    var RestDataSource_Institute_PersonalInfo_List = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "firstNameFa"},
            {name: "lastNameFa"},
            {name: "fatherName"},
            {name: "nationalCode"},
            {name: "birthDate"}
        ],
        fetchDataURL: personalInfoUrl + "spec-list"
    });
    var RestDataSource_Institute_Institute_List = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "manager.firstNameFa"},
            {name: "manager.lastNameFa"},
            {name: "parentInstitute.titleFa"},
            {name: "einstituteType.titleFa"},
            {name: "elicenseType.titleFa"}
        ],
        fetchDataURL: institute_Institute_Url + "spec-list"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_Institute_Institute = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Institute_Institute_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Institute_Institute_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_Institute_Institute_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>", click: function () {
                ListGrid_Institute_Institute_Remove();
            }
        }, {isSeparator: true}]
        <%--{title: "<spring:message code='print.pdf'/>", icon: "<spring:url value="pdf.png"/>", click: function () {--%>
        <%--ListGrid_institute_print("pdf");--%>
        <%--}},--%>
        <%--{--%>
        <%--title: "<spring:message code='print.excel'/>", icon: "<spring:url value="excel.png"/>", click: function () {--%>
        <%--ListGrid_institute_print("excel");--%>
        <%--}--%>
        <%--},--%>
        <%--{--%>
        <%--title: "<spring:message code='print.html'/>", icon: "<spring:url value="html.png"/>", click: function () {--%>
        <%--ListGrid_institute_print("html");--%>
        <%--}--%>
        <%--}]--%>

    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Listgrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Institute_Institute = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institute,
        contextMenu: Menu_ListGrid_Institute_Institute,
        doubleClick: function () {
            ListGrid_Institute_Institute_Edit();
        },
        selectionChanged: function (record, state) {
            if (record == null) {
                RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + "equipment-dummy";
                RestDataSource_Institute_Institite_Teacher.fetchDataURL = institute_Institute_Url + "teacher-dummy";
                RestDataSource_Institute_Institute_Account.fetchDataURL = "";
                ListGrid_Institute_Institute_Account.invalidateCache();
//                ListGrid_Institute_Institute_Account.clearData();
            } else {
                RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + record.id + "/equipments";
                RestDataSource_Institute_Institite_Teacher.fetchDataURL = institute_Institute_Url + record.id + "/teachers";
                RestDataSource_Institute_Institute_Account.fetchDataURL = institute_Institute_Url + record.id + "/accounts";
                ListGrid_Institute_Institute_Account.invalidateCache();
                ListGrid_Institute_Institute_Account.fetchData();
            }
            ListGrid_Institute_Attached_Equipment.invalidateCache();
            ListGrid_Institute_Attached_Teacher.invalidateCache();
            ListGrid_Institute_Attached_Equipment.fetchData();
            ListGrid_Institute_Attached_Teacher.fetchData();
        },
        dataArrived: function (startRow, endRow) {
            record = ListGrid_Institute_Institute.getSelectedRecord();
            if (record == null) {
                RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + "equipment-dummy";
                RestDataSource_Institute_Institite_Teacher.fetchDataURL = institute_Institute_Url + "teacher-dummy";
                RestDataSource_Institute_Institute_Account.fetchDataURL = "";
                ListGrid_Institute_Institute_Account.invalidateCache();
                // ListGrid_Institute_Institute_Account.clearData();
            } else {
                RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + record.id + "/equipment-dummy";
                RestDataSource_Institute_Institite_Teacher.fetchDataURL = institute_Institute_Url + record.id + "/teachers";
                RestDataSource_Institute_Institute_Account.fetchDataURL = institute_Institute_Url + record.id + "/accounts";
                ListGrid_Institute_Institute_Account.invalidateCache();
                ListGrid_Institute_Institute_Account.fetchData();
            }
            ListGrid_Institute_Attached_Equipment.invalidateCache();
            ListGrid_Institute_Attached_Teacher.invalidateCache();
            ListGrid_Institute_Attached_Equipment.fetchData();
            ListGrid_Institute_Attached_Teacher.fetchData();


        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان فارسی", align: "center", filterOperator: "iContains"},
            {name: "titleEn", title: "عنوان لاتین", align: "center", filterOperator: "iContains"},
            {name: "manager.firstNameFa", title: "نام مدیر", align: "center", filterOperator: "iContains"},
            {name: "manager.lastNameFa", title: "نام خانوادگی مدیر", align: "center", filterOperator: "iContains"},
            {name: "parentInstitute.titleFa", title: "موسسه مادر", align: "center", filterOperator: "iContains"},
            {name: "einstituteType.titleFa", title: "نوع موسسه", align: "center", filterOperator: "iContains"},
            {name: "elicenseType.titleFa", title: "نوع مدرک", align: "center", filterOperator: "iContains"},
            {name: "state.name", hidden: true},
            {name: "city.name", hidden: true},
            {name: "restAddress", hidden: true},
            {name: "stateId", hidden: true},
            {name: "cityId", hidden: true},
            {name: "postCode", hidden: true},
            {name: "phone", hidden: true},
            {name: "fax", hidden: true},
            {name: "mobile", hidden: true},
            {name: "email", hidden: true},
            {name: "webSite", hidden: true},
            {name: "teacherNumPHD", hidden: true},
            {name: "empNumPHD", hidden: true},
            {name: "teacherNumLicentiate", hidden: true},
            {name: "empNumLicentiate", hidden: true},
            {name: "teacherNumMaster", hidden: true},
            {name: "empNumMaster", hidden: true},
            {name: "teacherNumAssociate", hidden: true},
            {name: "empNumAssociate", hidden: true},
            {name: "teacherNumDiploma", hidden: true},
            {name: "empNumDiploma", hidden: true},
            {name: "managerId", hidden: true},
            {name: "parentInstituteId", hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });


    var ListGrid_Institute_Attached_Teacher = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_Teacher,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "teacherCode", title: "کد", align: "center"},
            {name: "personality.firstNameFa", title: "نام", align: "center"},
            {name: "personality.lastNameFa", title: "نام خانوادگی ", align: "center"},
            {name: "personality.nationalCode", title: "کد ملی", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        autoDraw: false,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });
    var ListGrid_Institute_Attached_Equipment = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_Equipment,
        doubleClick: function () {
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد", align: "center"},
            {name: "titleFa", title: "عنوان فارسی", align: "center"},
            {name: "titleEn", title: "عنوان لاتین ", align: "center"},
            {name: "description", title: "ملاحظات", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        autoDraw: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });
    var ListGrid_Institute_Institute_Account = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        autoDraw: false,

        dataSource: RestDataSource_Institute_Institute_Account,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "bank.titleFa", title: "بانک", align: "center"},
            {name: "bankBranch.titleFa", title: "شعبه بانک", align: "center"},
            {name: "accountNumber", title: "شماره حساب ", align: "center"},
            {name: "cartNumber", title: "شماره کارت", align: "center"},
            {name: "shabaNumber", title: "شماره شبا", align: "center"},
            {name: "accountOwnerName", title: "نام صاحب حساب", align: "center"},
            {name: "isEnable", title: "فعال؟", align: "center"},
            {name: "description", title: "توضیحات", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });

    // var ListGrid_Institute_TrainingPlace = isc.ListGrid.create({
    // width: "100%",
    // height: "100%",
    // dataSource: RestDataSource_Institute_TrainingPlace,
    // doubleClick: function () {
    //
    // },
    // fields: [
    // {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
    // {name: "titleFa", title: "عنوان فارسی", align: "center"},
    // {name: "titleEn", title: "عنوان لاتین ", align: "center"},
    // {name: "capacity", title: "ظرفیت", align: "center"},
    // {name: "ePlaceType.titleFa", title: "نوع محل", align: "center"},
    // {name: "eArrangementType.titleFa", title: "شکل/ترتیب", align: "center"}
    // ],
    // selectionType: "multiple",
    // sortField: 1,
    // sortDirection: "descending",
    // dataPageSize: 50,
    // autoFetchData: false,
    // showFilterEditor: true,
    // filterOnKeypress: true,
    // sortFieldAscendingText: "مرتب سازی صعودی ",
    // sortFieldDescendingText: "مرتب سازی نزولی",
    // configureSortText: "تنظیم مرتب سازی",
    // autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
    // autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
    // filterUsingText: "فیلتر کردن",
    // groupByText: "گروه بندی",
    // freezeFieldText: "ثابت نگه داشتن"
    // });

    var ListGrid_Institute_Institute_List = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institute_List,
        doubleClick: function () {
            Function_Institute_InstituteList_Selected();
        },

        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان فارسی", align: "center", filterOperator: "contains"},
            {name: "titleEn", title: "عنوان لاتین", align: "center", filterOperator: "contains"},
            {name: "manager.firstNameFa", title: "نام مدیر", align: "center", filterOperator: "contains"},
            {name: "manager.lastNameFa", title: "نام خانوادگی مدیر", align: "center", filterOperator: "contains"},
            {name: "parentInstitute.titleFa", title: "موسسه مادر", align: "center", filterOperator: "contains"},
            {name: "einstituteType.titleFa", title: "نوع موسسه", align: "center", filterOperator: "contains"},
            {name: "elicenseType.titleFa", title: "نوع مدرک", align: "center", filterOperator: "contains"}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });
    var ListGrid_Institute_PersonalInfo_List = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_PersonalInfo_List,
        doubleClick: function () {
            Function_Institute_InstituteList_Selected
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "firstNameFa",
                title: "نام",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "lastNameFa",
                title: "نام خانوادگی",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "fatherName",
                title: "نام پدر",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "nationalCode",
                title: "کد ملی",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "birthDate",
                title: "تاریخ تولد",
                align: "center",
                filterOperator: "contains"
            }

        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"

    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//
    var ValuesManager_Institute_InstituteValue = isc.ValuesManager.create({});

    var DynamicForm_Institute_Institute = isc.DynamicForm.create({
        width: "100%",
// height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "ValuesManager_Institute_InstituteValue",
        numCols: 6,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 2,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "addressId",
                hidden: true
            },
            {
                name: "accountInfoId",
                hidden: true
            },
            {
                name: "managerId", hidden: true
            },
            {
                name: "titleFa",
                title: "عنوان فارسی",
                colSpan: 2,
                required: true,
                width: "*",
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "255"
            },
            {
                name: "titleEn",
                title: "عنوان لاتین",
                colSpan: 2,
                width: "*",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9| ]",
                length: "255"
            },
            {
                name: "parentInstituteId",
                title: "موسسه مادر",
                iconWidth: 16,
                iconHeight: 16,
                suppressBrowserClearIcon: true,
                icons: [{
                    name: "add",
                    src: "[SKIN]/actions/add.png",
                    click: function (form, item, icon) {
                        ListGrid_Institute_InstituteList_Select();
                    },
                }],
// canEdit: false,
                click: function (form, item, icon) {
                    ListGrid_Institute_InstituteList_Select();
                },
                readOnly: true,
                type: 'text',
                keyPressFilter: "[]",
                width: "*",
                length: "10"
            },
            {
                name: "parentInstitute.titleFa",
                title: "عنوان موسسه مادر",
                showTitle: false,
                canEdit: false,
                colSpan: 4,
                width: "*",
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "255"
            },
            {
                name: "manager.nationalCode",
                title: "مدیر موسسه",
                icons: [{
                    name: "add",
                    src: "[SKIN]/actions/add.png",
                    align: "right", // if inline icons are not supported by the browser, revert to a blank icon
                    click: function (form, item, icon) {
                        ListGrid_Institute_PersonalList_Select();
                    }
                }],
                width: "*",
                type: 'text',
                required: true,
                keyPressFilter: "[0-9]",
                click: function (form, item, icon) {

                    ListGrid_Institute_PersonalList_Select();
                },
                length: "30"
            },
            {
                name: "manager.firstNameFa",
                title: "<spring:message code='account.number'/>",
                showTitle: false,
                canEdit: false,
                colSpan: 2,
                width: "*",
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "30"
            },
            {
                name: "manager.lastNameFa",
                title: "<spring:message code='cart.number'/>",
                canEdit: false,
                showTitle: false,
                colSpan: 2,
                width: "*",
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "30"
            },
            {
                name: "einstituteTypeId",
                type: "IntegerItem",
                colSpan: 2,
                title: "نوع موسسه",
                width: "*",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Institute_EInstituteType,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                required: true,
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}],
            },
            {
                name: "elicenseTypeId",
                type: "IntegerItem",
                title: "نوع مدرک",
                colSpan: 2,
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_Institute_ELicenseType,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}],
            }
        ]

    });
    var DynamicForm_Institute_InstituteTeacherNum = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "ValuesManager_Institute_InstituteValue",
        numCols: 4,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 2,
        newPadding: 5,
        fields: [
            {
                name: "teacherNumPHD",
                title: "دکتری",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "teacherNumLicentiate",
                title: "لیسانس",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "teacherNumMaster",
                title: "فوق لیسانس",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "teacherNumAssociate",
                title: "فوق دیپلم",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "teacherNumDiploma",
                title: "دیپلم/زیردیپلم",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            }
        ]
    });
    var DynamicForm_Institute_InstituteEmpNum = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "ValuesManager_Institute_InstituteValue",
        numCols: 4,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 2,
        newPadding: 5,
        fields: [
            {
                name: "empNumPHD",
                title: "دکتری",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "empNumLicentiate",
                title: "لیسانس",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "empNumMaster",
                title: "فوق لیسانس",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "empNumAssociate",
                title: "فوق دیپلم",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "empNumDiploma",
                title: "دیپلم/زیردیپلم",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            }
        ]

    });
    var DynamicForm_Institute_Institute_Address = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        valuesManager: "ValuesManager_Institute_InstituteValue",
        errorOrientation: "right",
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        fields: [
            {
                name: "stateId",
                type: "IntegerItem",
                title: "استان",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_Institute_State,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {name: "name", width: "30%", filterOperator: "iContains"}],
            },
            {
                name: "cityId",
                type: "IntegerItem",
                title: "شهر",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
// defaultToFirstOption: true,
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_Institute_City,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {name: "name", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "postCode",
                title: "کد پستی",
                keyPressFilter: "[0-9|-| ]",
                width: "*",
                length: "11",
            },
            {
                name: "phone",
                keyPressFilter: "[0-9|-]",
                title: "تلفن",
                width: "*",
                length: "12"
            },
            {
                name: "mobile",
                keyPressFilter: "[0-9|-]",
                title: "تلفن",
                width: "*",
                length: "12"
            },
            {
                name: "fax",
                title: "فکس",
                keyPressFilter: "[0-9|-]",
                width: "*",
                length: "12"
            },
            {
                name: "email",
                title: "فکس",
                keyPressFilter: "[0-9|-]",
                width: "*",
                length: "12"
            },
            {
                name: "webSite",
                title: "وب سایت",
                width: "*",
                length: "100"
            },
            {
                name: "restAddress",
                title: "آدرس",
                required: true,
                colSpan: 3,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                width: "*",
                type: 'textArea',
                length: "255"
            }
        ],

        itemChanged: function (item, newValue) {
            if (item.name == "stateId") {
                if (newValue == undefined) {
                    DynamicForm_Institute_Institute_Address.clearValue("cityId");
                } else {
                    RestDataSource_Institute_City.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    DynamicForm_Institute_Institute_Address.getField("cityId").optionDataSource = RestDataSource_Institute_City;
                    DynamicForm_Institute_Institute_Address.getField("cityId").fetchData();
                    DynamicForm_Institute_Institute_Address.clearValue("cityId");
                }
            }
        }

    });


    var TabSet_Institute_InstituteTeacherNum = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
// height: "100%",
        width: "48%",
        newPadding: 5,
        tabs: [
            {
                title: "تعداد اساتید", canClose: false,
                pane: DynamicForm_Institute_InstituteTeacherNum
            }
        ]
    });
    var TabSet_Institute_InstituteEmpNum = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
// height: "100%",
        width: "48%",
// margin:5,
        newPadding: 5,
        tabs: [
            {
                title: "تعداد کارمندان", canClose: false, titleWidth: this.width,
                pane: DynamicForm_Institute_InstituteEmpNum
            }
        ]
    });
    var TabSet_Institute_InstituteAddress = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "100%",
        width: "100%",
        padding: 5,
        tabs: [
            {
                title: "ارتباط با موسسه", canClose: false,
                pane: DynamicForm_Institute_Institute_Address
            }
        ]
    });

    var HLayout_Institute_InstituteTeacherAndEmp = isc.HLayout.create({
        width: "100%",
// height: 250,
// margin:5,
        padding: 5,

        members: [TabSet_Institute_InstituteEmpNum, isc.LayoutSpacer.create({width: "5"}), TabSet_Institute_InstituteTeacherNum]
    });


    // var VLayout_Institute_Institute_Val = isc.VLayout.create({
    // width: "100%",
    // height: "50%",
    // // border: "1px solid blue",
    // padding: 5,
    // members: [HLayout_Institute_InstituteTeacherAndEmp]
    // });

    var VLayout__Institute_Institute_Address = isc.VLayout.create({
        width: "100%",
// height: "25%",
// border: "1px solid blue",
        members: [TabSet_Institute_InstituteAddress]
    });


    var IButton_Institute_Institute_Exit = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_Institute.close();
        }
    });

    var IButton_Institute_Institute_Save = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {


            ValuesManager_Institute_InstituteValue.validate();
            if (ValuesManager_Institute_InstituteValue.hasErrors()) {
                return;
            }

            var data = ValuesManager_Institute_InstituteValue.getValues();
            var instituteSaveUrl = institute_Institute_Url;
            if (instituteMethod.localeCompare("PUT") == 0) {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                instituteSaveUrl += instituteRecord.id;
            }
            isc.RPCManager.sendRequest(MyDsRequest(instituteSaveUrl, instituteMethod, JSON.stringify(data), "callback: institute_Save_action_result(rpcResponse)"));
        }
    });

    function institute_Save_action_result(resp) {
        var respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            ListGrid_Institute_Institute.invalidateCache();
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",

            });

            setTimeout(function () {
                MyOkDialog_job.close();

            }, 3000);

            Window_Institute_Institute.close();

        } else {
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });

            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);
        }
    };


    var VLayout_Institute_Institute_Form = isc.VLayout.create({
        width: "100%",
        height: "590 ",
        members: [
            DynamicForm_Institute_Institute,
            HLayout_Institute_InstituteTeacherAndEmp,
            VLayout__Institute_Institute_Address]
    });

    var HLayOut_Institute_InstituteSaveOrExit = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Institute_Institute_Save, IButton_Institute_Institute_Exit]
    });

    var Window_Institute_Institute = isc.Window.create({
        title: "<spring:message code='training.institute'/>",
        width: 800,
        height: 600,
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
            members: [VLayout_Institute_Institute_Form, HLayOut_Institute_InstituteSaveOrExit]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*picklist ...*/
    //--------------------------------------------------------------------------------------------------------------------//

    var IButton_Institute_InstituteList_Exit = isc.IButton.create({
        top: 260,
        title: "لغو",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_InstituteList.close();
        }
    });

    var IButton_Institute_InstituteList_Choose = isc.IButton.create({
        top: 260,
        title: "انتخاب",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {
            Function_Institute_InstituteList_Selected();
        }
    });


    var VLayout_Institute_InstituteList = isc.VLayout.create({
        width: "100%",
        height: "690",
        members: [ListGrid_Institute_Institute_List]
    });

    var HLayOut_Institute_InstituteList_Select = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Institute_InstituteList_Choose, IButton_Institute_InstituteList_Exit]
    });

    var Window_Institute_InstituteList = isc.Window.create({
        title: "انتخاب موسسه آموزشی مادر",
        width: 800,
        height: 700,
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
            members: [VLayout_Institute_InstituteList, HLayOut_Institute_InstituteList_Select]
        })]
    });

    function ListGrid_Institute_InstituteList_Select() {
        ListGrid_Institute_Institute_List.invalidateCache();
        ListGrid_Institute_Institute_List.fetchData();
        Window_Institute_InstituteList.show();
        Window_Institute_InstituteList.bringToFront();
    };

    function Function_Institute_InstituteList_Selected() {
        var record = ListGrid_Institute_Institute_List.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "هیچ مرکز آموزشی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
//console.log('record:' + JSON.stringify(record));
            var id = record.id;
            var name = record.titleFa;
            DynamicForm_Institute_Institute.getItem("parentInstituteId").setValue(id);
            DynamicForm_Institute_Institute.getItem("parentInstitute.titleFa").setValue(name);
            Window_Institute_InstituteList.close();

        }

    }


    var IButton_Institute_PersonalList_Exit = isc.IButton.create({
        top: 260,
        title: "لغو",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_PersonalList.close();
        }
    });

    var IButton_Institute_PersonalList_Choose = isc.IButton.create({
        top: 260,
        title: "انتخاب",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {
            Function_Institute_PersonalList_Selected();
        }
    });


    var VLayout_Institute_PersonalList = isc.VLayout.create({
        width: "100%",
        height: "690",
        members: [ListGrid_Institute_PersonalInfo_List]
    });

    var HLayOut_Institute_PersonalList_Select = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Institute_PersonalList_Choose, IButton_Institute_PersonalList_Exit]
    });

    var Window_Institute_PersonalList = isc.Window.create({
        title: "انتخاب موسسه آموزشی مادر",
        width: 800,
        height: 700,
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
            members: [VLayout_Institute_PersonalList, HLayOut_Institute_PersonalList_Select]
        })]
    });

    function ListGrid_Institute_PersonalList_Select() {
        ListGrid_Institute_PersonalInfo_List.invalidateCache();
        ListGrid_Institute_PersonalInfo_List.fetchData();
        Window_Institute_PersonalList.show();
        Window_Institute_PersonalList.bringToFront();
    };

    function Function_Institute_PersonalList_Selected() {
        var record = ListGrid_Institute_PersonalInfo_List.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "هیچ فردی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
//console.log('record:' + JSON.stringify(record));
            var id = record.id;
            var nc = record.nationalCode;
            var fName = record.firstNameFa;
            var lName = record.lastNameFa;
            DynamicForm_Institute_Institute.getItem("managerId").setValue(id);
            DynamicForm_Institute_Institute.getItem("manager.nationalCode").setValue(nc);
            DynamicForm_Institute_Institute.getItem("manager.firstNameFa").setValue(fName);
            DynamicForm_Institute_Institute.getItem("manager.lastNameFa").setValue(lName);
            Window_Institute_PersonalList.close();

        }

    }


    //--------------------------------------------------------------------------------------------------------------------//
    /*Edit Equipments For Institute*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Institute_Equipment_List = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_UnAttachedEquipment,
        doubleClick: function () {
            Function_Institute_EquipmentList_Selected();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد", align: "center"},
            {name: "titleFa", title: "عنوان فارسی", align: "center"},
            {name: "titleEn", title: "عنوان لاتین ", align: "center"},
            {name: "description", title: "ملاحظات", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });

    var IButton_Institute_EquipmentList_Exit = isc.IButton.create({
        top: 260,
        title: "لغو",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_EquipmentList.close();
        }
    });

    var IButton_Institute_EquipmentList_Choose = isc.IButton.create({
        top: 260,
        title: "انتخاب",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {
            Function_Institute_EquipmentList_Selected();
        }
    });


    var ToolStripButton_Institute_Equipment_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "افزودن",
        click: function () {
            var record = ListGrid_Institute_Institute.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "لطفا یک مرکز آموزشی را انتخاب کنید.",
                    icon: "[SKIN]ask.png",
                    title: "توجه",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                Function_Institute_EquipmentList_Select(record.id);
            }
        }
    });
    var ToolStripButton_Institute_Equipment_Delete = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            var record = ListGrid_Institute_Attached_Equipment.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "لطفا یک تجهیز را انتخاب کنید.",
                    icon: "[SKIN]ask.png",
                    title: "توجه",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                Function_Institute_Equipment_Remove();
            }
        }
    });
    var ToolStrip_Institute_Equipment = isc.ToolStrip.create({
        width: "20",
        center: true,
        members: [
            ToolStripButton_Institute_Equipment_Add, ToolStripButton_Institute_Equipment_Delete
        ]
    });


    var VLayout_Institute_EquipmentList = isc.VLayout.create({
        width: "100%",
        height: "690",
        members: [ListGrid_Institute_Equipment_List]
    });

    var HLayOut_Institute_EquipmentList_Select = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Institute_EquipmentList_Choose, IButton_Institute_EquipmentList_Exit]
    });

    var Window_Institute_EquipmentList = isc.Window.create({
        title: "انتخاب تجهیزات کمک آموزشی",
        width: 800,
        height: 700,
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
            members: [VLayout_Institute_EquipmentList, HLayOut_Institute_EquipmentList_Select]
        })]
    });

    function Function_Institute_EquipmentList_Select(instituteId) {
        RestDataSource_Institute_Institite_UnAttachedEquipment.fetchDataURL = institute_Institute_Url + instituteId + "/unattached-equipments"
        ListGrid_Institute_Equipment_List.invalidateCache();
        ListGrid_Institute_Equipment_List.fetchData();
        Window_Institute_EquipmentList.show();
        Window_Institute_EquipmentList.bringToFront();
    };

    function Function_Institute_EquipmentList_Selected() {

        if (ListGrid_Institute_Equipment_List.getSelectedRecord() != null) {
// console.log(ListGrid_Institute_Equipment_List.getSelectedRecords().getLength());
            var selectedEquipmentRecords = ListGrid_Institute_Equipment_List.getSelectedRecords();
            if (selectedEquipmentRecords.getLength() > 1) {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;

                var equipmentIds = new Array();
                for (i = 0; i < selectedEquipmentRecords.getLength(); i++) {
                    equipmentIds.add(selectedEquipmentRecords[i].id);
                }
                var JSONObj = {"ids": equipmentIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: institute_Institute_Url + "add-equipment-list/" + instituteId,
                    httpMethod: "POST",
                    data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + instituteId + "/equipments"
                            ListGrid_Institute_Attached_Equipment.invalidateCache();
                            ListGrid_Institute_Attached_Equipment.fetchData();
                            Window_Institute_EquipmentList.close();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });


            } else {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;
                var equipmentRecord = ListGrid_Institute_Equipment_List.getSelectedRecord();
                var equipmentId = equipmentRecord.id;
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: institute_Institute_Url + "add-equipment/" + equipmentId + "/" + instituteId,
                    httpMethod: "POST",
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + instituteId + "/equipments"
                            ListGrid_Institute_Attached_Equipment.invalidateCache();
                            ListGrid_Institute_Attached_Equipment.fetchData();
                            Window_Institute_EquipmentList.close();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });
            }

        }
    }

    function Function_Institute_Equipment_Remove() {
        var selectedAttachedEquipmentRecords = ListGrid_Institute_Attached_Equipment.getSelectedRecords();
        if (selectedAttachedEquipmentRecords != null) {
            if (selectedAttachedEquipmentRecords.getLength() > 1) {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;
                var equipmentRecords = ListGrid_Institute_Attached_Equipment.getSelectedRecords();
                var equipmentIds = new Array();
                for (i = 0; i < equipmentRecords.getLength(); i++) {
                    equipmentIds.add(equipmentRecords[i].id);
                }
// var JSONObj = {"ids": skillGroupIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: institute_Institute_Url + "remove-equipment-list/" + equipmentIds + "/" + instituteId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Institute_Attached_Equipment.invalidateCache();
                            ListGrid_Institute_Attached_Equipment.fetchData();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });
            } else {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;
                var equipmentRecord = ListGrid_Institute_Attached_Equipment.getSelectedRecord();
                var equipmentId = equipmentRecord.id;
// var JSONObj = {"ids": courseIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: institute_Institute_Url + "remove-equipment/" + equipmentId + "/" + instituteId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Institute_Attached_Equipment.invalidateCache();
                            ListGrid_Institute_Attached_Equipment.fetchData();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });
            }

        }

    }

    //--------------------------------------------------------------------------------------------------------------------//
    /*Edit Teachers For Institute*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Institute_Teacher_List = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_UnAttachedTeacher,
        doubleClick: function () {
            Function_Institute_TeacherList_Selected();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "teacherCode", title: "کد", align: "center"},
            {name: "personality.firstNameFa", title: "نام", align: "center"},
            {name: "personality.lastNameFa", title: "نام خانوادگی ", align: "center"},
            {name: "personality.nationalCode", title: "کد ملی", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });

    var IButton_Institute_TeacherList_Exit = isc.IButton.create({
        top: 260,
        title: "لغو",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_TeacherList.close();
        }
    });

    var IButton_Institute_TeacherList_Choose = isc.IButton.create({
        top: 260,
        title: "انتخاب",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {
            Function_Institute_TeacherList_Selected();
        }
    });


    var ToolStripButton_Institute_Teacher_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "افزودن",
        click: function () {
            var record = ListGrid_Institute_Institute.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "لطفا یک مرکز آموزشی را انتخاب کنید.",
                    icon: "[SKIN]ask.png",
                    title: "توجه",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                Function_Institute_TeacherList_Select(record.id);
            }
        }
    });

    var ToolStripButton_Institute_Teacher_Delete = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            var record = ListGrid_Institute_Attached_Teacher.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "لطفا یک استاد را انتخاب کنید.",
                    icon: "[SKIN]ask.png",
                    title: "توجه",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                Function_Institute_Teacher_Remove();
            }
        }
    });

    var ToolStrip_Institute_Teacher = isc.ToolStrip.create({
        width: "20",
        center: true,
        members: [
            ToolStripButton_Institute_Teacher_Add, ToolStripButton_Institute_Teacher_Delete
        ]
    });


    var VLayout_Institute_TeacherList = isc.VLayout.create({
        width: "100%",
        height: "690",
        members: [ListGrid_Institute_Teacher_List]
    });

    var HLayOut_Institute_TeacherList_Select = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Institute_TeacherList_Choose, IButton_Institute_TeacherList_Exit]
    });

    var Window_Institute_TeacherList = isc.Window.create({
        title: "انتخاب اساتید",
        width: 800,
        height: 700,
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
            members: [
                VLayout_Institute_TeacherList,
                HLayOut_Institute_TeacherList_Select
            ]
        })]
    });

    function Function_Institute_TeacherList_Select(instituteId) {
        RestDataSource_Institute_Institite_UnAttachedTeacher.fetchDataURL = institute_Institute_Url + instituteId + "/unattached-teachers"
        ListGrid_Institute_Teacher_List.invalidateCache();
        ListGrid_Institute_Teacher_List.fetchData();
        Window_Institute_TeacherList.show();
        Window_Institute_TeacherList.bringToFront();
    };

    function Function_Institute_TeacherList_Selected() {

        if (ListGrid_Institute_Teacher_List.getSelectedRecord() != null) {
// console.log(ListGrid_Institute_Teacher_List.getSelectedRecords().getLength());
            var selectedTeacherRecords = ListGrid_Institute_Teacher_List.getSelectedRecords();
            if (selectedTeacherRecords.getLength() > 1) {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;

                var teacherIds = new Array();
                for (i = 0; i < selectedTeacherRecords.getLength(); i++) {
                    teacherIds.add(selectedTeacherRecords[i].id);
                }
                var JSONObj = {"ids": teacherIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: institute_Institute_Url + "add-teacher-list/" + instituteId,
                    httpMethod: "POST",
                    data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            RestDataSource_Institute_Institite_Teacher.fetchDataURL = institute_Institute_Url + instituteId + "/teachers"
                            ListGrid_Institute_Attached_Teacher.invalidateCache();
                            ListGrid_Institute_Attached_Teacher.fetchData();
                            Window_Institute_TeacherList.close();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });


            } else {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;
                var teacherRecord = ListGrid_Institute_Teacher_List.getSelectedRecord();
                var teacherId = teacherRecord.id;
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: institute_Institute_Url + "add-teacher/" + teacherId + "/" + instituteId,
                    httpMethod: "POST",
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            RestDataSource_Institute_Institite_Teacher.fetchDataURL = institute_Institute_Url + instituteId + "/teachers"
                            ListGrid_Institute_Attached_Teacher.invalidateCache();
                            ListGrid_Institute_Attached_Teacher.fetchData();
                            Window_Institute_TeacherList.close();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });
            }

        }
    }

    function Function_Institute_Teacher_Remove() {
        var selectedAttachedTeacherRecords = ListGrid_Institute_Attached_Teacher.getSelectedRecords();
        if (selectedAttachedTeacherRecords != null) {
            if (selectedAttachedTeacherRecords.getLength() > 1) {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;
                var teacherRecords = ListGrid_Institute_Attached_Teacher.getSelectedRecords();
                var teacherIds = new Array();
                for (i = 0; i < teacherRecords.getLength(); i++) {
                    teacherIds.add(teacherRecords[i].id);
                }
// var JSONObj = {"ids": skillGroupIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: institute_Institute_Url + "remove-teacher-list/" + teacherIds + "/" + instituteId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Institute_Attached_Teacher.invalidateCache();
                            ListGrid_Institute_Attached_Teacher.fetchData();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });
            } else {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;
                var teacherRecord = ListGrid_Institute_Attached_Teacher.getSelectedRecord();
                var teacherId = teacherRecord.id;
// var JSONObj = {"ids": courseIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: institute_Institute_Url + "remove-teacher/" + teacherId + "/" + instituteId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Institute_Attached_Teacher.invalidateCache();
                            ListGrid_Institute_Attached_Teacher.fetchData();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });
            }

        }

    }

    //--------------------------------------------------------------------------------------------------------------------//
    /*Edit Accounts For Institute*/
    //--------------------------------------------------------------------------------------------------------------------//


    var DynamicForm_Institute_Institute_Account = isc.DynamicForm.create({
        width: "100%",
        titleWidth: 120,
        colWidths: [120, 300, 120, 300],
        height: "100%",
        align: "center",
        wrapItemTitles: false,
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        fields: [
            {name: "id", hidden: true},
            {name: "instituteId", hidden: true},
            {name: "isEnable", hidden: true},
            {
                name: "bankId",
                type: "IntegerItem",
                title: "بانک",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Institute_Bank,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["titleFa"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", title: "عنوان بانک", width: "30%", filterOperator: "iContains"},
                    {name: "ebankType.titleFa", title: "نوع بانک", width: "30%", filterOperator: "iContains"}
                ]
            },
            {
                name: "bankBranchId",
                type: "IntegerItem",
                title: "شعبه بانک",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Institute_BankBranch,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["titleFa"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "code", title: "کد شعبه", width: "30%", filterOperator: "iContains"},
                    {name: "titleFa", title: "عنوان شعبه", width: "30%", filterOperator: "iContains"}
                ]
            },
            {
                name: "accountNumber",
                title: "شماره حساب",
                required: true,
                keyPressFilter: "[0-9|/|.]| ",
                width: "*",
            },
            {
                name: "cartNumber",
                keyPressFilter: "[0-9|-| ]",
                title: "شماره کارت",
                width: "*",
            },
            {
                name: "shabaNumber",
                title: "شماره شبا",
                keyPressFilter: "[A-Z|a-z|0-9|-| ]",
                width: "*",
            },
            {
                name: "accountOwnerName",
                title: "نام صاحب حساب",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                width: "*",
            },
            {
                name: "description",
                title: "توضیحات",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "500",
                colSpan: 2,
                width: "*",
            },
            {
                name: "isEnableVal",
                title: "فعال؟",
                align: "center",
                showTitle: false,
                type: "checkbox",
                keyPressFilter: "[A-Z|a-z|0-9|-| ]",
                width: "*",
            },
        ],
        itemChanged: function (item, newValue) {
//            alert(DynamicForm_Institute_Institute_Account.getField("isEnableVal").getValue().toString());
            if (item.name == "bankId") {
                if (newValue == undefined) {
                    DynamicForm_Institute_Institute_Account.clearValue("bankBranchId");
// RestDataSource_Institute_BankBranch.fetchDataURL =null;
                } else {
                    RestDataSource_Institute_BankBranch.fetchDataURL = institute_Bank_Url + "bank-branches/" + newValue;
                    DynamicForm_Institute_Institute_Account.getField("bankBranchId").optionDataSource = RestDataSource_Institute_BankBranch;
                    DynamicForm_Institute_Institute_Account.getField("bankBranchId").fetchData();
                    DynamicForm_Institute_Institute_Account.clearValue("bankBranchId");
                }
            } else if (item.name == "isEnableVal") {
                var v = DynamicForm_Institute_Institute_Account.getField("isEnableVal").getValue().toString();
                DynamicForm_Institute_Institute_Account.getField("isEnable").setValue(v == "true" ? 1 : 0);

            }
        }

    });

    var IButton_Institute_Institute_Account_Exit = isc.IButton.create({
        top: 260,
        title: "لغو",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_Account.close();
        }
    });
    var IButton_Institute_Institute_Account_Save = isc.IButton.create({
        top: 260,
        title: "ذخیره",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {
            Function_Institute_Account_Save();
        }
    });


    var VLayout_Institute_Institute_Account_Form = isc.VLayout.create({
        width: "100%",
        height: "90%",
        members: [DynamicForm_Institute_Institute_Account]
    });

    var HLayOut_Institute_Institute_Account_Action = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: 30,
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Institute_Institute_Account_Save, IButton_Institute_Institute_Account_Exit]
    });

    var Window_Institute_Account = isc.Window.create({
        title: "حساب موسسه",
        width: 750,
        height: 200,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [VLayout_Institute_Institute_Account_Form, HLayOut_Institute_Institute_Account_Action]
        })]
    });


    var ToolStripButton_Institute_Account_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "افزودن",
        click: function () {
            Function_Institute_Account_Add();
        }
    });
    var ToolStripButton_Institute_Account_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            Function_Institute_Account_Remove();
        }
    });
    var ToolStripButton_Institute_Account_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {
            Function_Institute_Account_Edit();
        }
    });
    var ToolStrip_Institute_Account = isc.ToolStrip.create({
        width: "20",
        center: true,
        members: [
            ToolStripButton_Institute_Account_Add, ToolStripButton_Institute_Account_Edit, ToolStripButton_Institute_Account_Remove
        ]
    });


    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Institute_Institute_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code='refresh'/>",
        click: function () {
            ListGrid_Institute_Institute_refresh();
        }
    });
    var ToolStripButton_Institute_Institute_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_Institute_Institute_Edit();
        }
    });
    var ToolStripButton_Institute_Institute_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code='create'/>",
        click: function () {
            ListGrid_Institute_Institute_Add();
        }
    });
    var ToolStripButton_Institute_Institute_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_Institute_Institute_Remove();
        }
    });

    <%--var ToolStripButton_Institute_Institute_Print = isc.ToolStripButton.create({--%>
    <%--icon: "[SKIN]/RichTextEditor/print.png",--%>
    <%--title: "<spring:message code='print'/>",--%>
    <%--click: function () {--%>
    <%--ListGrid_institute_print("pdf");--%>
    <%--}--%>
    <%--});--%>

    var ToolStrip_Institute_Institute_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Institute_Institute_Refresh,
            ToolStripButton_Institute_Institute_Add,
            ToolStripButton_Institute_Institute_Edit,
            ToolStripButton_Institute_Institute_Remove]//,
// ToolStripButton_Institute_Institute_Print]
    });

    var HLayout_Institute_Institute_Action = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Institute_Institute_Actions]
    });
    var HLayout_Institute_Institute_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Institute_Institute]
    });

    // var HLayout_Institute__Institute_TrainingPlace = isc.HLayout.create({
    // width: "100%",
    // height: "100%",
    // members: [ListGrid_Institute_TrainingPlace]
    // });

    var VLayout_Institute_Institute_Teacher = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [ToolStrip_Institute_Teacher, ListGrid_Institute_Attached_Teacher]
    });
    var VLayout_Institute_Institute_Equipment = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [ToolStrip_Institute_Equipment, ListGrid_Institute_Attached_Equipment]
    });

    var VLayout_Institute_Institute_Account = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [ToolStrip_Institute_Account, ListGrid_Institute_Institute_Account]
    });

    var Tab_Institute_Detail = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
// {
// id: "TabPane_Institute_TrainingPlace",
// title: "لیست محل های آموزشی",
// pane: HLayout_Institute__Institute_TrainingPlace
//
// },

            {
                id: "TabPane_Institute_Teacher",
                title: "لیست اساتید",
                pane: VLayout_Institute_Institute_Teacher
            },
            {
                id: "TabPane_Institute_Equipment",
                title: "لیست تجهیزات کمک آموزشی",
                pane: VLayout_Institute_Institute_Equipment
            },
            {
                id: "TabPane_Institute_Account",
                title: "لیست حساب های موسسه",
                pane: VLayout_Institute_Institute_Account
            }
        ]
    });

    var VLayout_Institute_Institute_Head_Body = isc.VLayout.create({
        width: "100%",
        height: "50%",
        members: [
            HLayout_Institute_Institute_Action
            , HLayout_Institute_Institute_Grid
        ]
    });
    var VLayout_Institute_Institute_Detail_Body = isc.VLayout.create({
        width: "100%",
        height: "50%",
        members: [
            Tab_Institute_Detail
        ]
    });

    var VLayout_Body_Institute = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Institute_Institute_Head_Body,
            VLayout_Institute_Institute_Detail_Body
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Functions*/

    //--------------------------------------------------------------------------------------------------------------------//
    function ListGrid_Institute_Institute_Remove() {
        var record = ListGrid_Institute_Institute.getSelectedRecord();
//console.log(record);
        if (record == null) {
            isc.Dialog.create({
                message: "مرکز آموزشی برای حذف انتخاب نشده است!",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين مرکز آموزشی حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
                    title: "خير"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        var wait = isc.Dialog.create({
                            message: "<spring:message code='global.form.do.operation'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='global.message'/>"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: institute_Institute_Url + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.data == "true") {
                                    ListGrid_Institute_Institute.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "مرکز آموزشی با موفقيت حذف گرديد",
                                        icon: "[SKIN]say.png",
                                        title: "انجام شد"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "ركورد مورد نظر قابل حذف نيست",
                                        icon: "[SKIN]stop.png",
                                        title: "خطا"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 3000);
                                }
                            }
                        });
                    }
                }
            });
        }


    };

    function ListGrid_Institute_Institute_Edit() {
        var record = ListGrid_Institute_Institute.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "مرکز آموزشی برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
//console.log('record:' + JSON.stringify(record));

            DynamicForm_Institute_Institute.clearValues();
            DynamicForm_Institute_Institute_Address.getItem("cityId").setOptionDataSource(null);

            ValuesManager_Institute_InstituteValue.editRecord(record);

            var stateValue = undefined;
            var cityValue = undefined;

// DynamicForm_Institute_Institute_Address.getField("stateId").invalidateCache();
// DynamicForm_Institute_Institute_Address.getField("stateId").fetchData();


            if (record != null && record.stateId != null)
                stateValue = record.stateId;
            if (record != null && record.cityId != null)
                cityValue = record.cityId;
            if (cityValue == undefined) {
                DynamicForm_Institute_Institute_Address.clearValue("cityId");
            }
            if (stateValue != undefined) {
// RestDataSource_Institute_State.fetchDataURL=stateUrl + "spec-list";
                RestDataSource_Institute_City.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue;
// DynamicForm_Institute_Institute_Address.getField("stateId").optionDataSource = RestDataSource_Institute_State;
                DynamicForm_Institute_Institute_Address.getField("cityId").optionDataSource = RestDataSource_Institute_City;
                DynamicForm_Institute_Institute_Address.getField("cityId").fetchData();
            }


            instituteMethod = "PUT";
            Window_Institute_Institute.setTitle(" ویرایش مرکز آموزشی " + getFormulaMessage(ListGrid_Institute_Institute.getSelectedRecord().code, 3, "red", "I"));
            Window_Institute_Institute.show();

        }
    };

    function ListGrid_Institute_Institute_Add() {
        ValuesManager_Institute_InstituteValue.clearValues();
        ValuesManager_Institute_InstituteValue.clearErrors(true);
        instituteMethod = "POST";
// DynamicForm_Institute_Institute.clearValues();
        DynamicForm_Institute_Institute_Address.getItem("cityId").setOptionDataSource(null);
        ;
        Window_Institute_Institute.setTitle("ایجاد مرکز آموزشی جدید");
        Window_Institute_Institute.show();
        Window_Institute_Institute.bringToFront();
    };

    function ListGrid_Institute_Institute_refresh() {
        var record = ListGrid_Institute_Institute.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_Institute_Institute.selectRecord(record);
        }
        ListGrid_Institute_Institute.invalidateCache();
    };

    function Function_Institute_Account_Remove() {
        var record = ListGrid_Institute_Institute_Account.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "حساب برای حذف انتخاب نشده است!",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين حساب حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
                    title: "خير"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        var wait = isc.Dialog.create({
                            message: "<spring:message code='global.form.do.operation'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='global.message'/>"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: institute_Institute_Account_Url + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.data == "true") {
                                    ListGrid_Institute_Institute_Account.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "حساب با موفقيت حذف گرديد",
                                        icon: "[SKIN]say.png",
                                        title: "انجام شد"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message: "ركورد مورد نظر قابل حذف نيست",
                                        icon: "[SKIN]stop.png",
                                        title: "خطا"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 3000);
                                }
                            }
                        });
                    }
                }
            });
        }
    };

    function Function_Institute_Account_Edit() {
        var record = ListGrid_Institute_Institute_Account.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "حساب برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            //console.log('record:' + JSON.stringify(record));
            DynamicForm_Institute_Institute_Account.getField("bankId").fetchData();
            RestDataSource_Institute_BankBranch.fetchDataURL = institute_Bank_Url + "bank-branches/" + record.bankId;
            DynamicForm_Institute_Institute_Account.getField("bankBranchId").optionDataSource = RestDataSource_Institute_BankBranch;
            DynamicForm_Institute_Institute_Account.getField("bankBranchId").fetchData();
            DynamicForm_Institute_Institute_Account.clearValue("bankBranchId");

            DynamicForm_Institute_Institute_Account.clearValues();
            DynamicForm_Institute_Institute_Account.editRecord(record);
            DynamicForm_Institute_Institute_Account.getField("isEnableVal").setValue(record.isEnable == 1 ? true : false);
            reqMethod = "PUT";
            Window_Institute_Account.setTitle(" ویرایش حساب شماره " + getFormulaMessage(ListGrid_Institute_Institute_Account.getSelectedRecord().accountNumber, 3, "red", "I"));
            Window_Institute_Account.show();
            Window_Institute_Account.bringToFront();
        }
    };

    function Function_Institute_Account_Add() {
        var record = ListGrid_Institute_Institute.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "مرکز آموزشی برای ورود حسابهایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            DynamicForm_Institute_Institute_Account.clearValues();
            DynamicForm_Institute_Institute_Account.clearErrors(true);
            reqMethod = "POST";
// DynamicForm_Institute_Institute.clearValues();
            DynamicForm_Institute_Institute_Account.getField("isEnable").setValue(1);
            DynamicForm_Institute_Institute_Account.getField("isEnableVal").setValue(true);

            DynamicForm_Institute_Institute_Account.getItem("instituteId").setValue(record.id);
            DynamicForm_Institute_Institute_Account.getItem("bankBranchId").setOptionDataSource(null);
            Window_Institute_Account.setTitle("ایجاد حساب جدید");
            Window_Institute_Account.show();
            Window_Institute_Account.bringToFront();
        }
    };

    function Function_Institute_Account_Save() {

        DynamicForm_Institute_Institute_Account.validate();
        if (DynamicForm_Institute_Institute_Account.hasErrors()) {
            return;
        }

        var data = DynamicForm_Institute_Institute_Account.getValues();
        var instituteAccountSaveUrl = institute_Institute_Account_Url;
        if (reqMethod.localeCompare("PUT") == 0) {
            var instituteAccountRecord = ListGrid_Institute_Institute_Account.getSelectedRecord();
            instituteAccountSaveUrl += instituteAccountRecord.id;
        }
        isc.RPCManager.sendRequest(MyDsRequest(instituteAccountSaveUrl, reqMethod, JSON.stringify(data), "callback: Function_Institute_Account_Save_Result(rpcResponse)"));
    }

    function Function_Institute_Account_Save_Result(resp) {
        var respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            ListGrid_Institute_Institute_Account.invalidateCache();
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",

            });

            setTimeout(function () {
                MyOkDialog_job.close();

            }, 3000);

            Window_Institute_Account.close();

        } else {
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });

            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);
        }
    }

    // function checkMobile(mobile) {
    // if (mobile[0] == "0" && mobile[1] == "9")
    // return true;
    // else
    // return false;
    // };

