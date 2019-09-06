<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    <%
   final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    %>

    var instituteMethod = "POST";
    var instituteWait;

    var mailCheck = true;

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//


    var RestDataSource_Institute_Institute = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "teacherNumPHD"},
            {name: "teacherNumLicentiate"},
            {name: "empNumLicentiate"},
            {name: "teacherNumMaster"},
            {name: "empNumMaster"},
            {name: "teacherNumAssociate"},
            {name: "empNumAssociate"},
            {name: "teacherNumDiploma"},
            {name: "empNumDiploma"},
            {name: "addressId"},
            {name: "address.state1.name"},
            {name: "address.city.name"},
            {name: "address.address"},
            {name: "address.postCode"},
            {name: "address.phone"},
            {name: "address.fax"},
            {name: "address.webSite"},
            {name: "address.address"},
            {name: "accountInfoId"},
            {name: "accountInfo.bank"},
            {name: "accountInfo.bankBranch"},
            {name: "accountInfo.bankBranchCode"},
            {name: "accountInfo.accountNumber"},
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
        fetchDataURL: instituteUrl + "spec-list"
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
        fetchDataURL: instituteUrl + "training-place/0"
    });
    var RestDataSource_Institute_TrainingPlace_Equipment = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: instituteUrl + "training-place-equipment/0"
    });
    var RestDataSource_Institute_Institite_Equipment = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: instituteUrl + "equipment/0"
    });
    var RestDataSource_Institute_Institite_UnAttachedEquipment = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: instituteUrl + "un-attached-equipment/0"
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
        fetchDataURL: instituteUrl + "teacher/0"
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
        fetchDataURL: instituteUrl + "un-attached-teacher/0"
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

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_Institute_Institute = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Institute_Institute_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_Institute_Institute_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "pieces/16/icon_edit.png", click: function () {
                ListGrid_Institute_Institute_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_Institute_Institute_Remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>", icon: "icon/pdf.png", click: function () {
                ListGrid_institute_print("pdf");
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "icon/excel.png", click: function () {
                ListGrid_institute_print("excel");
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "icon/html.jpg", click: function () {
                ListGrid_institute_print("html");
            }
        }]
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

        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان فارسی", align: "center", filterOperator: "contains"},
            {name: "titleEn", title: "عنوان لاتین", align: "center", filterOperator: "contains"},
            {name: "manager.firstNameFa", title: "نام مدیر", align: "center", filterOperator: "contains"},
            {name: "manager.lastNameFa", title: "نام خانوادگی مدیر", align: "center", filterOperator: "contains"},
            {name: "parentInstitute.titleFa", title: "موسسه مادر", align: "center", filterOperator: "contains"},
            {name: "einstituteType.titleFa", title: "نوع موسسه", align: "center", filterOperator: "contains"},
            {name: "elicenseType.titleFa", title: "نوع مدرک", align: "center", filterOperator: "contains"},
            {name: "address.state.name", title: "استان", align: "center", filterOperator: "contains"},
            {name: "address.city.name", title: "شهر", align: "center", filterOperator: "contains"},
            {name: "address.address", title: "آدرس", align: "center", filterOperator: "contains"}
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
            {name: "personality.nationalCode", title: "کد ملی", align: "center"},
            {name: "economicalCode", title: "کد اقتصادی", align: "center"}
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

    var ListGrid_Institute_Attached_Equipment = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_Institite_Equipment,
        doubleClick: function () {
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "عنوان فارسی", align: "center"},
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

    var ListGrid_Institute_TrainingPlace = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Institute_TrainingPlace,
        doubleClick: function () {

        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "عنوان فارسی", align: "center"},
            {name: "titleEn", title: "عنوان لاتین ", align: "center"},
            {name: "capacity", title: "ظرفیت", align: "center"},
            {name: "ePlaceType.titleFa", title: "نوع محل", align: "center"},
            {name: "eArrangementType.titleFa", title: "شکل/ترتیب", align: "center"}
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
    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//
    var ValuesManager_Institute_InstituteValue = isc.ValuesManager.create({});


    var DynamicForm_Institute_Institute = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 150,
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
                name: "titleFa",
                title: "عنوان فارسی",
                colSpan: 2,
                width: 250,
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "255"
            },
            {
                name: "titleEn",
                title: "عنوان لاتین",
                colSpan: 2,
                width: 250,
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9| ]",
                length: "255"
            },
            {
                name: "addressId",
                hidden: true
            },
            {
                name: "accountInfoId",
                hidden: true
            },
            {
                name: "parentInstituteId",
                title: "موسسه مادر",
                type: 'text',
                keyPressFilter: "[0-9]",
                width: 250,
                length: "10"
            },
            {
                name: "parentInstitute.titleFa",
                title: "عنوان موسسه مادر",
                showTitle: false,
                colSpan: 4,
                width: 500,
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "255"
            },
            {
                name: "managerId", hidden: true
            },
            {
                name: "manager.nationalCode",
                title: "مدیر موسسه",
                width: 250,
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
            {
                name: "manager.firstNameFa",
                title: "<spring:message code='account.number'/>",
                showTitle: false,
                colSpan: 2,
                width: 250,
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "30"
            },
            {
                name: "manager.lastNameFa",
                title: "<spring:message code='cart.number'/>",
                showTitle: false,
                colSpan: 2,
                width: 250,
                type: 'text',
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
                length: "30"
            },
            {
                name: "eInstituteTypeId",
                type: "IntegerItem",
                colSpan: 2,
                title: "نوع موسسه",
                width: 250,
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
                name: "eLicenseTypeId",
                type: "IntegerItem",
                title: "نوع مدرک",
                colSpan: 2,
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: 250,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
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
        titleWidth: 150,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "ValuesManager_Institute_InstituteValue",
        numCols: 2,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 2,
        newPadding: 5,
        fields: [
            {
                name: "teacherNumPHD",
                title: "استاد دکتری",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
            {
                name: "teacherNumLicentiate",
                title: "استاد لیسانس",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
            {
                name: "teacherNumMaster",
                title: "استاد فوق لیسانس",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
            {
                name: "teacherNumAssociate",
                title: "استاد فوق دیپلم",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
            {
                name: "teacherNumDiploma",
                title: "استاد دیپلم/زیردیپلم",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            }
        ]

    });
    var DynamicForm_Institute_InstituteEmpNum = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 150,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "ValuesManager_Institute_InstituteValue",
        numCols: 2,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 2,
        newPadding: 5,
        fields: [
            {
                name: "empNumPHD",
                title: " کارمند دکتری",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
            {
                name: "empNumLicentiate",
                title: "کارمند لیسانس",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
            {
                name: "empNumMaster",
                title: "کارمند فوق  لیسانس",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
            {
                name: "empNumAssociate",
                title: " کارمند فوق دیپلم",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },
            {
                name: "empNumDiploma",
                title: "کارمند  دیپلم/زیردیپلم",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            }
        ]

    });

    var DynamicForm_Institute_Institute_Address = isc.DynamicForm.create({
        width: "100%",
        titleWidth: "120",
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
        numCols: 6,
        fields: [
            {
                name: "address.id",
                hidden: true
            },
            {
                name: "address.stateId",
                type: "IntegerItem",
                title: "استان",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Institute_State,
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
            },
            {
                name: "address.cityId",
                type: "IntegerItem",
                title: "شهر",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
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
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}],
            },
            {
                name: "address.postCode",
                title: "کد پستی",
                keyPressFilter: "[0-9]",
                length: "15",
            },
            {
                name: "address.address",
                title: "آدرس",
                required: true,
                colSpan: 5,
                keyPressFilter: "[a-z|A-Z |]",
                hint: "English/انگليسي",
                showHintInField: true,
                width: 600,
                length: "255"
            },
            {
                name: "address.phone",
                title: "تلفن"
            },
            {
                name: "address.fax",
                title: "فکس",
                hint: "test@nicico.com",
                showHintInField: true,
                length: "30"
            },
            {
                name: "address.webSite",
                title: "وب سایت",
                hint: "test@nicico.com",
                showHintInField: true,
                length: "30"
            }]
    });

    var DynamicForm_Institute_Institute_Account = isc.DynamicForm.create({
        width: "100%",
        titleWidth: "120",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "ValuesManager_Institute_InstituteValue",
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 4,
        fields: [
            {name: "id", hidden: true},

            {
                name: "accountInfo.id",
                hidden: true
            },
            {
                name: "accountInfo.bank",
                title: "بانک",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true,
                length: "30"
            },
            {
                name: "accountInfo.bankBranch",
                title: "شعبه",
                required: true,
                keyPressFilter: "[a-z|A-Z |0-9]",
                hint: "English/انگليسي",
                showHintInField: true,
                length: "30"
            },
            {
                name: "accountInfo.bankBranchCode",
                title: "کد شعبه",
                required: true,
                keyPressFilter: "[0-9]",
                hint: "English/انگليسي",
                showHintInField: true,
                length: "30"
            },
            {
                name: "accountInfo.accountNumber",
                title: "شماره حساب",
                required: true,
                keyPressFilter: "[0-9]",
                hint: "English/انگليسي",
                showHintInField: true,
                length: "30"
            }
        ]

    });

    var TabSet_Institute_InstituteTeacherNum = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "100%",
        width: "48%",
        margin: 20,
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
        height: "100%",
        width: "48%",
        margin: 20,
        newPadding: 5,
        tabs: [
            {
                title: "تعداد کارمندان", canClose: false,
                pane: DynamicForm_Institute_InstituteEmpNum
            }
        ]
    });
    var TabSet_Institute_InstituteAddress = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "100%",
        width: "100%",
        margin: 20,
        newPadding: 5,
        tabs: [
            {
                title: "ارتباط با موسسه", canClose: false,
                pane: DynamicForm_Institute_Institute_Address
            }
        ]
    });
    var TabSet_Institute_InstituteAccount = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "100%",
        width: "100%",
        margin: 20,
        newPadding: 5,
        tabs: [
            {
                title: "حساب بانکی", canClose: false,
                pane: DynamicForm_Institute_Institute_Account
            }
        ]
    });

    var HLayout_Institute_InstituteTeacherAndEmp = isc.HLayout.create({
        width: "100%",
        height: 200,
        margin: 2,
        newPadding: 5,

        members: [TabSet_Institute_InstituteEmpNum, TabSet_Institute_InstituteTeacherNum]
    });


    var VLayout__Institute_Institute_Val = isc.VLayout.create({
        width: "100%",
        height: "50%",
        // border: "1px solid blue",
        padding: 5,
        members: [DynamicForm_Institute_Institute, HLayout_Institute_InstituteTeacherAndEmp]
    });
    var VLayout__Institute_Institute_Address = isc.VLayout.create({
        width: "100%",
        height: "25%",
        // border: "1px solid blue",
        members: [TabSet_Institute_InstituteAddress]
    });
    var VLayout__Institute_Institute_Account = isc.VLayout.create({
        width: "100%",
        height: "25%",
        // border: "1px solid blue",
        members: [TabSet_Institute_InstituteAccount]
    });

    var IButton_Institute_Institute_Exit = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "pieces/16/icon_delete.png",
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
            var instituteSaveUrl = instituteUrl;
            if (instituteMethod.localeCompare("PUT") == 0) {
                var instituteRecord = ListGrid_Institute_Institute.getSelectedRecord();
                instituteSaveUrl += instituteRecord.id;
            }
            isc.RPCManager.sendRequest(MyDsRequest(instituteSaveUrl, instituteMethod, JSON.stringify(data), "callback: institute_action_result(rpcResponse)"));
        }
    });

    var VLayout_Institute_Institute_Form = isc.VLayout.create({
        width: "100%",
        height: "690",
        members: [VLayout__Institute_Institute_Val, VLayout__Institute_Institute_Address, VLayout__Institute_Institute_Account]
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
            members: [VLayout_Institute_Institute_Form, HLayOut_Institute_InstituteSaveOrExit]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Institute_Institute_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
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

    var HLayout_Institute__Institute_TrainingPlace = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Institute_TrainingPlace]
    });
    var HLayout_Institute_Institute_Teacher = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Institute_Attached_Teacher]
    });
    var HLayout_Institute_Institute_Equipment = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Institute_Attached_Equipment]
    });

    var Tab_Institute_Detail = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {
                id: "TabPane_Institute_TrainingPlace",
                title: "لیست محل های آموزشی",
                pane: HLayout_Institute__Institute_TrainingPlace

            },
            {
                id: "TabPane_Institute_Teacher",
                title: "لیست اساتید",
                pane: HLayout_Institute_Institute_Teacher

            },
            {
                id: "TabPane_Institute_Equipment",
                title: "لیست تجهیزات کمک آموزشی",
                pane: HLayout_Institute_Institute_Equipment
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
                message: "مهارتی برای حذف انتخاب نشده است!",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "آيا مي خواهيد اين مهارت حذف گردد؟",
                icon: "[SKIN]ask.png",
                title: "هشدار",
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
                            actionURL: instituteUrl + record.id,
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
                                        message: "مهارت با موفقيت حذف گرديد",
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
                message: "مهارتی برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            //console.log('record:' + JSON.stringify(record));
            var id = record.categoryId;
            DynamicForm_Institute_Institute.clearValues();
            instituteMethod = "PUT";
            DynamicForm_Institute_Institute.editRecord(record);
            Window_Institute_Institute.setTitle(" ویرایش مرکز آموزشی " + getFormulaMessage(ListGrid_Institute_Institute.getSelectedRecord().code, 3, "red", "I"));
            Window_Institute_Institute.show();

        }
    };

    function ListGrid_Institute_Institute_Add() {
        ValuesManager_Institute_InstituteValue.clearValues();
        ValuesManager_Institute_InstituteValue.clearErrors(true);
        instituteMethod = "POST";
        DynamicForm_Institute_Institute.clearValues();
        // DynamicForm_Institute_Institute.getField("addressId").setValue(0);
        // DynamicForm_Institute_Institute.getField("accountInfoId").setValue(0);
        //
        // DynamicForm_Institute_Institute_Account.getField("accountInfo.id").setValue(0)
        // DynamicForm_Institute_Institute_Address.getField("address.id").setValue(0)
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

