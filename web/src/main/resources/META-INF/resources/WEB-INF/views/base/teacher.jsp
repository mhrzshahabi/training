<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var method = "POST";

    var responseID;
    var categoryList;
    var gridState;
    var attachName;
    var attachNameTemp;

    var codeMeliCheck = true;
    var cellPhoneCheck = true;
    var mailCheck = true;
    var persianDateCheck = true;

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
            {name: "fullNameFa"},
            {name: "educationLevel.titleFa"},
            {name: "educationMajor.titleFa"},
            {name: "educationMajorId"},
            {name: "educationOrientationId"},
            {name: "mobile"},
            {name: "attachPhoto"},
            {name: "categories"}
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
        fetchDataURL:  categoryUrl + "spec-list"
    });

    var RestDataSource_Education_Level_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ],
        fetchDataURL: educationLevelUrl + "spec-list"
    });

    var RestDataSource_Education_Major_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ],
        fetchDataURL:  educationMajorUrl + "spec-list"
    });

    var RestDataSource_Education_Orientation_JspTeacher = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleEn"},
            {name: "titleFa"}
        ],
        fetchDataURL: educationOrientationUrl + "spec-list"
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
                var advancedCriteria = ListGrid_Teacher_JspTeacher.getCriteria();
                var criteriaForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/teacher/printWithCriteria/pdf",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"}
                        ]
                });
                criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
                criteriaForm.submitForm();
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "icon/excel.png", click: function () {
                var advancedCriteria = ListGrid_Teacher_JspTeacher.getCriteria();
                var criteriaForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/teacher/printWithCriteria/excel",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"}
                        ]
                });
                criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
                criteriaForm.submitForm();
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "icon/html.jpg", click: function () {
                var advancedCriteria = ListGrid_Teacher_JspTeacher.getCriteria();
                var criteriaForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/teacher/printWithCriteria/html",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"}
                        ]
                });
                criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
                criteriaForm.submitForm();
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
                name: "fullNameFa",
                title: "<spring:message code='firstName'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "educationLevel.titleFa",
                title: "<spring:message code='education.level'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "educationMajor.titleFa",
                title: "<spring:message code='education.major'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "mobile",
                title: "<spring:message code='mobile.connection'/>",
                align: "center",
                filterOperator: "contains"
            },
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
                title: "<spring:message code='teacher.code'/>",
                type: 'text',
                disabled: true
            },

            {
                name: "fullNameFa",
                title: "<spring:message code='firstName.lastName'/>",
                type: 'text',
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true
            },

            {
                name: "fullNameEn",
                title: "<spring:message code='firstName.latin'/>",
                type: 'text',
                required: true,
                keyPressFilter: "[a-z|A-Z |]",
                hint: "English/انگليسي",
                showHintInField: true
            },

            {
                name: "nationalCode",
                title: "<spring:message code='national.code'/>",
                type: 'text',
                required: true,
                wrapTitle: false,
                keyPressFilter: "[0-9]",
                length: "10",
                hint: "<spring:message code='msg.national.code.hint'/>",
                showHintInField: true
                , blur: function () {
                    var codeCheck = false;
                    codeCheck = checkCodeMeli(DynamicForm_BasicInfo_JspTeacher.getValue("nationalCode"));
                    codeMeliCheck = codeCheck;
                    if (codeCheck == false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("nationalCode", "<spring:message code='msg.national.code.validation'/>", true);
                    if (codeCheck == true)
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("nationalCode", true);
                }
            },

            {
                name: "fatherName",
                title: "<spring:message code='father.name'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true,
                length: "30"
            },

            {
                name: "egenderId",
                type: "IntegerItem",
                title: "<spring:message code='gender'/>",
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
                name: "birthDate",
                title: "<spring:message code='birth.date'/>",
                ID: "birthDate_jspTeacher",
                type: 'text',
                hint: "YYYY/MM/DD",
                keyPressFilter:"[0-9/]",
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
                    dateCheck = checkBirthDate(DynamicForm_BasicInfo_JspTeacher.getValue("birthDate"));
                    persianDateCheck = dateCheck;
                    if (dateCheck == false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("birthDate", "<spring:message code='msg.correct.date'/>", true);
                    if (dateCheck == true)
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("birthDate", true);
                }
            },

            {
                name: "birthLocation",
                title: "<spring:message code='birth.location'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },


            {
                name: "birthCertificate",
                title: "<spring:message code='birth.certificate'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "15"
            },

            {
                name: "birthCertificateLocation",
                title: "<spring:message code='birth.certificate.location'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },

            {
                name: "religion",
                title: "<spring:message code='religion'/>",
                type: 'text',
                defaultValue: "<spring:message code='islam'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },

            {
                name: "nationality",
                title: "<spring:message code='nationality'/>",
                type: 'text',
                defaultValue: "<spring:message code='persian'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "100"
            },

            {
                name: "emarriedId",
                type: "IntegerItem",
                title: "<spring:message code='married.status'/>",
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
                name: "email",
                title: "<spring:message code='email'/>",
                type: 'text',
                hint: "test@nicico.com",
                showHintInField: true,
                length: "30"
                , blur: function () {
                    var emailCheck = false;
                    emailCheck = checkEmail(DynamicForm_BasicInfo_JspTeacher.getValue("email"));
                    mailCheck = emailCheck;
                    if (emailCheck == false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("email", "<spring:message code='msg.email.validation'/>", true);
                    if (emailCheck == true)
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("email", true);
                }
            },

            {
                name: "educationLevelId",
                title: "<spring:message code='education.level'/>",
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
                name: "educationMajorId",
                title: "<spring:message code='education.major'/>",
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
                name: "educationOrientationId",
                title: "<spring:message code='education.orientation'/>",
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
                name: "emilitaryId",
                type: "IntegerItem",
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
                name: "mobile",
                title: "<spring:message code='cellPhone'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "11",
                hint: "*********09",
                showHintInField: true,
                errorMessage: "<spring:message code='msg.mobile.validation'/>"
                , blur: function () {
                    var mobileCheck = false;
                    mobileCheck = checkMobile(DynamicForm_BasicInfo_JspTeacher.getValue("mobile"));
                    cellPhoneCheck = mobileCheck;
                    if (mobileCheck == false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("mobile", "<spring:message code='msg.mobile.validation'/>", true);

                    if (mobileCheck == true)
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("mobile", true);
                }
            },

            {
                name: "economicalCode",
                title: "<spring:message code='economical.code'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "15",
                stopOnError: true
            },

            {
                name: "economicalRecordNumber",
                title: "<spring:message code='economical.record.number'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "15",
                stopOnError: true
            },

            {
                name: "description",
                title: "<spring:message code='description'/>",
                type: 'textArea',
                length: "500",
                height: 30
            },

            {
                name: "enableStatus",
                title: "<spring:message code='status'/>",
                type: "radioGroup",
                valueMap: {"true": "<spring:message code='enabled'/>", "false": "<spring:message code='disabled'/>"},
                vertical: false,
                defaultValue: "true"
            },

            {
                name: "categoryList",
                type: "selectItem",
                textAlign: "center",
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
                    DynamicForm_BasicInfo_JspTeacher.clearValue("educationOrientationId");
                    RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = "${contextPath}/api/educationMajor/spec-list-by-majorId/" + newValue;
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
                title: "<spring:message code='work.place'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "workPhone",
                title: "<spring:message code='telephone'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "11"
            },

            {
                name: "workPostalCode",
                title: "<spring:message code='postal.code'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "15"
            },

            {
                name: "workJob",
                title: "<spring:message code='job'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "workTeleFax",
                title: "<spring:message code='telefax'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "workAddress",
                title: "<spring:message code='address'/>",
                type: 'textArea',
                height: 30,
                length: "255"
            },

            {
                name: "workWebSite",
                title: "<spring:message code='website'/>",
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
                title: "<spring:message code='account.number'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "bank",
                title: "<spring:message code='bank'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "bankBranch",
                title: "<spring:message code='bank.branch'/>",
                type: 'text',
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "cartNumber",
                title: "<spring:message code='cart.number'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "shabaNumber",
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
                title: "<spring:message code='telephone'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "11"
            },

            {
                name: "homePostalCode",
                title: "<spring:message code='postal.code'/>",
                type: 'text',
                keyPressFilter: "[0-9]",
                length: "15"
            },

            {
                name: "homeAddress",
                title: "<spring:message code='address'/>",
                type: 'textArea',
                height: 30,
                length: "255"
            },

        ]
    });

    var IButton_Teacher_Save_JspTeacher = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        icon: "pieces/16/save.png",
        click: function () {

            if (codeMeliCheck == false || cellPhoneCheck == false || mailCheck == false || persianDateCheck == false)
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
                        if (resp.data == "") {
                            var ERROR = isc.Dialog.create({
                                message: ("<spring:message code='msg.national.code.dublicate'/>"),
                                icon: "[SKIN]stop.png",
                                title: "<spring:message code='message'/>"
                            });
                            setTimeout(function () {
                                ERROR.close();
                            }, 3000);
                        }
                        else {
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
                                addAttach(responseID);
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

                }
            });

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
        height: "300",
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
        height: "150",
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
        height: "150",
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
            var advancedCriteria = ListGrid_Teacher_JspTeacher.getCriteria();
            var criteriaForm = isc.DynamicForm.create({
                method: "POST",
                action: "/teacher/printWithCriteria/pdf",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "CriteriaStr", type: "hidden"}
                    ]
            });
            criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
            criteriaForm.submitForm();
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
            showAttach();
            vm.clearValues();
            vm.clearErrors(true);
            DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("mobile", true);
            DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("email", true);
            DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("nationalCode", true);
            method = "PUT";
            url = "${contextPath}/api/teacher/" + record.id;
            vm.editRecord(record);
            var eduMajorValue = record.educationMajorId;

            var eduOrientationValue = record.educationOrientationId;
            if (eduOrientationValue == undefined && eduMajorValue == undefined) {
                DynamicForm_BasicInfo_JspTeacher.clearValue("educationOrientationId");
                DynamicForm_BasicInfo_JspTeacher.getField("educationOrientationId").disabled = true;
            }
            else if (eduMajorValue != undefined) {
                RestDataSource_Education_Orientation_JspTeacher.fetchDataURL = "${contextPath}/api/educationMajor/spec-list-by-majorId/" + eduMajorValue;
                DynamicForm_BasicInfo_JspTeacher.getField("educationOrientationId").fetchData();
                DynamicForm_BasicInfo_JspTeacher.getField("educationOrientationId").disabled = false;
            }
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
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("mobile", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("email", true);
        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("nationalCode", true);
        method = "POST";
        url = "${contextPath}/api/teacher";
        vm.clearValues();
        DynamicForm_BasicInfo_JspTeacher.clearValue("educationOrientationId");
        DynamicForm_BasicInfo_JspTeacher.getField("educationOrientationId").disabled = true;
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
                            actionURL: "${contextPath}/api/teacher/" + record.id,
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
                                else if (resp.data == false) {
                                    var ERROR = isc.Dialog.create({
                                        message: "<spring:message code='msg.teacher.remove.error'/>",
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
            actionURL: "${contextPath}/api/teacher/addCategories/" + teacherId,
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
            request.open("POST", "${contextPath}/api/teacher/addAttach/" + teacherId);
            request.setRequestHeader("Authorization", "Bearer " + "${cookie['access_token'].getValue()}");
            request.send(formData1);
            request.onreadystatechange = function () {
                attachName = request.response;
                if (request.readyState == XMLHttpRequest.DONE) {
                }
            }
        }
    };

    function showAttach() {
        var selectedRecordID = ListGrid_Teacher_JspTeacher.getSelectedRecord().id;
        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: "${contextPath}/api/teacher/checkAttach/" + selectedRecordID,
            httpMethod: "GET",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.data == "true") {
                    showAttachViewLoader.setViewURL("/teacher/getAttach/" + selectedRecordID + "?Authorization=Bearer " + '${cookie['access_token'].getValue()}');
                    showAttachViewLoader.show();
                } else if (resp.data == "false") {
                    showAttachViewLoader.setView();
                    showAttachViewLoader.show();
                }
            }
        });
    };

    function showCategories() {
        teacherId = ListGrid_Teacher_JspTeacher.getSelectedRecord().id;
        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: "${contextPath}/api/teacher/getCategories/" + teacherId,
            httpMethod: "POST",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    DynamicForm_BasicInfo_JspTeacher.getField("categoryList").setValue(JSON.parse(resp.data));
                } else {
                    isc.say("<spring:message code='error'/>");
                }
            }
        });
    };

    function showTempAttach() {
        var formData1 = new FormData();
        var fileBrowserId = document.getElementById(window.attachPic.uploadItem.getElement().id);
        var file = fileBrowserId.files[0];
        formData1.append("file", file);
        if (file !== undefined) {
            var request = new XMLHttpRequest();
            request.open("POST", "${contextPath}/api/teacher/addTempAttach");
            request.setRequestHeader("Authorization", "Bearer " + "${cookie['access_token'].getValue()}");
            request.send(formData1);
            request.onreadystatechange = function () {
                attachNameTemp = request.response;
                showAttachViewLoader.setViewURL("/teacher/getTempAttach/" + attachNameTemp + "?Authorization=Bearer " + '${cookie['access_token'].getValue()}');
                showAttachViewLoader.show();
            }
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



