<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

    var method = "POST";
    var url = "${restApiUrl}/api/teacher";

    var responseID;
    var categoryList;
    var gridState;
    var attachName;
    var attachNameTemp;

    var codeMeliCheck = true;
    var cellPhoneCheck = true;
    var mailCheck = true;

    var photoDescription = "* سایز عکس بین 5 تا 1000 KB" + "<br/>" + "<br/>" + "* اندازه ی عکس بین 300*100 تا 400*200 px" + "<br/>" + "<br/>" +  "* فرمت عکس jpg,png,gif";

    var dummy = false;

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_Teacher_JspTeacher = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true}, {name: "fullNameFa"}, {name: "fullNameEn"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/teacher/spec-list"
    });


    var RestDataSource_Egender_JspTeacher = isc.RestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: enumUrl + "eGender/spec-list"
    });

    var RestDataSource_Emarried_JspTeacher = isc.RestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: enumUrl + "eMarried/spec-list"
    });

    var RestDataSource_Emilitary_JspTeacher = isc.RestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: enumUrl + "eMilitary/spec-list"
    });

    var RestDataSource_Category_JspTeacher = isc.RestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/category/spec-list"
    });

    var RestDataSource_Education_Level_JspTeacher = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/educationLevel/spec-list"
    });

    var RestDataSource_Education_Major_JspTeacher = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/educationMajor/spec-list"
    });

    var RestDataSource_Education_Orientation_JspTeacher = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/educationOrientation/spec-list"
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_Teacher_JspTeacher = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_teacher_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_teacher_add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "pieces/16/icon_edit.png", click: function () {
                ListGrid_teacher_edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_teacher_remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>", icon: "icon/pdf.png", click: function () {
                "<spring:url value="/teacher/print/pdf" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "icon/excel.png", click: function () {
                "<spring:url value="/teacher/print/excel" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "icon/html.jpg", click: function () {
                "<spring:url value="/teacher/print/html" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Listgrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Teacher_JspTeacher = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Teacher_JspTeacher,
        contextMenu: Menu_ListGrid_Teacher_JspTeacher,
        doubleClick: function () {
            ListGrid_teacher_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "fullNameFa", title: "<spring:message code='firstName'/>", align: "center"},
            {name: "fullNameEn", title: "<spring:message code='firstName.latin'/>", align: "center"}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
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

    var vm = isc.ValuesManager.create({});

    var DynamicForm_ViewLoader_JspTeacher = isc.Label.create({
        height: "140px",
        width: "145px",
        align: "center",
        valign: "center",
        contents: photoDescription
    });

    var showAttachViewLoader = isc.ViewLoader.create({
        autoDraw: false,
        viewURL: "",
        overflow: "scroll",
        height: "140px",
        width: "130px",
        border: "1px solid red",
        scrollbarSize: 0,
        loadingMessage: "تصویری آپلود نشده است"
    });

    var VLayOut_ViewLoader_JspTeacher = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [showAttachViewLoader,
            DynamicForm_ViewLoader_JspTeacher]
    });

    var DynamicForm_BasicInfo_JspTeacher = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "vm",
        numCols: 6,
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        canTabToIcons: false,
        fields: [
            {name: "id", hidden: true},

            {
                name: "teacherCode",
                title: "کد مدرس",
                type: 'text',
                disabled: true
            },

            {
                name: "fullNameFa",
                title: "نام و نام خانوادگی",
                type: 'text',
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true
            },

            {
                name: "fullNameEn",
                title: "نام لاتین",
                type: 'text',
                required: true,
                keyPressFilter: "[a-z|A-Z |]",
                hint: "English/انگليسي",
                showHintInField: true
            },

            {
                name: "nationalCode",
                title: "کد ملی",
                type: 'text',
                required: true,
                wrapTitle: false,
                keyPressFilter: "[0-9]",
                length : "10",
                hint: "کد ملی ده رقمی را وارد کنید",
                showHintInField: true
                ,blur:function()
                        {
                            var codeCheck = false;
                            codeCheck = checkCodeMeli(DynamicForm_BasicInfo_JspTeacher.getValue("nationalCode"));
                            codeMeliCheck = codeCheck;
                            if(codeCheck == false)
                                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("nationalCode","کد ملی اشتباهی را وارد کرده اید", true);

                            if(codeCheck == true)
                                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("nationalCode", true);
                        }
            },

            {
                name: "fatherName",
                title: "نام پدر",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true,
                length: "30"
            },

            {
                name: "egender.id",
                type: "IntegerItem",
                title: "جنسیت",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Egender_JspTeacher,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
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
                name: "birthDate",
                title: "تاریخ تولد",
                ID: "birthDate_jspTeacher",
                type: 'text',
                hint: "YYYY/MM/DD",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('birthDate_jspTeacher', this, 'ymd', '/');
                },
                icons: [{
                    src: "pieces/pcal.png",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('birthDate_jspTeacher', this, 'ymd', '/');
                    }
                }],
                validators: [{
                    validateOnExit: true,
                    type: "substringCount",
                    substring: "/",
                    operator: "==",
                    count: "2",
                    min: 10,
                    max: 10,
                    stopOnError: true,
                    errorMessage: "<spring:message code='msg.correct.date'/>"
                }]
            },

            {
                name: "birthLocation",
                title: "محل تولد",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },


            {
                name: "birthCertificate",
                title: "شماره شناسنامه",
                type: 'text',
                keyPressFilter: "[/|0-9]",
                length: "15"
            },

            {
                name: "birthCertificateLocation",
                title: "محل صدور",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },

            {
                name: "religion",
                title: "دین/مذهب",
                type: 'text',
                defaultValue: "اسلام",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },

            {
                name: "nationality",
                title: "ملیت",
                type: 'text',
                defaultValue: "ایرانی",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },

            {
                name: "emarried.id",
                type: "IntegerItem",
                title: "وضعیت تاهل",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Emarried_JspTeacher,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
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
                name: "email",
                title: "پست الکترونیکی",
                type: 'text',
                hint: "test@nicico.com",
                showHintInField: true,
                length: "30"
                ,blur:function()
                        {
                            var emailCheck = false;
                            emailCheck= checkEmail(DynamicForm_BasicInfo_JspTeacher.getValue("email"));
                            mailCheck = emailCheck;
                            if(emailCheck == false)
                                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("email","پست الکترونیکی اشتباهی را وارد کرده اید", true);

                            if(emailCheck == true)
                                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("email", true);
                        }
            },

            {
                name: "educationLevelId",
                title: "مقطع تحصیلی",
                textAlign: "center",
                editorType: "ComboBoxItem",
                pickListWidth: 230,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Level_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
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
                name: "educationMajorId",
                title: "رشته تحصیلی",
                textAlign: "center",
                editorType: "ComboBoxItem",
                pickListWidth: 230,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Major_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
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
                name: "educationOrientationId",
                title: "گرایش تحصیلی",
                textAlign: "center",
                editorType: "ComboBoxItem",
                pickListWidth: 230,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Orientation_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                disabled: true,
                cachePickListResults: false,
                useClientFiltering: false,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
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
                name: "emilitary.id",
                type: "IntegerItem",
                title: "نظام وظیفه",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Emilitary_JspTeacher,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
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
                name: "mobile",
                title: "تلفن همراه",
                type: 'text',
                keyPressFilter: "[/|0-9]",
                length: "11",
                hint: "*********09",
                showHintInField: true,
                errorMessage: "شماره ی موبایل اشتباهی را وارد کرده اید"
                ,blur:function()
                        {
                            var mobileCheck = false;
                            mobileCheck = checkMobile(DynamicForm_BasicInfo_JspTeacher.getValue("mobile"));
                            cellPhoneCheck = mobileCheck;
                            if(mobileCheck == false)
                                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("mobile","شماره ی موبایل اشتباهی را وارد کرده اید", true);

                            if(mobileCheck == true)
                                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("mobile", true);
                        }
            },

            {
                name: "economicalCode",
                title: "کد اقتصادی",
                type: 'text',
                keyPressFilter: "[0-9]",
                length : "15",
                stopOnError: true
            },

            {
                name: "economicalRecordNumber",
                title: "شماره ثبت",
                type: 'text',
                keyPressFilter: "[0-9]",
                length : "15",
                stopOnError: true
            },

            {
                name: "description",
                title: "توضیحات",
                type: 'textArea',
                length: "500",
                height: 30
            },

            {
                name: "enableStatus",
                title: "وضعیت",
                type: "radioGroup",
                valueMap: {"true": "فعال", "false": "غیرفعال"},
                vertical: false,
                defaultValue: "true"
            },

            {
                name: "categoryList",
                type: "selectItem",
                textAlign: "center",
                title: "زمینه ی آموزش",
                autoFetchData: true,
                optionDataSource: RestDataSource_Category_JspTeacher,
                valueField: "id",
                displayField: "titleFa",
                multiple: true,
                pickListProperties: {
                    showFilterEditor: true,
                    gridComponents: [
                        isc.ToolStrip.create({
                            autoDraw: false,
                            height: 30,
                            width: "100%",
                            members: [
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/approve.png",
                                    title: "انتخاب همه",
                                    click: function () {
                                        var item = DynamicForm_BasicInfo_JspTeacher.getField("categoryList"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i]["id"];
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();
                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "حذف همه",
                                    click: function () {
                                        var item = DynamicForm_BasicInfo_JspTeacher.getField("categoryList");
                                        item.setValue([]);
                                        item.pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                }
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name == "nationalCode")
                this.getItem("teacherCode").setValue(item.getValue());
            if (item.name == "educationMajorId") {
                if (newValue == undefined) {
                    DynamicForm_BasicInfo_JspTeacher.clearValue("educationOrientationId");
                    DynamicForm_BasicInfo_JspTeacher.getField("educationOrientationId").disabled = true;
                }
                else {
                    RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = "${restApiUrl}/api/educationMajor/spec-list-by-majorId/" + newValue;
                    DynamicForm_BasicInfo_JspTeacher.getField("educationOrientationId").fetchData();
                    DynamicForm_BasicInfo_JspTeacher.getField("educationOrientationId").disabled = false;
                }
            }
            if (item.name == "attachPic") {
                showTempAttach();
            }
        }
    });


    var DynamicForm_Photo_JspTeacher = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 0,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleSuffix: "",
        valuesManager: "vm",
        numCols: 2,
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                ID: "attachPic",
                name: "attachPic",
                title: "",
                type: "file",
                titleWidth: "80",
                accept: ".png,.gif,.jpg",
                multiple: "",
                width: "100%"
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name == "attachPic") {
            showTempAttach();
             setTimeout(function () {
                 if(attachNameTemp == null || attachNameTemp == ""){
                    DynamicForm_Photo_JspTeacher.getField("attachPic").setValue(null);
                    showAttachViewLoader.setView();
                 }
             }, 300);
            }
        }
    });

    var DynamicForm_JobInfo_JspTeacher = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "vm",
        numCols: 6,
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},

            {
                name: "workName",
                title: "محل کار",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "workPhone",
                title: "تلفن",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "11"
            },

            {
                name: "workPostalCode",
                title: "کد پستی",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "15"
            },

            {
                name: "workJob",
                title: "شغل",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "workTeleFax",
                title: "دورنگار",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "workAddress",
                title: "آدرس",
                type: 'textArea',
                height: 30,
                length: "255"
            },

            {
                name: "workWebSite",
                title: "وبسایت",
                type: 'text',
                length: "30"
            },

        ]
    });

    var DynamicForm_AccountInfo_JspTeacher = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "vm",
        numCols: 6,
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},

            {
                name: "accountNember",
                title: "شماره حساب",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "bank",
                title: "بانک",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "bankBranch",
                title: "شعبه بانک",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "cartNumber",
                title: "شماره کارت",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "shabaNumber",
                title: "شماره شبا",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },

        ]
    });

    var DynamicForm_AddressInfo_JspTeacher = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "vm",
        numCols: 2,
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},

            {
                name: "homePhone",
                title: "تلفن",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "11"
            },

            {
                name: "homePostalCode",
                title: "کد پستی",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "15"
            },

            {
                name: "homeAddress",
                title: "آدرس",
                type: 'textArea',
                height: 30,
                length: "255"
            },

        ]
    });

    var IButton_Teacher_Save_JspTeacher = isc.IButton.create({
        top: 260, title: "<spring:message code='save'/>", click: function () {


            if (codeMeliCheck == false || cellPhoneCheck == false || mailCheck == false)
                return;

            vm.validate();
            if (vm.hasErrors()) {
                return;
            }

            var nCode = DynamicForm_BasicInfo_JspTeacher.getField("nationalCode").getValue();
            DynamicForm_BasicInfo_JspTeacher.getField("teacherCode").setValue(nCode);

            var data = vm.getValues();

            isc.RPCManager.sendRequest({
                actionURL: url,
                httpMethod: method,
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        responseID = JSON.parse(resp.data).id;
                        gridState = "[{id:" + responseID + "}]";
                        categoryList = DynamicForm_BasicInfo_JspTeacher.getField("categoryList").getValue();
                        var OK = isc.Dialog.create({
                            message: "<spring:message code='msg.operation.successful'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='msg.command.done'/>"
                        });
                        setTimeout(function () {
                            OK.close();
                            ListGrid_Teacher_JspTeacher.setSelectedState(gridState);
                        }, 1000);
                        if(categoryList != undefined)
                            addCategories(responseID, categoryList);
                            addAttach(responseID);
                            showAttachViewLoader.hide();
                            ListGrid_Teacher_JspTeacher.invalidateCache();
                            Window_Teacher_JspTeacher.close();
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

                }
            });

        }
    });

    var IButton_Teacher_Exit_JspTeacher = isc.IButton.create({
        title: "<spring:message code='cancel'/>",
        prompt: "",
        width: 100,
        orientation: "vertical",
        click: function () {
            showAttachViewLoader.hide();
            Window_Teacher_JspTeacher.close();
        }
    });

    var HLayOut_TeacherSaveOrExit_JspTeacher = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Teacher_Save_JspTeacher, IButton_Teacher_Exit_JspTeacher]
    });

    var TabSet_BasicInfo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "300",
        tabs: [
            {
                title: "اطلاعات پایه", canClose: false,
                pane: DynamicForm_BasicInfo_JspTeacher
            }
        ]
    });

    var TabSet_JobInfo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "150",
        tabs: [
            {
                title: "محل کار", canClose: false,
                pane: DynamicForm_JobInfo_JspTeacher
            }
        ]
    });

    var TabSet_AccountInfo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        tabs: [
            {
                title: "اطلاعات حساب", canClose: false,
                pane: DynamicForm_AccountInfo_JspTeacher
            }
        ]
    });

    var TabSet_AddressInfo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "150",
        tabs: [
            {
                title: "محل سکونت", canClose: false,
                pane: DynamicForm_AddressInfo_JspTeacher
            }
        ]
    });

	var VLayOut_Photo_JspTeacher = isc.VLayout.create({
		layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		alignLayout: "center",
		align: "center",
		padding: 10,
		membersMargin: 10,
        height: "180",
		members: [VLayOut_ViewLoader_JspTeacher, DynamicForm_Photo_JspTeacher]
	});

    var TabSet_Photo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "340",
        width: "25%",
        alignLayout: "center",
        align: "center",
        tabs: [
            {
                title: "عکس پرسنلی", canClose: false,
                pane: VLayOut_Photo_JspTeacher
            }
        ]
    });

    var VLayOut_Temp_JspTeacher = isc.VLayout.create({
    	layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		alignLayout: "center",
		align: "center",
		padding: 10,
		height: "350",
        width: "75%",
		membersMargin: 10,
		members: [TabSet_AddressInfo_JspTeacher, TabSet_JobInfo_JspTeacher]
    });

    var HLayOut_Temp_JspTeacher = isc.HLayout.create({
        layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		alignLayout: "center",
		align: "center",
		padding: 10,
		membersMargin: 10,
		members: [TabSet_Photo_JspTeacher,VLayOut_Temp_JspTeacher]
    });



    var Window_Teacher_JspTeacher = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code='teacher'/>",
        canDragReposition: true,
        canDragResize: true,
        autoSize: true,
        align: "center",
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [
                TabSet_BasicInfo_JspTeacher,
                HLayOut_Temp_JspTeacher,
                TabSet_AccountInfo_JspTeacher,
                HLayOut_TeacherSaveOrExit_JspTeacher
            ]
        })]
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Refresh_JspTeacher = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "<spring:message code='refresh'/>",
        click: function () {
            ListGrid_teacher_refresh();
        }
    });

    var ToolStripButton_Edit_JspTeacher = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_teacher_edit();
        }
    });

    var ToolStripButton_Add_JspTeacher = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code='create'/>",
        click: function () {
            ListGrid_teacher_add();
        }
    });

    var ToolStripButton_Remove_JspTeacher = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_teacher_remove();
        }
    });

    var ToolStripButton_Print_JspTeacher = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            "<spring:url value="/teacher/print/pdf" var="printUrl"/>"
            window.open('${printUrl}');
        }
    });

    var ToolStrip_Actions_JspTeacher = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Refresh_JspTeacher,
            ToolStripButton_Add_JspTeacher,
            ToolStripButton_Edit_JspTeacher,
            ToolStripButton_Remove_JspTeacher,
            ToolStripButton_Print_JspTeacher
        ]
    });

    var HLayout_Grid_Teacher_JspTeacher = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Teacher_JspTeacher]
    });

    var HLayout_Actions_Teacher = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspTeacher]
    });

    var VLayout_Body_Teacher_JspTeacher = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Teacher
            , HLayout_Grid_Teacher_JspTeacher
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_teacher_refresh() {
        ListGrid_Teacher_JspTeacher.invalidateCache();
    };

    function ListGrid_teacher_edit() {
        showAttachViewLoader.show();
        showAttachViewLoader.setView();
        vm.clearValues();
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("mobile", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("email", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("nationalCode", true);
        var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.record.not.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            method = "PUT";
            url = "${restApiUrl}/api/teacher/" + record.id;
            vm.editRecord(record);
            Window_Teacher_JspTeacher.show();
            Window_Teacher_JspTeacher.bringToFront();
        }
    };

    function ListGrid_teacher_add() {
        showAttachViewLoader.show();
        showAttachViewLoader.setView();
        vm.clearValues();
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("mobile", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("email", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("nationalCode", true);
        method = "POST";
        url = "${restApiUrl}/api/teacher";
        vm.clearValues();
        Window_Teacher_JspTeacher.show();
        Window_Teacher_JspTeacher.bringToFront();
    };

    function ListGrid_teacher_remove() {
        var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
        if (record == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.record.not.selected'/>",
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
                        var wait = isc.Dialog.create({
                            message: "<spring:message code='msg.waiting'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='message'/>"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: "${restApiUrl}/api/teacher/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Teacher_JspTeacher.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code='msg.record.remove.successful'/>",
                                        icon: "[SKIN]say.png",
                                        title: "<spring:message code='msg.command.done'/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 3000);
                                }
                                else if(resp.data==false){
                                    var ERROR = isc.Dialog.create({
                                        message: "این استاد دارای حداقل یک کلاس می باشد و قابل حذف نیست",
                                        icon: "[SKIN]stop.png",
                                        title: "<spring:message code='message'/>"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 3000);
                                }
                                 else {
                                    var ERROR = isc.Dialog.create({
                                        message: "<spring:message code='msg.record.remove.failed'/>",
                                        icon: "[SKIN]stop.png",
                                        title: "<spring:message code='message'/>"
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

    function addCategories(teacherId, categoryIds) {
        var JSONObj = {"ids": categoryIds};
        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: "${restApiUrl}/api/teacher/addCategories/" + teacherId,
            httpMethod: "POST",
            data: JSON.stringify(JSONObj),
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                } else {
                    isc.say("<spring:message code='error'/>");
                }
            }
        });
    };

    function addAttach(teacherId) {
        var formData1 = new FormData();
        var fileBrowserId = document.getElementById(window.attachPic.uploadItem.getElement().id);
        var file = fileBrowserId.files[0];
        formData1.append("file", file);
        if (file != undefined) {
            var request = new XMLHttpRequest();
            request.open("POST", "${restApiUrl}/api/teacher/addAttach/" + teacherId);
            request.setRequestHeader("Authorization", "Bearer " + "${cookie['access_token'].getValue()}");
            request.send(formData1);
            request.onreadystatechange = function () {
                attachName = request.response;
                if (request.readyState == XMLHttpRequest.DONE) {
                    if (request.responseText == "error")
                        isc.say("آپلود فایل با مشکل مواجه شده است.");
                    if (request.responseText == "badFile")
                        isc.say("آپلود فایل قابل قرارگیری روی موتور گردش کار نیست.");
                    if (request.responseText == "success")
                        isc.say("فایل فرایند با موفقیت روی موتور گردش کار قرار گرفت");
                }
            }
        }
    };

    <%--function showAttach() {--%>
        <%--showAttachViewLoader.setViewURL("/teacher/getAttach/" + attachName + "/" + responseID + "?Authorization=Bearer " + '${cookie['access_token'].getValue()}');--%>
        <%--showAttachViewLoader.show();--%>
    <%--};--%>

    function showTempAttach() {
        var formData1 = new FormData();
        var fileBrowserId = document.getElementById(window.attachPic.uploadItem.getElement().id);
        var file = fileBrowserId.files[0];
        formData1.append("file", file);
        if (file !== undefined) {
            var request = new XMLHttpRequest();
            request.open("POST", "${restApiUrl}/api/teacher/addTempAttach");
            request.setRequestHeader("Authorization", "Bearer " + "${cookie['access_token'].getValue()}");
            request.send(formData1);
            request.onreadystatechange = function () {
                attachNameTemp = request.response;
                showAttachViewLoader.setViewURL("/teacher/getTempAttach/" + attachNameTemp + "?Authorization=Bearer " + '${cookie['access_token'].getValue()}');
                showAttachViewLoader.show();
        }
        }

    };

   function checkCodeMeli(code)
   {
            if(code=="undefined" && code==null && code=="")
                return false;
            var L=code.length;

            if(L<8 || parseFloat(code,10)==0) return false;
            code=('0000'+code).substr(L+4-10);
            if(parseFloat(code.substr(3,6),10)==0) return false;
            var c=parseFloat(code.substr(9,1),10);
            var s=0;
            for(var i=0;i<9;i++)
            s+=parseFloat(code.substr(i,1),10)*(10-i);
            s=s%11;
            return (s<2 && c==s) || (s>=2 && c==(11-s));
            return true;
   };

   function checkEmail(email)
   {
       if (email.indexOf("@") == -1 || email.indexOf(".") == -1 || email.lastIndexOf(".") < email.indexOf("@"))
            return false;
       else
            return true;
   };


   function checkMobile(mobile)
   {
       if (mobile[0] == "0" && mobile[1] == "9")
            return true;
       else
            return false;
   };



