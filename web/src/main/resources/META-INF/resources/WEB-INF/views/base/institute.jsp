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
    var institute_Institute_Url = rootUrl + "/institute/";
    var institute_Institute_Account_Url = rootUrl + "/institute-account/";
    var institute_Institute_TrainingPlace_Url = rootUrl + "/training-place/";
    var institute_Bank_Url = rootUrl + "/bank/";
    var equipmentDestUrl = "";
    var globalWait = undefined;
    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//


    var RestDataSource_Institute_Institute = isc.TrDS.create({
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

    var RestDataSource_Institute_Institute_Account = isc.TrDS.create({
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

    var RestDataSource_Institute_TrainingPlace = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "institute.titleFa"},
            {name: "instituteId"},
            {name: "capacity"},
            {name: "eplaceType.titleFa"},
            {name: "earrangementType.titleFa"},
            {name: "description"}
        ],
        fetchDataURL: institute_Institute_Url + "training-place/0"
    });
    var RestDataSource_Institute_TrainingPlace_Equipment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: institute_Institute_Url + "training-place-equipment/0"
    });

    var RestDataSource_Institute_Institite_Equipment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: institute_Institute_Url + "equipment-dummy"
    });
    var RestDataSource_Institute_Institite_UnAttachedEquipment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: institute_Institute_Url + "0/unattached-equipments"
    });

    var RestDataSource_Institute_Institite_Teacher = isc.TrDS.create({
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
    var RestDataSource_Institute_Institite_UnAttachedTeacher = isc.TrDS.create({
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

    var RestDataSource_Institute_City = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: cityUrl + "spec-list"
    });
    var RestDataSource_Institute_State = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: stateUrl + "spec-list"
    });

    var RestDataSource_Institute_Bank = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "ebankTypeId"},
            {name: "ebankType.titleFa"}
        ],
        fetchDataURL: institute_Bank_Url + "spec-list"
    });
    var RestDataSource_Institute_BankBranch = isc.TrDS.create({
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

    var RestDataSource_Institute_EPlaceType = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "ePlaceType/spec-list"
    });
    var RestDataSource_Institute_EArrangementType = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eArrangementType/spec-list"
    });
    var RestDataSource_Institute_EInstituteType = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eInstituteType/spec-list"
    });
    var RestDataSource_Institute_ELicenseType = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eLicenseType/spec-list"
    });

    var RestDataSource_Institute_PersonalInfo_List = isc.TrDS.create({
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
    var RestDataSource_Institute_Institute_List = isc.TrDS.create({
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
        }, {isSeparator: true},
            {
                title: "<spring:message code='print.pdf'/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                    ListGrid_institute_print("pdf");
                }
            },
            {
                title: "<spring:message code='print.excel'/>",
                icon: "<spring:url value="excel.png"/>",
                click: function () {
                    ListGrid_institute_print("excel");
                }
            },
            {
                title: "<spring:message code='print.html'/>",
                icon: "<spring:url value="html.png"/>",
                click: function () {
                    ListGrid_institute_print("html");
                }
            }]

    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Listgrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Institute_Institute = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institute,
        contextMenu: Menu_ListGrid_Institute_Institute,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code='global.titleFa'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "titleEn",
                title: "<spring:message code='global.titleEn'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "manager.firstNameFa",
                title: "<spring:message code='manager.name'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "manager.lastNameFa",
                title: "<spring:message code='manager.family'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "parentInstitute.titleFa",
                title: "<spring:message code='institute.parent'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "einstituteType.titleFa",
                title: "<spring:message code='institute.type'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "elicenseType.titleFa",
                title: "<spring:message code='diploma.type'/>",
                align: "center",
                filterOperator: "iContains"
            },
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
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        doubleClick: function () {
            ListGrid_Institute_Institute_Edit();
        },
        selectionChanged: function (record, state) {
            if (record == null) {
                RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + "equipment-dummy";
                RestDataSource_Institute_Institite_Teacher.fetchDataURL = institute_Institute_Url + "teacher-dummy";
                RestDataSource_Institute_Institute_Account.fetchDataURL = "";
                RestDataSource_Institute_TrainingPlace.fetchDataURL = "";
                ListGrid_Institute_TrainingPlace.invalidateCache();
                ListGrid_Institute_Institute_Account.invalidateCache()
                ListGrid_Institute_TrainingPlace.setData([]);
                ListGrid_Institute_Institute_Account.setData([]);
            } else {
                RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + record.id + "/equipments";
                RestDataSource_Institute_Institite_Teacher.fetchDataURL = institute_Institute_Url + record.id + "/teachers";
                RestDataSource_Institute_Institute_Account.fetchDataURL = institute_Institute_Url + record.id + "/accounts";
                RestDataSource_Institute_TrainingPlace.fetchDataURL = institute_Institute_Url + record.id + "/training-places";
                ListGrid_Institute_Institute_Account.invalidateCache();
                ListGrid_Institute_Institute_Account.fetchData();
                ListGrid_Institute_TrainingPlace.invalidateCache();
                ListGrid_Institute_TrainingPlace.fetchData();
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
                RestDataSource_Institute_TrainingPlace.fetchDataURL = "";
                ListGrid_Institute_TrainingPlace.invalidateCache();
                ListGrid_Institute_Institute_Account.invalidateCache()
                ListGrid_Institute_TrainingPlace.setData([]);
                ListGrid_Institute_Institute_Account.setData([]);
            } else {
                RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + record.id + "/equipments";
                RestDataSource_Institute_Institite_Teacher.fetchDataURL = institute_Institute_Url + record.id + "/teachers";
                RestDataSource_Institute_Institute_Account.fetchDataURL = institute_Institute_Url + record.id + "/accounts";
                RestDataSource_Institute_TrainingPlace.fetchDataURL = institute_Institute_Url + record.id + "/training-places";
                ListGrid_Institute_Institute_Account.invalidateCache();
                ListGrid_Institute_Institute_Account.fetchData();
                ListGrid_Institute_TrainingPlace.invalidateCache();
                ListGrid_Institute_TrainingPlace.fetchData();
            }
            ListGrid_Institute_Attached_Equipment.invalidateCache();
            ListGrid_Institute_Attached_Teacher.invalidateCache();
            ListGrid_Institute_Attached_Equipment.fetchData();
            ListGrid_Institute_Attached_Teacher.fetchData();


        }

    });

    var ListGrid_Institute_Attached_Teacher = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_Teacher,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "teacherCode", title: "کد", align: "center"},
            {name: "personality.firstNameFa", title: "<spring:message code='firstName'/>", align: "center"},
            {name: "personality.lastNameFa", title: "<spring:message code='lastName'/>", align: "center"},
            {name: "personality.nationalCode", title: "<spring:message code='national.code'/>", align: "center"}
        ],
        selectionType: "multiple",
        autoDraw: false,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: false,
    });
    var ListGrid_Institute_Attached_Equipment = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_Equipment,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center"},
            {name: "titleFa", title: "<spring:message code='global.titleFa'/>", align: "center"},
            {name: "titleEn", title: "<spring:message code='global.titleEn'/>", align: "center"},
            {name: "description", title: "<spring:message code='description'/>", align: "center"}
        ],
        selectionType: "multiple",
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        autoDraw: false,
        showFilterEditor: false,
        doubleClick: function () {
        }
    });
    var ListGrid_Institute_Institute_Account = isc.TrLG.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        dataSource: RestDataSource_Institute_Institute_Account,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "bank.titleFa", title: "<spring:message code='bank.title'/>", align: "center"},
            {name: "bankBranch.titleFa", title: "<spring:message code='bank.branch.title'/>", align: "center"},
            {name: "accountNumber", title: "<spring:message code='account.number'/>", align: "center"},
            {name: "cartNumber", title: "<spring:message code='cart.number'/>", align: "center"},
            {name: "shabaNumber", title: "<spring:message code='shaba.number'/>", align: "center"},
            {name: "accountOwnerName", title: "<spring:message code='account.owner.name'/>", align: "center"},
            {name: "isEnable", title: "<spring:message code='isEnable'/>", align: "center"},
            {name: "description", title: "<spring:message code='description'/>", align: "center"}
        ],
        selectionType: "multiple",
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: false,
        doubleClick: function () {
            Function_Institute_Account_Edit();
        }
    });

    var ListGrid_Institute_TrainingPlace = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_TrainingPlace,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "<spring:message code='global.titleFa'/>", align: "center"},
            {name: "titleEn", title: "<spring:message code='global.titleEn'/>", align: "center"},
            {name: "capacity", title: "<spring:message code='capacity'/>", align: "center"},
            {name: "eplaceType.titleFa", title: "<spring:message code='place.type'/>", align: "center"},
            {name: "earrangementType.titleFa", title: "<spring:message code='place.shape'/>", align: "center"}
        ],
        selectionType: "multiple",
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: false,
        doubleClick: function () {
            Function_Institute_TrainingPlace_Edit();
        },
        selectionChanged: function (record, state) {
            if (record == null) {
                RestDataSource_Institute_TrainingPlace_Equipment.fetchDataURL = "";
                RestDataSource_Institute_TrainingPlace_Equipment.invalidateCache();
                ListGrid_Institute_TrainingPlece_Equipment.setData([]);
            } else {
                RestDataSource_Institute_TrainingPlace_Equipment.fetchDataURL = institute_Institute_TrainingPlace_Url + record.id + "/equipments";
                ListGrid_Institute_TrainingPlece_Equipment.invalidateCache();
                ListGrid_Institute_TrainingPlece_Equipment.fetchData();
            }
        },
        dataArrived: function (startRow, endRow) {
            record = ListGrid_Institute_TrainingPlace.getSelectedRecord();
            if (record == null) {
                RestDataSource_Institute_TrainingPlace_Equipment.fetchDataURL = "";
                RestDataSource_Institute_TrainingPlace_Equipment.invalidateCache();
                ListGrid_Institute_TrainingPlece_Equipment.setData([]);
            } else {
                RestDataSource_Institute_TrainingPlace_Equipment.fetchDataURL = institute_Institute_TrainingPlace_Url + record.id + "/equipments";
                ListGrid_Institute_TrainingPlece_Equipment.invalidateCache();
                ListGrid_Institute_TrainingPlece_Equipment.fetchData();
            }
        }
    });
    var ListGrid_Institute_TrainingPlece_Equipment = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_TrainingPlace_Equipment,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center"},
            {name: "titleFa", title: "<spring:message code='global.titleFa'/>", align: "center"},
            {name: "titleEn", title: "<spring:message code='global.titleEn'/>", align: "center"},
            {name: "description", title: "<spring:message code='description'/>", align: "center"}
        ],
        selectionType: "multiple",
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        autoDraw: false,
        showFilterEditor: false,
        doubleClick: function () {
        }
    });

    var ListGrid_Institute_Institute_List = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institute_List,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code='global.titleFa'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "titleEn",
                title: "<spring:message code='global.titleEn'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "manager.firstNameFa",
                title: "<spring:message code='manager.name'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "manager.lastNameFa",
                title: "<spring:message code='manager.family'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "parentInstitute.titleFa",
                title: "<spring:message code='institute.parent'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "einstituteType.titleFa",
                title: "<spring:message code='institute.type'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "elicenseType.titleFa",
                title: "<spring:message code='diploma.type'/>",
                align: "center",
                filterOperator: "contains"
            }
        ],
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        doubleClick: function () {
            Function_Institute_InstituteList_Selected();
        }
    });
    var ListGrid_Institute_PersonalInfo_List = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_PersonalInfo_List,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "firstNameFa",
                title: "<spring:message code='firstName'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "lastNameFa",
                title: "<spring:message code='lastName'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "fatherName",
                title: "<spring:message code='father.name'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "nationalCode",
                title: "<spring:message code='national.code'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "birthDate",
                title: "<spring:message code='birth.date'/>",
                align: "center",
                filterOperator: "contains"
            }

        ],
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        doubleClick: function () {
            Function_Institute_PersonalList_Selected();
        }
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//
    var ValuesManager_Institute_InstituteValue = isc.ValuesManager.create({});

    var DynamicForm_Institute_Institute = isc.DynamicForm.create({
        width: "100%",
// height: "100%",
        align: "center",
        isGroup: true,

        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
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
                title: "<spring:message code='global.titleFa'/>",
                colSpan: 2,
                required: true,
                width: "*",
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "255"
            },
            {
                name: "titleEn",
                title: "<spring:message code='global.titleEn'/>",
                colSpan: 2,
                width: "*",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9| ]",
                length: "255"
            },
            {
                name: "parentInstituteId",
                title: "<spring:message code='institute.parent'/>",
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
                title: "<spring:message code='institute.type'/>",
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
                title: "<spring:message code='diploma.type'/>",
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
        valuesManager: "ValuesManager_Institute_InstituteValue",
        isGroup: true,
        groupTitle: "<spring:message code='teacher.count'/>",
        numCols: 4,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 2,
        newPadding: 5,
        fields: [
            {
                name: "teacherNumPHD",
                title: "<spring:message code='phd'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "teacherNumLicentiate",
                title: "<spring:message code='licentiate'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "teacherNumMaster",
                title: "<spring:message code='master'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "teacherNumAssociate",
                title: "<spring:message code='associate'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "teacherNumDiploma",
                title: "<spring:message code='diploma'/>",
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
        valuesManager: "ValuesManager_Institute_InstituteValue",
        numCols: 4,
        isGroup: true,
        groupTitle: "تعداد کارمندان",
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 2,
        newPadding: 5,
        fields: [
            {
                name: "empNumPHD",
                title: "<spring:message code='phd'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "empNumLicentiate",
                title: "<spring:message code='licentiate'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "empNumMaster",
                title: "<spring:message code='master'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "empNumAssociate",
                title: "<spring:message code='associate'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "5",
                width: "*"
            },
            {
                name: "empNumDiploma",
                title: "<spring:message code='diploma'/>",
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
        isGroup: true,
        groupTitle: "ارتباط با موسسه",
        valuesManager: "ValuesManager_Institute_InstituteValue",
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        fields: [
            {
                name: "stateId",
                type: "IntegerItem",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                required: true,
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
                title: "<spring:message code='city'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
// defaultToFirstOption: true,
                required: true,
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
                title: "<spring:message code='post.code'/>",
                keyPressFilter: "[0-9|-| ]",
                width: "*",
                length: "11",
            },
            {
                name: "phone",
                keyPressFilter: "[0-9|-]",
                title: "<spring:message code='telephone'/>",
                width: "*",
                required: true,
                validators: [TrValidators.PhoneValidate],
                blur: function () {
                    var phoneCheck;
                    phoneCheck = checkPhone(DynamicForm_Institute_Institute_Address.getValue("phone"));
                    if (phoneCheck === false)
                        DynamicForm_Institute_Institute_Address.addFieldErrors("phone", "<spring:message code='msg.check.phone'/>", true);
                    if (mobileCheck === true)
                        DynamicForm_Institute_Institute_Address.clearFieldErrors("phone", true);
                },
                length: "12"
            },
            {
                name: "mobile",
                keyPressFilter: "[0-9|-|+]",
                title: "<spring:message code='mobile'/>",
                width: "*",
                validators: [TrValidators.MobileValidate],
                blur: function () {
                    var mobileCheck;
                    mobileCheck = checkMobile(DynamicForm_Institute_Institute_Address.getValue("mobile"));
                    if (mobileCheck === false)
                        DynamicForm_Institute_Institute_Address.addFieldErrors("mobile", "<spring:message code='msg.check.phone'/>", true);
                    if (mobileCheck === true)
                        DynamicForm_Institute_Institute_Address.clearFieldErrors("mobile", true);
                },
                length: "13"
            },
            {
                name: "fax",
                title: "<spring:message code='telefax'/>",
                keyPressFilter: "[0-9|-]",
                width: "*",
                validators: [TrValidators.PhoneValidate],
                blur: function () {
                    var phoneCheck;
                    phoneCheck = checkPhone(DynamicForm_Institute_Institute_Address.getValue("fax"));
                    if (phoneCheck === false)
                        DynamicForm_Institute_Institute_Address.addFieldErrors("fax", "<spring:message code='msg.check.phone'/>", true);
                    if (phoneCheck === true)
                        DynamicForm_Institute_Institute_Address.clearFieldErrors("fax", true);
                },
                length: "12"
            },
            {
                name: "email",
                title: "<spring:message code='email'/>",
                keyPressFilter: "[a-z|A-Z|0-9|.|@|-|_]",
                width: "*",
                validators: [TrValidators.EmailValidate],
                blur: function () {
                    var emailCheck;
                    emailCheck = checkEmail(DynamicForm_Institute_Institute_Address.getValue("email"));
                    if (emailCheck === false)
                        DynamicForm_Institute_Institute_Address.addFieldErrors("email", "<spring:message code='msg.email.validation'/>", true);
                    if (emailCheck === true)
                        DynamicForm_Institute_Institute_Address.clearFieldErrors("email", true);
                },
                length: "50"
            },
            {
                name: "webSite",
                title: "<spring:message code='website'/>",
                width: "*",
                length: "100"
            },
            {
                name: "restAddress",
                title: "<spring:message code='address'/>",
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
            if (item.name == "email") {
            }

        }

    });


    var HLayout_Institute_InstituteTeacherAndEmp = isc.HLayout.create({
        width: "100%",
        height: 150,
// margin:5,
        padding: 5,

        members: [DynamicForm_Institute_InstituteEmpNum, isc.LayoutSpacer.create({width: "5"}), DynamicForm_Institute_InstituteTeacherNum]
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
        members: [DynamicForm_Institute_Institute_Address]
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
            isc.RPCManager.sendRequest(TrDSRequest(instituteSaveUrl, instituteMethod, JSON.stringify(data), "callback: institute_Save_action_result(rpcResponse)"));
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
        height: "490 ",
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
        height: 500,
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
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_InstituteList.close();
        }
    });

    var IButton_Institute_InstituteList_Choose = isc.IButton.create({
        top: 260,
        title: "<spring:message code='selectfromlist'/>",
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
        title: "<spring:message code='institute.selectparent'/>",
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
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_PersonalList.close();
        }
    });

    var IButton_Institute_PersonalList_Choose = isc.IButton.create({
        top: 260,
        title: "<spring:message code='selectfromlist'/>",
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
        title: "<spring:message code='institute.selectmanager'/>",
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
    /*Edit Equipments For Institute And Training Place*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Institute_Equipment_List = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_UnAttachedEquipment,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center"},
            {name: "titleFa", title: "<spring:message code='global.titleFa'/>", align: "center"},
            {name: "titleEn", title: "<spring:message code='global.titleEn'/>", align: "center"},
            {name: "description", title: "<spring:message code='description'/>", align: "center"}
        ],
        selectionType: "multiple",
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        doubleClick: function () {
            Function_Institute_EquipmentList_Selected(equipmentDestUrl);
        }
    });

    var IButton_Institute_EquipmentList_Exit = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_EquipmentList.close();
        }
    });

    var IButton_Institute_EquipmentList_Choose = isc.IButton.create({
        top: 260,
        title: "<spring:message code='selectfromlist'/>",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {
            Function_Institute_EquipmentList_Selected(equipmentDestUrl);
        }
    });


    var ToolStripButton_Institute_Equipment_Add = isc.TrCreateBtn.create({
        title: "<spring:message code="btn.append"/>",
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
                equipmentDestUrl = "institute-equipment";
                Function_Institute_EquipmentList_Select(institute_Institute_Url, record.id, equipmentDestUrl);
            }
        }
    });
    var ToolStripButton_Institute_Equipment_Delete = isc.TrRemoveBtn.create({
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
        title: "<spring:message code='institute.selectequipment'/>",
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

    function Function_Institute_EquipmentList_Select(baseUrl, masterId, dest) {
        RestDataSource_Institute_Institite_UnAttachedEquipment.fetchDataURL = baseUrl + masterId + "/unattached-equipments";
        equipmentDestUrl = dest;
        ListGrid_Institute_Equipment_List.invalidateCache();
        ListGrid_Institute_Equipment_List.fetchData();
        Window_Institute_EquipmentList.show();
        Window_Institute_EquipmentList.bringToFront();
    };

    function Function_Institute_EquipmentList_Selected(dest) {
        var addEquipmentUrl = "";
        var masterRecord = undefined;
        var masterId = null;
        if (dest == "training-place-equipment") {
            addEquipmentUrl = institute_Institute_TrainingPlace_Url;
            masterRecord = ListGrid_Institute_TrainingPlace.getSelectedRecord();
            masterId = masterRecord.id;
        } else if (dest == "institute-equipment") {
            addEquipmentUrl = institute_Institute_Url;
            masterRecord = ListGrid_Institute_Institute.getSelectedRecord();
            masterId = masterRecord.id;
        }
        console.log(masterId);
        if (ListGrid_Institute_Equipment_List.getSelectedRecord() != null) {
            var selectedEquipmentRecords = ListGrid_Institute_Equipment_List.getSelectedRecords();
            if (selectedEquipmentRecords.getLength() > 1) {
                var equipmentIds = new Array();
                for (i = 0; i < selectedEquipmentRecords.getLength(); i++) {
                    equipmentIds.add(selectedEquipmentRecords[i].id);
                }
                var JSONObj = {"ids": equipmentIds};
                isc.RPCManager.sendRequest(TrDSRequest(addEquipmentUrl + "add-equipment-list/" + masterId, "POST", JSON.stringify(JSONObj), "callback: Function_Institute_EquipmentList_Selected_CallBack(rpcResponse)"));
            } else {
                var equipmentRecord = ListGrid_Institute_Equipment_List.getSelectedRecord();
                var equipmentId = equipmentRecord.id;
                isc.RPCManager.sendRequest(TrDSRequest(addEquipmentUrl + "add-equipment/" + equipmentId + "/" + masterId, "POST", null, "callback: Function_Institute_EquipmentList_Selected_CallBack(rpcResponse)"));
            }
        }
    }

    function Function_Institute_EquipmentList_Selected_CallBack(resp) {
        if (resp.data == "true") {
            if (equipmentDestUrl == "training-place-equipment") {
                // RestDataSource_Institute_TrainingPlace_Equipment.fetchDataURL = institute_Institute_TrainingPlace_Url + masterId + "/equipments"
                ListGrid_Institute_TrainingPlece_Equipment.invalidateCache();
                ListGrid_Institute_TrainingPlece_Equipment.fetchData();
            } else if (equipmentDestUrl == "institute-equipment") {
                // RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + masterId + "/equipments"
                ListGrid_Institute_Attached_Equipment.invalidateCache();
                ListGrid_Institute_Attached_Equipment.fetchData();
            }
            Window_Institute_EquipmentList.close();
        } else {
            isc.say("اجرای این دستور با مشکل مواجه شده است");
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
                isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_Url + "remove-equipment-list/" + equipmentIds + "/" + instituteId, "DELETE", null, "callback: Function_Institute_Equipment_Remove_CallBack(rpcResponse)"));
            } else {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;
                var equipmentRecord = ListGrid_Institute_Attached_Equipment.getSelectedRecord();
                var equipmentId = equipmentRecord.id;
// var JSONObj = {"ids": courseIds};
                isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_Url + "remove-equipment/" + equipmentId + "/" + instituteId, "DELETE", null, "callback: Function_Institute_Equipment_Remove_CallBack(rpcResponse)"));
            }
        }
    }

    function Function_Institute_Equipment_Remove_CallBack(resp) {
        if (resp.data == "true") {
            if (equipmentDestUrl == "training-place-equipment") {
                // RestDataSource_Institute_TrainingPlace_Equipment.fetchDataURL = institute_Institute_TrainingPlace_Url + masterId + "/equipments"
                ListGrid_Institute_TrainingPlece_Equipment.invalidateCache();
                ListGrid_Institute_TrainingPlece_Equipment.fetchData();
            } else if (equipmentDestUrl == "institute-equipment") {
                // RestDataSource_Institute_Institite_Equipment.fetchDataURL = institute_Institute_Url + masterId + "/equipments"
                ListGrid_Institute_Attached_Equipment.invalidateCache();
                ListGrid_Institute_Attached_Equipment.fetchData();
            }
        } else {
            isc.say("اجرای این دستور با مشکل مواجه شده است");
        }

    }


    //--------------------------------------------------------------------------------------------------------------------//
    /*Edit Teachers For Institute*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Institute_Teacher_List = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_UnAttachedTeacher,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "teacherCode", title: "<spring:message code='code'/>", align: "center"},
            {name: "personality.firstNameFa", title: "<spring:message code='firstName'/>", align: "center"},
            {name: "personality.lastNameFa", title: "<spring:message code='lastName'/>", align: "center"},
            {name: "personality.nationalCode", title: "<spring:message code='national.code'/>", align: "center"}
        ],
        selectionType: "multiple",
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        doubleClick: function () {
            Function_Institute_TeacherList_Selected();
        }
    });

    var IButton_Institute_TeacherList_Exit = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_TeacherList.close();
        }
    });

    var IButton_Institute_TeacherList_Choose = isc.IButton.create({
        top: 260,
        title: "<spring:message code='selectfromlist'/>",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {
            Function_Institute_TeacherList_Selected();
        }
    });


    var ToolStripButton_Institute_Teacher_Add = isc.TrCreateBtn.create({
        title: "<spring:message code="btn.append"/>",
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
    var ToolStripButton_Institute_Teacher_Delete = isc.TrRemoveBtn.create({
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
        title: "<spring:message code='institute.selectteacher'/>",
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
                isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_Url + "add-teacher-list/" + instituteId, "POST", JSON.stringify(JSONObj), "callback: Function_Institute_TeacherList_Selected_CallBack(rpcResponse)"));
            } else {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;
                var teacherRecord = ListGrid_Institute_Teacher_List.getSelectedRecord();
                var teacherId = teacherRecord.id;
                isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_Url + "add-teacher/" + teacherId + "/" + instituteId, "POST", null, "callback: Function_Institute_TeacherList_Selected_CallBack(rpcResponse)"));
            }

        }
    }

    function Function_Institute_TeacherList_Selected_CallBack(resp) {
        if (resp.data == "true") {
            ListGrid_Institute_Attached_Teacher.invalidateCache();
            ListGrid_Institute_Attached_Teacher.fetchData();
            Window_Institute_TeacherList.close();
        } else {
            isc.say("اجرای این دستور با مشکل مواجه شده است");
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
                isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_Url + "remove-teacher-list/" + teacherIds + "/" + instituteId, "DELETE", null, "callback: Function_Institute_Teacher_Remove_CallBack(rpcResponse)"));
            } else {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                var instituteId = instituteRecord.id;
                var teacherRecord = ListGrid_Institute_Attached_Teacher.getSelectedRecord();
                var teacherId = teacherRecord.id;
// var JSONObj = {"ids": courseIds};
                isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_Url + "remove-teacher/" + teacherId + "/" + instituteId, "DELETE", null, "callback: Function_Institute_TeacherList_Selected_CallBack(rpcResponse)"));
            }

        }

    }

    function Function_Institute_Teacher_Remove_CallBack(resp) {
        if (resp.data == "true") {
            ListGrid_Institute_Attached_Teacher.invalidateCache();
            ListGrid_Institute_Attached_Teacher.fetchData();
        } else {
            isc.say("اجرای این دستور با مشکل مواجه شده است");
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
                title: "<spring:message code='bank'/>",
                textAlign: "center",
                width: "*",
                required: true,
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
                    {
                        name: "titleFa",
                        title: "<spring:message code='bank.title'/>",
                        width: "30%",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ebankType.titleFa",
                        title: "<spring:message code='bank.type'/>",
                        width: "30%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "bankBranchId",
                type: "IntegerItem",
                title: "<spring:message code='bank.branch'/>",
                textAlign: "center",
                required: true,
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
                    {
                        name: "code",
                        title: "<spring:message code='bank.branch.code'/>",
                        width: "30%",
                        filterOperator: "iContains"
                    },
                    {
                        name: "titleFa",
                        title: "<spring:message code='bank.branch.title'/>",
                        width: "30%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "accountNumber",
                title: "<spring:message code='account.number'/>",
                required: true,
                keyPressFilter: "[0-9|/|.]| ",
                width: "*",
            },
            {
                name: "cartNumber",
                keyPressFilter: "[0-9|-| ]",
                title: "<spring:message code='cart.number'/>",
                width: "*",
            },
            {
                name: "shabaNumber",
                title: "<spring:message code='shaba.number'/>",
                keyPressFilter: "[A-Z|a-z|0-9|-| ]",
                width: "*",
            },
            {
                name: "accountOwnerName",
                title: "<spring:message code='account.owner.name'/>",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                width: "*",
            },
            {
                name: "description",
                title: "<spring:message code='description'/>",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "500",
                colSpan: 2,
                width: "*",
            },
            {
                name: "isEnableVal",
                title: "<spring:message code='isEnable'/>",
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
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_Account.close();
        }
    });
    var IButton_Institute_Institute_Account_Save = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
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

    var ToolStripButton_Institute_Account_Add = isc.TrCreateBtn.create({
        click: function () {
            Function_Institute_Account_Add();
        }
    });
    var ToolStripButton_Institute_Account_Remove = isc.TrRemoveBtn.create({
        click: function () {
            Function_Institute_Account_Remove();
        }
    });
    var ToolStripButton_Institute_Account_Edit = isc.TrEditBtn.create({
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
                        globalWait = wait;
                        isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_Account_Url + record.id, "DELETE", null, "callback: Function_Institute_Account_Remove_Result(rpcResponse)"));
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
        isc.RPCManager.sendRequest(TrDSRequest(instituteAccountSaveUrl, reqMethod, JSON.stringify(data), "callback: Function_Institute_Account_Save_Result(rpcResponse)"));

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

    function Function_Institute_Account_Remove_Result(resp) {
        globalWait.close();
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

    //--------------------------------------------------------------------------------------------------------------------//
    /*Edit Training Places For Institute*/
    //--------------------------------------------------------------------------------------------------------------------//
    var DynamicForm_Institute_Institute_TrainingPlace = isc.DynamicForm.create({
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
            {
                name: "titleFa",
                title: "<spring:message code='global.titleFa'/>",
                required: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                width: "*",
            },
            {
                name: "titleEn",
                title: "<spring:message code='global.titleEn'/>",
                keyPressFilter: "[0-9|-| ]",
                keyPressFilter: "[0-9|A-Z|a-z| ]",
                width: "*",
            },
            {
                name: "eplaceTypeId",
                type: "IntegerItem",
                title: "<spring:message code='place.type'/>",
                width: "*",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Institute_EPlaceType,
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
                name: "earrangementTypeId",
                type: "IntegerItem",
                title: "<spring:message code='place.shape'/>",
                width: "*",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Institute_EArrangementType,
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
                name: "capacity",
                title: "<spring:message code='capacity'/>",
                keyPressFilter: "[0-9]",
                required: true,
                width: "*",
            },
            {
                name: "description",
                title: "<spring:message code='description'/>",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "500",
                colSpan: 3,
                width: "*",
            }
        ]
    });

    var IButton_Institute_Institute_TrainingPlace_Exit = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_TrainingPlace.close();
        }
    });
    var IButton_Institute_Institute_TrainingPlace_Save = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {
            Function_Institute_TrainingPlace_Save();
        }
    });

    var VLayout_Institute_Institute_TrainingPlace_Form = isc.VLayout.create({
        width: "100%",
        height: "90%",
        members: [DynamicForm_Institute_Institute_TrainingPlace]
    });
    var HLayOut_Institute_Institute_TrainingPlace_Action = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: 30,
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Institute_Institute_TrainingPlace_Save, IButton_Institute_Institute_TrainingPlace_Exit]
    });
    var Window_Institute_TrainingPlace = isc.Window.create({
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
            members: [VLayout_Institute_Institute_TrainingPlace_Form, HLayOut_Institute_Institute_TrainingPlace_Action]
        })]
    });

    var ToolStripButton_Institute_TrainingPlace_Add = isc.TrCreateBtn.create({
        click: function () {
            Function_Institute_TrainingPlace_Add();
        }
    });
    var ToolStripButton_Institute_TrainingPlace_Remove = isc.TrRemoveBtn.create({
        click: function () {
            Function_Institute_TrainingPlace_Remove();
        }
    });
    var ToolStripButton_Institute_TrainingPlace_Edit = isc.TrEditBtn.create({
        click: function () {
            Function_Institute_TrainingPlace_Edit();
        }
    });

    var ToolStrip_Institute_TrainingPlace = isc.ToolStrip.create({
        width: "20",
        center: true,
        members: [
            ToolStripButton_Institute_TrainingPlace_Add, ToolStripButton_Institute_TrainingPlace_Edit, ToolStripButton_Institute_TrainingPlace_Remove
        ]
    });

    function Function_Institute_TrainingPlace_Remove() {
        var record = ListGrid_Institute_TrainingPlace.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "محل آموزشی برای حذف انتخاب نشده است!",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين محل آموزشی حذف گردد؟",
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
                        globalWait = wait;
                        isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_TrainingPlace_Url + record.id, "DELETE", null, "callback: Function_Institute_TrainingPlace_Remove_Result(rpcResponse)"));
                    }
                }
            });
        }
    };

    function Function_Institute_TrainingPlace_Edit() {
        var record = ListGrid_Institute_TrainingPlace.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "محل آموزشی برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {

            DynamicForm_Institute_Institute_TrainingPlace.clearValues();
            DynamicForm_Institute_Institute_TrainingPlace.editRecord(record);
            reqMethod = "PUT";
            Window_Institute_TrainingPlace.setTitle(" ویرایش محل آموزشی  " + getFormulaMessage(ListGrid_Institute_TrainingPlace.getSelectedRecord().titleFa, 3, "red", "I"));
            Window_Institute_TrainingPlace.show();
            Window_Institute_TrainingPlace.bringToFront();
        }
    };

    function Function_Institute_TrainingPlace_Add() {
        var record = ListGrid_Institute_Institute.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "مرکز آموزشی برای ورود محل های آموزشی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            DynamicForm_Institute_Institute_TrainingPlace.clearValues();
            DynamicForm_Institute_Institute_TrainingPlace.clearErrors(true);
            reqMethod = "POST";
            DynamicForm_Institute_Institute_TrainingPlace.getItem("instituteId").setValue(record.id);
            Window_Institute_TrainingPlace.setTitle("ایجاد محل آموزشی جدید");
            Window_Institute_TrainingPlace.show();
            Window_Institute_TrainingPlace.bringToFront();
        }
    };

    function Function_Institute_TrainingPlace_Save() {

        DynamicForm_Institute_Institute_TrainingPlace.validate();
        if (DynamicForm_Institute_Institute_TrainingPlace.hasErrors()) {
            return;
        }

        var data = DynamicForm_Institute_Institute_TrainingPlace.getValues();
        var instituteTrainingPlaceSaveUrl = institute_Institute_TrainingPlace_Url;
        if (reqMethod.localeCompare("PUT") == 0) {
            var instituteTrainingPlaceRecord = ListGrid_Institute_TrainingPlace.getSelectedRecord();
            instituteTrainingPlaceSaveUrl += instituteTrainingPlaceRecord.id;
        }
        isc.RPCManager.sendRequest(TrDSRequest(instituteTrainingPlaceSaveUrl, reqMethod, JSON.stringify(data), "callback: Function_Institute_TrainingPlace_Save_Result(rpcResponse)"));
    }

    function Function_Institute_TrainingPlace_Save_Result(resp) {
        var respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            ListGrid_Institute_TrainingPlace.invalidateCache();
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",

            });

            setTimeout(function () {
                MyOkDialog_job.close();

            }, 3000);

            Window_Institute_TrainingPlace.close();

        } else {
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });

            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);
        }
    }

    function Function_Institute_TrainingPlace_Remove_Result(resp) {
        globalWait.close();
        if (resp.data == "true") {
            ListGrid_Institute_TrainingPlace.invalidateCache();
            var OK = isc.Dialog.create({
                message: "محل آموزشی با موفقيت حذف گرديد",
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

    //--------------------------------------------------------------------------------------------------------------------//
    /*Edit Equipments For Training Places And Institute*/
    //--------------------------------------------------------------------------------------------------------------------//


    var DynamicForm_Institute_TrainingPlace_Equipment = isc.DynamicForm.create({
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
                title: "<spring:message code='bank'/>",
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
                    {
                        name: "titleFa",
                        title: "<spring:message code='bank.title'/>",
                        width: "30%",
                        filterOperator: "iContains"
                    },
                    {
                        name: "ebankType.titleFa",
                        title: "<spring:message code='bank.type'/>",
                        width: "30%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "bankBranchId",
                type: "IntegerItem",
                title: "<spring:message code='bank.branch'/>",
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
                    {
                        name: "code",
                        title: "<spring:message code='bank.branch.code'/>",
                        width: "30%",
                        filterOperator: "iContains"
                    },
                    {
                        name: "titleFa",
                        title: "<spring:message code='bank.branch.title'/>",
                        width: "30%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "accountNumber",
                title: "<spring:message code='account.number'/>",
                required: true,
                keyPressFilter: "[0-9|/|.]| ",
                width: "*",
            },
            {
                name: "cartNumber",
                keyPressFilter: "[0-9|-| ]",
                title: "<spring:message code='cart.number'/>",
                width: "*",
            },
            {
                name: "shabaNumber",
                title: "<spring:message code='shaba.number'/>",
                keyPressFilter: "[A-Z|a-z|0-9|-| ]",
                width: "*",
            },
            {
                name: "accountOwnerName",
                title: "<spring:message code='account.owner.name'/>",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                width: "*",
            },
            {
                name: "description",
                title: "<spring:message code='description'/>",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "500",
                colSpan: 2,
                width: "*",
            },
            {
                name: "isEnableVal",
                title: "<spring:message code='isEnable'/>",
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

    var IButton_Institute_TrainingPlace_Equipment_Exit = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Institute_Account.close();
        }
    });
    var IButton_Institute_TrainingPlace_Equipment_Save = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {
            Function_Institute_Account_Save();
        }
    });


    var VLayout_Institute_TrainingPlace_Equipment_Form = isc.VLayout.create({
        width: "100%",
        height: "90%",
        members: [DynamicForm_Institute_TrainingPlace_Equipment]
    });

    var HLayOut_Institute_TrainingPlace_Equipment_Action = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: 30,
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Institute_TrainingPlace_Equipment_Save, IButton_Institute_TrainingPlace_Equipment_Exit]
    });

    var Window_Institute_TrainingPlace_Equipment = isc.Window.create({
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
            members: [VLayout_Institute_TrainingPlace_Equipment_Form, HLayOut_Institute_TrainingPlace_Equipment_Action]
        })]
    });


    var ToolStripButton_Institute_TrainingPlace_Equipment_Add = isc.TrCreateBtn.create({
        title: "<spring:message code="btn.append"/>",
        click: function () {
            var record = ListGrid_Institute_TrainingPlace.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "لطفا یک محل آموزشی را انتخاب کنید.",
                    icon: "[SKIN]ask.png",
                    title: "توجه",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                equipmentDestUrl = "training-place-equipment";
                Function_Institute_EquipmentList_Select(institute_Institute_TrainingPlace_Url, record.id, equipmentDestUrl);
            }
        }
    });
    var ToolStripButton_Institute_TrainingPlace_Equipment_Remove = isc.TrRemoveBtn.create({
        click: function () {
            Function_Institute_TrainingPlace_Equipment_Remove();
        }
    });

    var ToolStrip_Institute_TrainingPlace_Equipment = isc.ToolStrip.create({
        width: "20",
        center: true,
        members: [
            ToolStripButton_Institute_TrainingPlace_Equipment_Add, ToolStripButton_Institute_TrainingPlace_Equipment_Remove
        ]
    });


    function Function_Institute_TrainingPlace_Equipment_Remove() {
        var selectedAttachedEquipmentRecords = ListGrid_Institute_TrainingPlece_Equipment.getSelectedRecords();
        if (selectedAttachedEquipmentRecords != null) {
            if (selectedAttachedEquipmentRecords.getLength() > 1) {
                var trainingPlaceRecord = ListGrid_Institute_TrainingPlace.getSelectedRecord();
                var trainingPlaceId = trainingPlaceRecord.id;
                var equipmentRecords = ListGrid_Institute_TrainingPlece_Equipment.getSelectedRecords();
                var equipmentIds = new Array();
                for (i = 0; i < equipmentRecords.getLength(); i++) {
                    equipmentIds.add(equipmentRecords[i].id);
                }
                // var JSONObj = {"ids": skillGroupIds};
                isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_TrainingPlace_Url + "remove-equipment-list/" + equipmentIds + "/" + trainingPlaceId, "DELETE", null, "callback: Function_Institute_TrainingPlace_Equipment_Remove_CallBack(rpcResponse)"));

            } else {
                var trainingPlaceRecord = ListGrid_Institute_TrainingPlace.getSelectedRecord();
                var trainingPlaceId = trainingPlaceRecord.id;
                var equipmentRecord = ListGrid_Institute_TrainingPlece_Equipment.getSelectedRecord();
                var equipmentId = equipmentRecord.id;
                // var JSONObj = {"ids": courseIds};
                isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_TrainingPlace_Url + "remove-equipment/" + equipmentId + "/" + trainingPlaceId, "DELETE", null, "callback: Function_Institute_TrainingPlace_Equipment_Remove_CallBack(rpcResponse)"));
            }
        }
    }

    function Function_Institute_TrainingPlace_Equipment_Remove_CallBack(resp) {
        if (resp.data == "true") {
            ListGrid_Institute_TrainingPlece_Equipment.invalidateCache();
            ListGrid_Institute_TrainingPlece_Equipment.fetchData();
        } else {
            isc.say("اجرای این دستور با مشکل مواجه شده است");
        }
    }

    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Institute_Institute_Refresh = isc.TrRefreshBtn.create({
        click: function () {
            ListGrid_Institute_Institute_refresh();
        }
    });
    var ToolStripButton_Institute_Institute_Edit = isc.TrEditBtn.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_Institute_Institute_Edit();
        }
    });
    var ToolStripButton_Institute_Institute_Add = isc.TrCreateBtn.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code='create'/>",
        click: function () {
            ListGrid_Institute_Institute_Add();
        }
    });
    var ToolStripButton_Institute_Institute_Remove = isc.TrRemoveBtn.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_Institute_Institute_Remove();
        }
    });

    var ToolStripButton_Institute_Institute_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            ListGrid_institute_print("pdf");
        }
    });

    var ToolStrip_Institute_Institute_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Institute_Institute_Refresh,
            ToolStripButton_Institute_Institute_Add,
            ToolStripButton_Institute_Institute_Edit,
            ToolStripButton_Institute_Institute_Remove,
            ToolStripButton_Institute_Institute_Print]
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


    var VLayout_Institute_Institute_TrainingPlace = isc.VLayout.create({
        width: "59%",
        height: "100%",
        members: [ToolStrip_Institute_TrainingPlace, ListGrid_Institute_TrainingPlace]
    });

    var VLayout_Institute_Institute_TrainingPlace_Equipment = isc.VLayout.create({
        width: "40%",
        height: "100%",
        members: [ToolStrip_Institute_TrainingPlace_Equipment, ListGrid_Institute_TrainingPlece_Equipment]
    });


    var HLayout_Institute_Institute_TrainingPlace = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [VLayout_Institute_Institute_TrainingPlace, isc.LayoutSpacer.create({width: "1%"}), VLayout_Institute_Institute_TrainingPlace_Equipment]
    });

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
            {
                id: "TabPane_Institute_TrainingPlace",
                title: "<spring:message code='institute.placelist'/>",
                pane: HLayout_Institute_Institute_TrainingPlace

            },

            {
                id: "TabPane_Institute_Teacher",
                title: "<spring:message code='institute.teacherlist'/>",
                pane: VLayout_Institute_Institute_Teacher
            },
            {
                id: "TabPane_Institute_Equipment",
                title: "<spring:message code='institute.equipmentlist'/>",
                pane: VLayout_Institute_Institute_Equipment
            },
            {
                id: "TabPane_Institute_Account",
                title: "<spring:message code='institute.accountlist'/>",
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
                        globalWait = wait;
                        isc.RPCManager.sendRequest(TrDSRequest(institute_Institute_Url + record.id, "DELETE", null, "callback: ListGrid_Institute_Institute_Remove_CallBack(rpcResponse)"));
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
            DynamicForm_Institute_Institute.clearValues();
DynamicForm_Institute_Institute_Address.getItem("cityId").setOptionDataSource(null);
DynamicForm_Institute_Institute_Address.getItem("stateId").fetchData();

            ValuesManager_Institute_InstituteValue.editRecord(record);

            var stateValue = undefined;
            var cityValue = undefined;

            if (record != null && record.stateId != null)
                stateValue = record.stateId;
            if (record != null && record.cityId != null)
                cityValue = record.cityId;
            if (cityValue == undefined) {
                DynamicForm_Institute_Institute_Address.clearValue("cityId");
            }
            if (stateValue != undefined) {
                RestDataSource_Institute_City.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue;
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

    function ListGrid_institute_print(type) {
        var advancedCriteria = ListGrid_Institute_Institute.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/institute/printWithCriteria/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "token", type: "hidden"}
                ]

        });
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.setValue("token", "<%= accessToken %>");
        criteriaForm.show();
        criteriaForm.submitForm();

    }

    function ListGrid_Institute_Institute_Remove_CallBack(resp) {
        globalWait.close();
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


    function checkEmail(email) {
        return !(email.indexOf("@") === -1 || email.indexOf(".") === -1 || email.lastIndexOf(".") < email.indexOf("@"));
    }

    function checkMobile(mobile) {
        return mobile[0] === "0" && mobile[1] === "9" && mobile.length === 11;
    }

    function checkPhone(phone) {
        return (phone[0] === "0" && phone.length === 11) || (phone[0] !== "0" && phone.length === 8);
    }
