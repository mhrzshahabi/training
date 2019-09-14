<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


// <script>
var dummy;
    var teacherMethod = "POST";
    var teacherWait;

    var responseID;
    var categoryList;
    var gridState;
    var attachName;
    var attachNameTemp;

    var codeMeliCheck = true;
    var cellPhoneCheck = true;
    var mailCheck = true;
    var persianDateCheck = true;

    var selectedRecordPersonalID = null;

    var photoDescription = "<spring:message code='photo.size.hint'/>" + "<br/>" + "<br/>" +
        "<spring:message code='photo.dimension.hint'/>" + "<br/>" + "<br/>" +
        "<spring:message code='photo.format.hint'/>";

    var teacherCategoriesID = new Array();

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    // ------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_Teacher_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "teacherCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationLevel.titleFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"}
        ],
        fetchDataURL: teacherUrl + "spec-list"
    });


    var RestDataSource_Egender_JspTeacher = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eGender/spec-list"
    });

    var RestDataSource_Emarried_JspTeacher = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eMarried/spec-list"
    });

    var RestDataSource_Emilitary_JspTeacher = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eMilitary/spec-list"
    });

    var RestDataSource_Category_JspTeacher = isc.MyRestDataSource.create({
        fields: [{name: "id"}, {name: "titleFa"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_Education_Level_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ],
        fetchDataURL: educationUrl + "level/spec-list"
    });

    var RestDataSource_Education_Major_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ],
        fetchDataURL: educationUrl + "major/spec-list"
    });

    var RestDataSource_Education_Orientation_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ]
    });

    var RestDataSource_Home_City_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ]
    });

    var RestDataSource_Home_State_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: stateUrl + "spec-list"
    });

    var RestDataSource_Work_City_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ]
    });

    var RestDataSource_Work_State_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "name"}
        ],
        fetchDataURL: stateUrl + "spec-list"
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
                ListGrid_teacher_print("pdf");
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "icon/excel.png", click: function () {
                ListGrid_teacher_print("excel");
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "icon/html.jpg", click: function () {
                ListGrid_teacher_print("html");
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
            {name: "teacherCode", title: "<spring:message code='code'/>", align: "center", filterOperator: "contains"},
            {
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "personality.educationLevel.titleFa",
                title: "<spring:message code='education.level'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "personality.educationMajor.titleFa",
                title: "<spring:message code='education.major'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "personality.contactInfo.mobile",
                title: "<spring:message code='mobile.connection'/>",
                align: "center",
                filterOperator: "contains"
            }
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

    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//

    var vm = isc.ValuesManager.create({});

    var DynamicForm_ViewLoader_JspTeacher = isc.Label.create({
        height: "140px",
        width: "145px",
        align: "center",
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
        loadingMessage: "<spring:message code='msg.photo.loading.error'/>"
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
        numCols: 8,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        canTabToIcons: false,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personality.nationalCode",
                title: "<spring:message code='national.code'/>",
                type: 'text',
                required: true,
                wrapTitle: false,
                keyPressFilter: "[0-9]",
                length: "10",
                width: "*",
                hint: "<spring:message code='msg.national.code.hint'/>",
                showHintInField: true
                , blur: function () {
                    var codeCheck = false;
                    codeCheck = checkCodeMeli(DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode"));
                    codeMeliCheck = codeCheck;
                    if (codeCheck == false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.nationalCode", "<spring:message
        code='msg.national.code.validation'/>", true);
                    if (codeCheck == true) {
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);
                        fillPersonalInfoFiels(DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode"));
                    }
                }
            },
            {
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                type: 'text',
                width: "*",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true
            },

            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                type: 'text',
                width: "*",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true
            },
            {
                name: "personality.fullNameEn",
                title: "<spring:message code='firstName.latin'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[a-z|A-Z |]",
                hint: "English/انگليسي",
                showHintInField: true
            },


            {
                name: "teacherCode",
                title: "<spring:message code='teacher.code'/>",
                type: 'text',
                width: "*",
                disabled: true
            },


            {
                name: "personality.fatherName",
                title: "<spring:message code='father.name'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true,
                length: "30"
            },


            {
                name: "personality.nationality",
                title: "<spring:message code='nationality'/>",
                type: 'text',
                width: "*",
                defaultValue: "<spring:message code='persian'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },
            {
                name: "personality.religion",
                title: "<spring:message code='religion'/>",
                type: 'text',
                width: "*",
                defaultValue: "<spring:message code='islam'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },

            {
                name: "personality.birthDate",
                title: "<spring:message code='birth.date'/>",
                ID: "birthDate_jspTeacher",
                type: 'text',
                width: "*",
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
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
                blur: function () {
                    var dateCheck = false;
                    dateCheck = checkBirthDate(DynamicForm_BasicInfo_JspTeacher.getValue("personality.birthDate"));
                    persianDateCheck = dateCheck;
                    if (dateCheck == false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.birthDate", "<spring:message
        code='msg.correct.date'/>", true);
                    if (dateCheck == true)
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.birthDate", true);
                }
            },

            {
                name: "personality.birthLocation",
                title: "<spring:message code='birth.location'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },
            {
                name: "personality.birthCertificate",
                title: "<spring:message code='birth.certificate'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[0-9]",
                length: "15"
            },

            {
                name: "personality.birthCertificateLocation",
                title: "<spring:message code='birth.certificate.location'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },

            {
                name: "personality.egenderId",
                type: "IntegerItem",
                title: "<spring:message code='gender'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Egender_JspTeacher,
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
                name: "personality.emarriedId",
                type: "IntegerItem",
                title: "<spring:message code='married.status'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Emarried_JspTeacher,
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
                name: "personality.emilitaryId",
                type: "IntegerItem",
                width: "*",
                title: "<spring:message code='military'/>",
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
                name: "enableStatus",
                title: "<spring:message code='status'/>",
                type: "radioGroup",
                width: "*",
                valueMap: {"true": "<spring:message code='enabled'/>", "false": "<spring:message code='disabled'/>"},
                vertical: false,
                defaultValue: "true"
            },

            {
                name: "personality.educationLevelId",
                title: "<spring:message code='education.level'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Level_JspTeacher,
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
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },

            {
                name: "personality.educationMajorId",
                title: "<spring:message code='education.major'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Major_JspTeacher,
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
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },

            {
                name: "personality.educationOrientationId",
                title: "<spring:message code='education.orientation'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
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
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "categoryList",
                type: "selectItem",
                textAlign: "center",
                width: "*",
                title: "<spring:message code='education.categories'/>",
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
                                    title: "<spring:message code='select.all'/>",
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
                                    title: "<spring:message code='deselect.all'/>",
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
            },


            {
                name: "personality.contactInfo.mobile",
                title: "<spring:message code='cellPhone'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[0-9]",
                length: "11",
                hint: "*********09",
                showHintInField: true,
                errorMessage: "<spring:message code='msg.mobile.validation'/>"
                , blur: function () {
                    var mobileCheck = false;
                    mobileCheck = checkMobile(DynamicForm_BasicInfo_JspTeacher.getValue("personality.contactInfo.mobile"));
                    cellPhoneCheck = mobileCheck;
                    if (mobileCheck == false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.contactInfo.mobile", "<spring:message
        code='msg.mobile.validation'/>", true);

                    if (mobileCheck == true)
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.mobile", true);
                }
            },
            {
                name: "personality.contactInfo.email",
                title: "<spring:message code='email'/>",
                type: 'text',
                width: "*",
                hint: "test@nicico.com",
                showHintInField: true,
                length: "30"
                , blur: function () {
                    var emailCheck = false;
                    emailCheck = checkEmail(DynamicForm_BasicInfo_JspTeacher.getValue("personality.contactInfo.email"));
                    mailCheck = emailCheck;
                    if (emailCheck == false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.contactInfo.email", "<spring:message
        code='msg.email.validation'/>", true);
                    if (emailCheck == true)
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
                }
            },


            {
                name: "personality.contactInfo.personalWebSite",
                title: "<spring:message code='personal.website'/>",
                type: 'text',
                width: "*",
                stopOnError: true
            },


            {
                name: "economicalCode",
                title: "<spring:message code='economical.code'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[0-9]",
                length: "15",
                stopOnError: true
            },

            {
                name: "economicalRecordNumber",
                title: "<spring:message code='economical.record.number'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[0-9]",
                length: "15",
                stopOnError: true
            },

            {
                name: "personality.description",
                title: "<spring:message code='description'/>",
                type: 'textArea',
                width: "*",
                length: "500",
                height: 30
            },


        ],
        itemChanged: function (item, newValue) {
            if (item.name == "personality.nationalCode")
                this.getItem("teacherCode").setValue(item.getValue());
            if (item.name == "personality.educationMajorId") {
                if (newValue == undefined) {
                    DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
                } else {
                    DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
                    RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = educationUrl + "major/spec-list-by-majorId/" + newValue;
                    DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").optionDataSource = RestDataSource_Education_Orientation_JspTeacher;
                    DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").fetchData();
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
        titleAlign: "left",
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
                accept: ".png,.gif,.jpg, .jpeg",
                multiple: "",
                width: "100%"
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name == "attachPic") {
                showTempAttach();
                setTimeout(function () {
                    if (attachNameTemp == null || attachNameTemp == "") {
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
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        valuesManager: "vm",
        numCols: 6,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personality.workJob",
                title: "<spring:message code='job'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                width: "*"
            },
            {
                name: "personality.workName",
                title: "<spring:message code='work.place'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30",
                width: "*"
            },
            {
                name: "personality.contactInfo.workAddress.webSite",
                title: "<spring:message code='website'/>",
                type: 'text',
                length: "30",
                width: "*"
            },

            {
                name: "personality.contactInfo.workAddress.stateId",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                width: "*",
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_Work_State_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.workAddress.cityId",
                title: "<spring:message code='city'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                width: "*",
                valueField: "id",
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.workAddress.otherCountry",
                title: "<spring:message code='other.counteries'/>",
                editorType: "CheckboxItem",
                showUnsetImage: false,
                width: "*",
                showValueIconDisabled: true,
                showValueIconOver: true,
                showValueIconDown: true,
                showValueIconFocused: true
            },
            {
                name: "personality.contactInfo.workAddress.restAddr",
                title: "<spring:message code='address.rest'/>",
                colSpan: 6,
                width: "*",
                length: "255"
            },
            {
                name: "personality.contactInfo.workAddress.phone",
                title: "<spring:message code='telephone'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[0-9]",
                length: "11"
            },


            {
                name: "personality.contactInfo.workAddress.fax",
                title: "<spring:message code='telefax'/>",
                width: "*",
                type: 'text'
            },
            {
                name: "personality.contactInfo.workAddress.postCode",
                title: "<spring:message code='postal.code'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[0-9]",
                length: "15"
            },
        ],
        itemChanged: function (item, newValue) {
            if (item.name == "personality.contactInfo.workAddress.stateId") {
                if (newValue == undefined) {
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                } else {
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                    RestDataSource_Work_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").optionDataSource = RestDataSource_Work_City_JspTeacher;
                    DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").fetchData();
                }
            }
            if (item.name == "personality.contactInfo.workAddress.otherCountry") {
                if (newValue == true) {
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.stateId");
                } else {
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
                    DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.stateId");
                }
            }
        }

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
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personality.accountInfo.bank",
                title: "<spring:message code='bank'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "personality.accountInfo.bBranch",
                title: "<spring:message code='bank.branch'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "personality.accountInfo.bCode",
                title: "<spring:message code='bank.branch.code'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },


            {
                name: "personality.accountInfo.accountNumber",
                title: "<spring:message code='account.number'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },


            {
                name: "personality.accountInfo.cartNumber",
                title: "<spring:message code='cart.number'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },


            {
                name: "personality.accountInfo.shabaNumber",
                title: "<spring:message code='shaba.number'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            }
        ]
    });

    var DynamicForm_AddressInfo_JspTeacher = isc.DynamicForm.create({
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
        titleAlign: "left",
        numCols: 6,
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personality.contactInfo.homeAddress.stateId",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_Home_State_JspTeacher,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.homeAddress.cityId",
                title: "<spring:message code='city'/>",
                width: "*",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "personality.contactInfo.homeAddress.otherCountry",
                title: "<spring:message code='other.counteries'/>",
                editorType: "CheckboxItem",
                showUnsetImage: false,
                showValueIconDisabled: true,
                showValueIconOver: true,
                showValueIconDown: true,
                showValueIconFocused: true,
            },
            {
                name: "personality.contactInfo.homeAddress.restAddr",
                title: "<spring:message code='address.rest'/>",
                width: "*",
                colSpan: 6,
                length: "255"
            },
            {
                name: "personality.contactInfo.homeAddress.phone",
                title: "<spring:message code='telephone'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[0-9]",
                length: "11"
            },


            {
                name: "personality.contactInfo.homeAddress.fax",
                title: "<spring:message code='telefax'/>",
                width: "*",
                type: 'text'
            },

            {
                name: "personality.contactInfo.homeAddress.postCode",
                title: "<spring:message code='postal.code'/>",
                type: 'text',
                width: "*",
                keyPressFilter: "[0-9]",
                length: "15"
            },

        ],
        itemChanged: function (item, newValue) {
            if (item.name == "personality.contactInfo.homeAddress.stateId") {
                if (newValue == undefined) {
                    DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                } else {
                    // DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                    // RestDataSource_Home_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    // DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").optionDataSource = RestDataSource_Home_City_JspTeacher;
                    // // DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").fetchData();
                }
            }
            if (item.name == "personality.contactInfo.homeAddress.otherCountry") {
                if (newValue == true) {
                    DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                    DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.stateId")
                } else {
                    DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
                    DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.stateId");
                }
            }
        }
    });

    var IButton_Teacher_Save_JspTeacher = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        icon: "pieces/16/save.png",
        click: function () {
            if (codeMeliCheck == false || cellPhoneCheck == false || mailCheck == false || persianDateCheck == false) {
                return;
            }
            vm.validate();
            if (vm.hasErrors()) {
                return;
            }
            var nCode = DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").getValue();
            DynamicForm_BasicInfo_JspTeacher.getField("teacherCode").setValue(nCode);
            var data = vm.getValues();
            var teacherSaveUrl = teacherUrl;
            if (teacherMethod.localeCompare("PUT") == 0) {
                var teacherRecord = ListGrid_Teacher_JspTeacher.getSelectedRecord();
                teacherSaveUrl += teacherRecord.id;
            }
            isc.RPCManager.sendRequest(MyDsRequest(teacherSaveUrl, teacherMethod, JSON.stringify(data), "callback: teacher_action_result(rpcResponse)"));
        }
    });

var IButton_Teacher_Exit_JspTeacher = isc.IButton.create({
    title: "<spring:message code='cancel'/>",
        icon: "pieces/16/icon_delete.png",
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
        height: "250",
        tabs: [
            {
                title: "<spring:message code='basic.information'/>", canClose: false,
                pane: DynamicForm_BasicInfo_JspTeacher
            }
        ]
    });

    var TabSet_JobInfo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "160",
        tabs: [
            {
                title: "<spring:message code='work.place'/>", canClose: false,
                pane: DynamicForm_JobInfo_JspTeacher
            }
        ]
    });

    var TabSet_AccountInfo_JspTeacher = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "120",
        tabs: [
            {
                title: "<spring:message code='account.information'/>", canClose: false,
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
                title: "<spring:message code='home.place'/>", canClose: false,
                pane: DynamicForm_AddressInfo_JspTeacher
            }
        ]
    });

    var VLayOut_Photo_JspTeacher = isc.VLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        defaultLayoutAlign: "center",
        padding: 10,
        membersMargin: 10,
        height: "150",
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
                title: "<spring:message code='personality.photo'/>", canClose: false,
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
        members: [TabSet_Photo_JspTeacher, VLayOut_Temp_JspTeacher]
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
        dismissOnEscape: true,
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
            ListGrid_teacher_print("pdf");
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

    function showTeacherCategories(value) {
        teacherCategoriesID.add(value.id);
    };

    function ListGrid_teacher_edit() {
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
            showAttach(ListGrid_Teacher_JspTeacher.getSelectedRecord().personalityId);
            vm.clearValues();
            vm.clearErrors(true);
            DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.mobile", true);
            DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
            DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);

            DynamicForm_BasicInfo_JspTeacher.getItem("personality.educationOrientationId").setOptionDataSource(null);
            DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").setOptionDataSource(null);
            DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").setOptionDataSource(null);

            teacherMethod = "PUT";
            vm.editRecord(record);

            var eduMajorValue = record.personality.educationMajorId;
            var eduOrientationValue = record.personality.educationOrientationId;
            if (eduOrientationValue == undefined && eduMajorValue == undefined) {
                DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
            } else if (eduMajorValue != undefined) {
                RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = educationUrl + "major/spec-list-by-majorId/" + eduMajorValue;
                DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").optionDataSource = RestDataSource_Education_Orientation_JspTeacher;
                DynamicForm_BasicInfo_JspTeacher.getField("personality.educationOrientationId").fetchData();
            }

            var stateValue_home = undefined;
            var cityValue_home = undefined;
            var stateValue_work = undefined;
            var cityValue_work = undefined;

            if (record.personality.contactInfo != null && record.personality.contactInfo.homeAddress != null && record.personality.contactInfo.homeAddress.stateId != null)
                stateValue_home = record.personality.contactInfo.homeAddress.stateId;
            if (record.personality.contactInfo != null && record.personality.contactInfo.homeAddress != null && record.personality.contactInfo.homeAddress.cityId != null)
                cityValue_home = record.personality.contactInfo.homeAddress.cityId;
            if (cityValue_home == undefined) {
                DynamicForm_AddressInfo_JspTeacher.clearValue("personality.contactInfo.homeAddress.cityId");
            }
            if (stateValue_home != undefined) {
                RestDataSource_Home_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue_home;
                DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").optionDataSource = RestDataSource_Home_City_JspTeacher;
                DynamicForm_AddressInfo_JspTeacher.getField("personality.contactInfo.homeAddress.cityId").fetchData();
            }

            if (record.personality.contactInfo != null && record.personality.contactInfo.workAddress != null && record.personality.contactInfo.workAddress.stateId != null)
                stateValue_work = record.personality.contactInfo.workAddress.stateId;
            if (record.personality.contactInfo != null && record.personality.contactInfo.workAddress != null && record.personality.contactInfo.workAddress.cityId != null)
                cityValue_work = record.personality.contactInfo.workAddress.cityId;
            if (cityValue_work == undefined) {
                DynamicForm_JobInfo_JspTeacher.clearValue("personality.contactInfo.workAddress.cityId");
            }
            if (stateValue_work != undefined) {
                RestDataSource_Work_City_JspTeacher.fetchDataURL = stateUrl + "spec-list-by-stateId/" + stateValue_work;
                DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").optionDataSource = RestDataSource_Work_City_JspTeacher;
                DynamicForm_JobInfo_JspTeacher.getField("personality.contactInfo.workAddress.cityId").fetchData();
            }
            DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").disabled = true;
            showCategories();
            Window_Teacher_JspTeacher.show();
            Window_Teacher_JspTeacher.bringToFront();
        }
    };

    function ListGrid_teacher_add() {
        vm.clearValues();
        vm.clearErrors(true);
        showAttachViewLoader.show();
        showAttachViewLoader.setView();
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.mobile", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.contactInfo.email", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);

        DynamicForm_BasicInfo_JspTeacher.getItem("personality.educationOrientationId").setOptionDataSource(null);
        DynamicForm_JobInfo_JspTeacher.getItem("personality.contactInfo.workAddress.cityId").setOptionDataSource(null);
        ;
        DynamicForm_AddressInfo_JspTeacher.getItem("personality.contactInfo.homeAddress.cityId").setOptionDataSource(null);

        teacherMethod = "POST";
        vm.clearValues();
        DynamicForm_BasicInfo_JspTeacher.clearValue("personality.educationOrientationId");
        DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").disabled = false;
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
                        teacherWait = isc.Dialog.create({
                            message: "<spring:message code='msg.waiting'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='message'/>"
                        });

                        isc.RPCManager.sendRequest(MyDsRequest(teacherUrl + record.id, "DELETE", null, "callback: teacher_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    };

    function ListGrid_teacher_print(type) {
        var advancedCriteria = ListGrid_Teacher_JspTeacher.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/teacher/printWithCriteria/"/>" + type,
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

    function addCategories(teacherId, categoryIds) {
        var JSONObj = {"ids": categoryIds};
        isc.RPCManager.sendRequest(MyDsRequest(teacherUrl + "addCategories/" + teacherId, "POST", JSON.stringify(JSONObj), "callback: teacher_addCategories_result(rpcResponse)"));

    };

    function addAttach(personalId) {
        var formData1 = new FormData();
        var fileBrowserId = document.getElementById(window.attachPic.uploadItem.getElement().id);
        var file = fileBrowserId.files[0];
        formData1.append("file", file);

        if (file != undefined) {
            TrnXmlHttpRequest(formData1, personalInfoUrl + "addAttach/" + personalId, "POST", personalInfo_addAttach_result);
        }

    };

    function personalInfo_addAttach_result(req) {
        attachName = req.response;
    }


    function showTempAttach() {
        var formData1 = new FormData();
        var fileBrowserId = document.getElementById(window.attachPic.uploadItem.getElement().id);
        var file = fileBrowserId.files[0];
        formData1.append("file", file);
        if (file != undefined) {
            TrnXmlHttpRequest(formData1, personalInfoUrl + "addTempAttach", "POST", personalInfo_showTempAttach_result);
        }
    };

    function personalInfo_showTempAttach_result(req) {
        attachNameTemp = req.response;
        showAttachViewLoader.setViewURL("<spring:url value="/personalInfo/getTempAttach/"/>" + attachNameTemp);
        showAttachViewLoader.show();
    }

    function showCategories() {
        teacherId = ListGrid_Teacher_JspTeacher.getSelectedRecord().id;
        isc.RPCManager.sendRequest(MyDsRequest(teacherUrl + "getCategories/" + teacherId, "POST", null, "callback: teacher_getCategories_result(rpcResponse)"));
    };

    function teacher_delete_result(resp) {
        teacherWait.close();
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
        } else if (resp.data == false) {
            var ERROR = isc.Dialog.create({
                message: "<spring:message code='msg.teacher.remove.error'/>",
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

    function teacher_action_result(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            if (resp.data == "") {
                var ERROR = isc.Dialog.create({
                    message: ("<spring:message code='msg.national.code.dublicate'/>"),
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 3000);
            } else {
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
                if (DynamicForm_Photo_JspTeacher.getField("attachPic").getValue() != undefined)
                    addAttach(JSON.parse(resp.data).personalityId);
                setTimeout(function () {
                    if (categoryList != undefined)
                        addCategories(responseID, categoryList);
                }, 300);
                showAttachViewLoader.hide();
                ListGrid_Teacher_JspTeacher.invalidateCache();
                ListGrid_Teacher_JspTeacher.fetchData();
                Window_Teacher_JspTeacher.close();
            }
        } else {
            var ERROR = isc.Dialog.create({
                message: ("<spring:message code='error'/>"),
                icon: "[SKIN]stop.png",
                title: "<spring:message code='message'/>"
            });
            setTimeout(function () {
                ERROR.close();
            }, 3000);
        }
    };

    function teacher_addCategories_result(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
        } else {
            isc.say("<spring:message code='error'/>");
        }
    };


    function teacher_getCategories_result(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            DynamicForm_BasicInfo_JspTeacher.getField("categoryList").setValue(JSON.parse(resp.data));
        } else {
            isc.say("<spring:message code='error'/>");
        }
    };


    function checkCodeMeli(code) {
        if (code == "undefined" && code == null && code == "")
            return false;
        var L = code.length;

        if (L < 8 || parseFloat(code, 10) == 0) return false;
        code = ('0000' + code).substr(L + 4 - 10);
        if (parseFloat(code.substr(3, 6), 10) == 0) return false;
        var c = parseFloat(code.substr(9, 1), 10);
        var s = 0;
        for (var i = 0; i < 9; i++)
            s += parseFloat(code.substr(i, 1), 10) * (10 - i);
        s = s % 11;
        return (s < 2 && c == s) || (s >= 2 && c == (11 - s));
        return true;
    };

    function checkEmail(email) {
        if (email.indexOf("@") == -1 || email.indexOf(".") == -1 || email.lastIndexOf(".") < email.indexOf("@"))
            return false;
        else
            return true;
    };

    function checkMobile(mobile) {
        if (mobile[0] == "0" && mobile[1] == "9")
            return true;
        else
            return false;
    };

    function fillPersonalInfoFiels(nationalCode) {
        isc.RPCManager.sendRequest(MyDsRequest(personalInfoUrl + "getOneByNationalCode/" + nationalCode, "GET", null, "callback: personalInfo_findOne_result(rpcResponse)"));
    };

    function showAttach(pId) {
        selectedRecordPersonalID = pId;
        isc.RPCManager.sendRequest(MyDsRequest(personalInfoUrl + "checkAttach/" + selectedRecordPersonalID, "GET", null, "callback: personalInfo_checkAttach_result(rpcResponse)"));
    };

    function personalInfo_checkAttach_result(resp) {
        if (resp.data == "true") {
            showAttachViewLoader.setViewURL("<spring:url value="/personalInfo/getAttach/"/>" + selectedRecordPersonalID);
            showAttachViewLoader.show();
        } else if (resp.data == "false") {
            showAttachViewLoader.setView();
            showAttachViewLoader.show();
        }
    };

    function personalInfo_findOne_result(resp) {
        if (resp != null && resp != undefined && resp.data!="") {
            var personality = JSON.parse(resp.data);
            showAttach(personality.id);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.firstNameFa", personality.firstNameFa);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.lastNameFa", personality.lastNameFa);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.fullNameEn", personality.fullNameEn);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.firstNameFa", personality.firstNameFa);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.fatherName", personality.fatherName);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthDate", personality.birthDate);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthLocation", personality.birthLocation);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthCertificate", personality.birthCertificate);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.birthCertificateLocation", personality.birthCertificateLocation);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.religion", personality.religion);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.nationality", personality.nationality);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.description", personality.description);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.egenderId", personality.egenderId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.eMarriedId", personality.eMarriedId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.eMilitaryId", personality.eMilitaryId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.educationLevelId", personality.educationLevelId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.educationMajorId", personality.educationMajorId);
            DynamicForm_BasicInfo_JspTeacher.setValue("personality.educationOrientationId", personality.educationOrientationId);
            DynamicForm_JobInfo_JspTeacher.setValue("personality.workName", personality.workName);
            DynamicForm_JobInfo_JspTeacher.setValue("personality.workJob", personality.workJob);

            if (personality.contactInfo != null && personality.contactInfo != undefined) {
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.contactInfo.email", personality.contactInfo.email);
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.contactInfo.mobile", personality.contactInfo.mobile);
                DynamicForm_BasicInfo_JspTeacher.setValue("personality.contactInfo.personalWebSite", personality.contactInfo.personalWebSite);

                if (personality.contactInfo.workAddress != null && personality.contactInfo.workAddress != undefined) {
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.restAddr", personality.contactInfo.workAddress.restAddr);
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.postCode", personality.contactInfo.workAddress.postCode);
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.phone", personality.contactInfo.workAddress.phone);
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.fax", personality.contactInfo.workAddress.fax);
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.webSite", personality.contactInfo.workAddress.webSite);
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.cityId", personality.contactInfo.workAddress.cityId);
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.stateId", personality.contactInfo.workAddress.stateId);
                    DynamicForm_JobInfo_JspTeacher.setValue("personality.contactInfo.workAddress.otherCountry", personality.contactInfo.workAddress.otherCountry);
                }
                if (personality.contactInfo.homeAddress != null && personality.contactInfo.homeAddress != undefined) {
                    DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.stateId", personality.contactInfo.homeAddress.stateId);
                    DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.restAddr", personality.contactInfo.homeAddress.restAddr);
                    DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.postCode", personality.contactInfo.homeAddress.postCode);
                    DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.phone", personality.contactInfo.homekAdress.phone);
                    DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.fax", personality.contactInfo.homeAddress.fax);
                    DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.cityId", personality.contactInfo.homeAddress.cityId);
                    DynamicForm_AddressInfo_JspTeacher.setValue("personality.contactInfo.homeAddress.otherCountry", personality.contactInfo.homeAddress.otherCountry);
                }
            }
            if (personality.accountInfo != null && personality.accountInfo != undefined) {
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.accountNumber", personality.accountInfo.accountNumber);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.bank", personality.accountInfo.bank);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.bBranch", personality.accountInfo.bBranch);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.bCode", personality.accountInfo.bCode);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.cartNumber", personality.accountInfo.cartNumber);
                DynamicForm_AccountInfo_JspTeacher.setValue("personality.accountInfo.shabaNumber", personality.accountInfo.shabaNumber);
            }
        }
    };



