<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

    var skill_Method = "GET";
    var skill_MainUrl = "${restApiUrl}/api/";
    var skill_ActionUrl = skill_MainUrl + "skill";
    var skill_SkillUrl = skill_MainUrl + "skill/";
    var skill_SkillGroupUrl = skill_MainUrl + "skill-group/";
    var skill_CompetenceUrl = skill_MainUrl + "competence/";
    var skill_CourseUrl = skill_MainUrl + "course/";
    var skill_CategoryUrl = skill_MainUrl + "category/spec-list";
    var skill_SubCategoryUrl = skill_MainUrl + "sub-category/spec-list";
    var skill_SkillLevelUrl = skill_MainUrl + "skill-level/spec-list";
    var skill_EnumDomainTypeUrl = skill_MainUrl + "enum/eDomainType";
    var skill_selectedSkillId = -1;


    // Start Block Of Combo And List Data Sources ----------------------------------------------------------

    var RestDataSource_Skill_Skill_Level = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "version"}
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: skill_SkillLevelUrl
    });

    var RestDataSource_Skill_Category = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
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
        fetchDataURL: skill_CategoryUrl
    });

    var RestDataSource_Skill_SubCategory = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"},
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
    });

    var RestDataSource_Skill_EDomainType = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
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
        fetchDataURL: skill_EnumDomainTypeUrl
    });

    //End Block Of Combo And List Data Sources ----------------------------------------------------------


    // Start Block Of Main And Detail Data Sources ----------------------------------------------------------

    var RestDataSource_Skill_Skill = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "category.titleFa"},
            {name: "subCategory.titleFa"},
            {name: "skillLevel.titleFa"},
            {name: "edomainType.titleFa"},
            {name: "description"},
            /*{name: "categoryId"},
            {name: "subCategoryId"},
            {name: "skillLevelId"},
            {name: "edomainTypeId"},*/
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
        fetchDataURL: skill_SkillUrl + "spec-list"
    });

    var RestDataSource_Skill_Attached_SkillGroups = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"}
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
// fetchDataURL: "${restApiUrl}/api/skill/-1/skill-groups"
        fetchDataURL: "${restApiUrl}/api/skill/skill-group-dummy"
    });

    var RestDataSource_Skill_UnAttached_SkillGroups = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"}
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/skill/skill-group-dummy"
    });

    var RestDataSource_Skill_Attached_Competences = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "etechnicalType.titleFa"},
            {name: "ecompetenceInputType.titleFa"}

        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/skill/competence-dummy"
// fetchDataURL: "${restApiUrl}/api/skill/-1/competences"
    });

    var RestDataSource_Skill_UnAttached_Competences = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "etechnicalType.titleFa"},
            {name: "ecompetenceInputType.titleFa"}

        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: "${restApiUrl}/api/skill/competence-dummy"
// fetchDataURL: "${restApiUrl}/api/skill/-1/competences"
    });

    var RestDataSource_Skill_Attached_Courses = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "category.titleFa"},
            {name: "subcategory.titleFa"},
            {name: "etechnicalType.titleFa"},
            {name: "erunType.titleFa"},
            {name: "elevelType.titleFa"},
            {name: "etheoType.titleFa"}
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
// fetchDataURL: "${restApiUrl}/api/skill/-1/courses"
        fetchDataURL: "${restApiUrl}/api/skill/course-dummy"
    });

    var RestDataSource_Skill_UnAttached_Courses = isc.RestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "category.titleFa"},
            {name: "subcategory.titleFa"},
            {name: "etechnicalType.titleFa"},
            {name: "erunType.titleFa"},
            {name: "elevelType.titleFa"},
            {name: "etheoType.titleFa"}
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
                "Access-Control-Allow-Origin": "${restApiUrl}"
            };
            return this.Super("transformRequest", arguments);
        },
// fetchDataURL: "${restApiUrl}/api/skill/-1/courses"
        fetchDataURL: "${restApiUrl}/api/skill/course-dummy"
    });

    //End Block Of Main And Detail Data Sources ----------------------------------------------------------


    var DynamicForm_Skill_Skill = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        showInlineErrors: true,
        numCols: "2",
        showErrorText: true,
        showErrorStyle: true,
        errorOrientation: "right",
        titleAlign: "right",
        requiredMessage: "فیلد اجباری است.",
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                title: "کد",
                length: 10,
                type: 'text',
                required: false,
                // editable:false,
                keyPressFilter: "^[A-Z|0-9 ]",
                width: "300"
            },
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                default: "125",
                readonly: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                length: "255",
                width: "300",
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    stopOnError: true,
                    errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
                }]
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                length: "255",
                width: "300",
                validators: [{
                    type: "isString",
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 0,
                    max: 200,
                    stopOnError: true,
                    errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
                }]
            },
            {
                name: "skillLevelId",
                type: "IntegerItem",
                title: "سطح مهارت",
                width: "300",
                required: true,
                textAlign: "center",
                editorType: "ComboBoxItem",
                pickListWidth: 300,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Skill_Skill_Level,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
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
                        title: " عنوان",
                        width: "30%",
                        filterOperator: "iContains"
                    }
                ],
            },
            {
                name: "categoryId",
                title: "گروه",
                width: "300",
                required: true,
                textAlign: "center",
                editorType: "ComboBoxItem",
                pickListWidth: 300,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Skill_Category,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
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
                        width: "30%",
                        filterOperator: "iContains"
                    }
                ],
                changed: function (form, item, value) {
                    if (value == null || value.length == 0) {

                    } else {
                        RestDataSource_Skill_SubCategory.fetchDataURL = "${restApiUrl}/api/category/" + value + "/sub-categories";
                        form.getItem("subCategoryId").fetchData();
                        form.getItem("subCategoryId").setValue([]);
                        form.getItem("subCategoryId").setDisabled(false);
                    }
                }
            },
            {
                name: "subCategoryId",
                title: " زیر گروه",
                width: "300",
                required: true,
                textAlign: "center",
                editorType: "ComboBoxItem",
                pickListWidth: 300,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Skill_SubCategory,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "code",
                        width: "40%",
                        filterOperator: "iContains"
                    },
                    {
                        name: "titleFa",
                        title: " عنوان زیرگروه",
                        width: "60%",
                        filterOperator: "iContains"
                    }
                ],
// changed: function (form, item, value) {
// alert(form.getItem("subCategory.id").getRecord());
// //form.getItem("subCategory.id").fetchData();
// }

            },
            {
                name: "edomainTypeId",
                type: "IntegerItem",
                title: "نوع مهارت",
                width: "300",
                required: true,
                textAlign: "center",
                editorType: "ComboBoxItem",
                pickListWidth: 300,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Skill_EDomainType,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: false,
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
                        width: "30%",
                        filterOperator: "iContains"
                    }
                ],
            },
            {
                name: "description",
                title: "توضيحات",
                length: "500",
                width: "300",
                type: 'text'
            }
        ]
    });

    var IButton_Skill_Skill_Save = isc.IButton.create({
        top: 260, title: "ذخیره",
        click: function () {
            DynamicForm_Skill_Skill.validate();
            if (DynamicForm_Skill_Skill.hasErrors()) {
                return;
            }
            var data = DynamicForm_Skill_Skill.getValues();
            console.log(JSON.stringify(data));

            isc.RPCManager.sendRequest({
                actionURL: skill_ActionUrl,
                httpMethod: skill_Method,
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var OK = isc.Dialog.create({
                            message: "عملیات با موفقیت انجام شد.",
                            icon: "[SKIN]say.png",
                            title: "انجام فرمان"
                        });
                        setTimeout(function () {
                            OK.close();
                        }, 3000);
                        ListGrid_Skill_Skill_refresh();
                        Window_Skill_Skill.close();
                    } else {
                        var ERROR = isc.Dialog.create({
                            message: ("اجرای عملیات با مشکل مواجه شده است!"),
                            icon: "[SKIN]stop.png",
                            title: "پیغام"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 3000);
                    }

                }
            });

        }
    });

    var Hlayout_Skill_Skill_SaveOrExit = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Skill_Skill_Save, isc.IButton.create({
            title: "لغو",
            prompt: "",
            width: 100,
            orientation: "vertical",
            click: function () {
                Window_Skill_Skill.close();
            }
        })]
    });

    var Window_Skill_Skill = isc.Window.create({
        title: "مهارت",
        width: "450",
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Skill_Skill, Hlayout_Skill_Skill_SaveOrExit]
        })]
    });

    //معرفی DataSourse ها و ایجاد امکان نمایش


    var ListGrid_Skill_Attached_SkillGroups = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Skill_Attached_SkillGroups,
// contextMenu: Menu_ListGrid_Skill_Skill,
        doubleClick: function () {
// ListGrid_Skill_Skill_Edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین ", align: "center"}
        ],
        selectionType: "multiple",
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

    var ListGrid_Skill_Attached_Competences = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Skill_Attached_Competences,
// contextMenu: Menu_ListGrid_Skill_Skill,
        doubleClick: function () {
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین ", align: "center"},
            {name: "etechnicalType.titleFa", title: "نوع تخصص", align: "center"},
            {name: "ecompetenceInputType.titleFa", title: "مرجع تعریف", align: "center"}
        ],
        selectionType: "multiple",
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

    var ListGrid_Skill_Attached_Courses = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Skill_Attached_Courses,
// contextMenu: Menu_ListGrid_Skill_Skill,
        doubleClick: function () {
// ListGrid_Skill_Skill_Edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین ", align: "center"},
            {name: "category.titleFa", title: "رسته", align: "center"},
            {name: "subcategory.titleFa", title: "زیر رسته", align: "center"},
            {name: "etechnicalType.titleFa", title: "نوع تخصص", align: "center"},
            {name: "erunType.titleFa", title: "نوع اجرا", align: "center"},
            {name: "elevelType.titleFa", title: "سطح دوره", align: "center"},
            {name: "etheoType.titleFa", title: "نوع دوره", align: "center"}
        ],
        selectionType: "multiple",
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


    var ToolStripButton__Action_Skill_SkillGroups_Select = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        click: function () {
            var record = ListGrid_Skill_Skill.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "هیچ مهارتی انتخاب نشده است.",
                    icon: "[SKIN]ask.png",
                    title: "پیغام",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                Skill_Add_SkillGroup();
            }
        }


    });
    var ToolStripButton__Action_Skill_SkillCompetences_Select = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        click: function () {
            var record = ListGrid_Skill_Skill.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "هیچ مهارتی انتخاب نشده است.",
                    icon: "[SKIN]ask.png",
                    title: "پیغام",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                Skill_Add_Competence();
            }
        }
    });
    var ToolStripButton__Action_Skill_SkillCourses_Select = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        click: function () {
            var record = ListGrid_Skill_Skill.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "هیچ مهارتی انتخاب نشده است.",
                    icon: "[SKIN]ask.png",
                    title: "پیغام",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                Skill_Add_Course();
            }
        }
    });

    var ToolStrip_Action_Skill_SkillGroups = isc.ToolStrip.create({
        width: "100%",
        vertical: true,
        center: true,
        members: [
            ToolStripButton__Action_Skill_SkillGroups_Select
        ]
    });
    var ToolStrip_Action_Skill_SkillCompetences = isc.ToolStrip.create({
        width: "100%",
        vertical: true,
        center: true,
        members: [
            ToolStripButton__Action_Skill_SkillCompetences_Select]
    });
    var ToolStrip_Action_Skill_SkillCourses = isc.ToolStrip.create({
        width: "100%",
        vertical: true,
        center: true,
        members: [
            ToolStripButton__Action_Skill_SkillCourses_Select
        ]
    });


    // بخش مر بوط به معرفی Skill


    function ListGrid_Skill_Skill_Remove() {


        var record = ListGrid_Skill_Skill.getSelectedRecord();
        console.log(record);
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
                            actionURL: skill_ActionUrl + "/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                console.log(resp.httpResponseCode);
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Skill_Skill.invalidateCache();
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

    function ListGrid_Skill_Skill_Edit() {
        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "هیچ مهارتی برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "پیغام",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            console.log('record:' + JSON.stringify(record));
            var id = record.categoryId;
            DynamicForm_Skill_Skill.clearValues();
            RestDataSource_Skill_SubCategory.fetchDataURL = "${restApiUrl}/api/category/" + id + "/sub-categories";
            DynamicForm_Skill_Skill.getItem("subCategoryId").fetchData();
            skill_Method = "PUT";
            skill_ActionUrl = skill_SkillUrl + record.id;
            DynamicForm_Skill_Skill.editRecord(record);
            Window_Skill_Skill.show();

        }
    };

    function ListGrid_Skill_Skill_refresh() {
        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_Skill_Skill.selectRecord(record);
        }
        skill_selectedSkillId = -1;
        RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = "${restApiUrl}/api/skill/skill-group-dummy";
        RestDataSource_Skill_Attached_Competences.fetchDataURL = "${restApiUrl}/api/skill/competence-dummy";
        RestDataSource_Skill_Attached_Courses.fetchDataURL = "${restApiUrl}/api/skill/course-dummy";
        ListGrid_Skill_Skill.invalidateCache();
        ListGrid_Skill_Attached_SkillGroups.invalidateCache();
        ListGrid_Skill_Attached_Competences.invalidateCache();
        ListGrid_Skill_Attached_Courses.invalidateCache();
    };

    var Menu_ListGrid_Skill_Skill = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Skill_Skill_refresh();
            }
        }, {
            title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
                skill_Method = "POST";
                skill_ActionUrl = "${restApiUrl}/api/skill";
                DynamicForm_Skill_Skill.clearValues();
                Window_Skill_Skill.show();
            }
        }, {
            title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {

                ListGrid_Skill_Skill_Edit();

            }
        }, {
            title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_Skill_Skill_Remove();
            }
        }, {isSeparator: true}, {
            title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {
                "<spring:url value="/skill/print/pdf" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
                "<spring:url value="/skill/print/excel" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
                "<spring:url value="/skill/print/html" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }]
    });

    var ListGrid_Skill_Skill = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Skill_Skill,
        contextMenu: Menu_ListGrid_Skill_Skill,
        doubleClick: function () {
            ListGrid_Skill_Skill_Edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد", align: "center"},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین ", align: "center"},
            {name: "skillLevel.titleFa", title: "سطح مهارت", align: "center"},
            {name: "edomainType.titleFa", title: "نوع مهارت", align: "center"},
            {name: "category.titleFa", title: "رسته", align: "center"},
            {name: "subCategory.titleFa", title: "زیر رسته", align: "center"},
            {name: "description", title: "توضیحات", align: "center", hidden: true}
        ],
        selectionType: "single",
        selectionChanged: function (record, state) {
            if (record == null) {
                skill_selectedSkillId = -1;
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = "${restApiUrl}/api/skill/skill-group-dummy";
                RestDataSource_Skill_Attached_Competences.fetchDataURL = "${restApiUrl}/api/skill/competence-dummy";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = "${restApiUrl}/api/skill/course-dummy";
            } else {
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/skill-groups";
                RestDataSource_Skill_Attached_Competences.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/competences";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/courses";
                selectedSkillId = record.id;
// // RestDataSource_Skill_Attached_SkillGroup.fetchData();

            }
            ListGrid_Skill_Attached_SkillGroups.invalidateCache();
            ListGrid_Skill_Attached_Competences.invalidateCache();
            ListGrid_Skill_Attached_Courses.invalidateCache();
// ListGrid_Skill_Attached_Competences.fetchData();
// ListGrid_Skill_Attached_Courses.fetchData();
        },
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

    var ToolStripButton_Skill_Skill_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "بازخوانی اطلاعات",
        click: function () {
            ListGrid_Skill_Skill_refresh();
        }
    });
    var ToolStripButton_Skill_Skill_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {
            ListGrid_Skill_Skill_Edit();
        }
    });
    var ToolStripButton_Skill_Skill_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {
            skill_Method = "POST";
            skill_ActionUrl = "${restApiUrl}/api/skill";
            DynamicForm_Skill_Skill.clearValues();
            Window_Skill_Skill.show();
        }
    });
    var ToolStripButton_Skill_Skill_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            ListGrid_Skill_Skill_Remove();
        }
    });
    var ToolStripButton_Skill_Skill_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "چاپ",
        click: function () {
            "<spring:url value="/skill/print/pdf" var="printUrl"/>"
            window.open('${printUrl}');
        }
    });
    var ToolStrip_Actions_Skill_Skill = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Skill_Skill_Refresh,
            ToolStripButton_Skill_Skill_Add,
            ToolStripButton_Skill_Skill_Edit,
            ToolStripButton_Skill_Skill_Remove,
            ToolStripButton_Skill_Skill_Print
        ]
    });


    // Start Block Add Skill Groups To Skill ---------------------------------------------------------------

    var DynamicForm_Skill_SkillData_Add_SkillGroup = isc.DynamicForm.create({
        titleWidth: 400,
        width: "100%",
        align: "right",
        numCols: "6",
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                title: "کد",
                type: 'staticText',
                width: "100"
            },
            {
                name: "titleFa",
                title: "نام فارسی",
                type: 'staticText',
                length: "200",
                width: "150"
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'staticText',
                length: "200",
                width: "150"
            },
        ]
    });

    var ListGrid_Skill_UnAttached_SkillGroup = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        dragTrackerMode: "none",
        dataSource: RestDataSource_Skill_UnAttached_SkillGroups,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        border: "0px solid green",
        showConnectors: true,
        canDragRecordsOut: true,
        closedIconSuffix: "",
        openIconSuffix: "",
        selectedIconSuffix: "",
        dropIconSuffix: "",
        showOpenIcons: false,
        showDropIcons: false,
        selectionType: "multiple",
        canDragSelect: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"}
        ],
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            var skillGroupIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                skillGroupIds.add(dropRecords[i].id);
            }
            // var JSONObj = {"ids": skillGroupIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/skill/remove-skill-group-list/" + skillGroupIds + "/" + skillId,
                httpMethod: "DELETE",
                //  data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                        ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },

        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
            var skillGroupRecord = record;
            var skillGroupId = skillGroupRecord.id;
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/skill/add-skill-group/" + skillGroupId + "/" + skillId,
                httpMethod: "POST",
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                        ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },
        sortField: 0,
        dataPageSize: 50,
    });

    var ListGrid_Skill_Selected_SkillGroup = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        //autoDraw: false,
        canDragRecordsOut: true,
        dragTrackerMode: "none",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Skill_Attached_SkillGroups,
        canDragSelect: true,
        autoFetchData: false,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        canEdit: false,
        //editEvent: "click",
        //editByCell: true,
        //rowEndEditAction: "done",
        //listEndEditAction: "next",
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"},
            {name: "OnDelete", title: "حذف", align: "center"}

        ],
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            var skillGroupIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                skillGroupIds.add(dropRecords[i].id);
            }
            var JSONObj = {"ids": skillGroupIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/skill/add-skill-group-list/" + skillId,
                httpMethod: "POST",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                        ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },

        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName == "OnDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 22,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });

                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "pieces/16/icon_delete.png",
                    prompt: "<spring:message code='global.form.remove'/>",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {

                        var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                        var skillId = skillRecord.id;
                        var skillGroupRecord = record;
                        var skillGroupId = skillGroupRecord.id;

                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL: "${restApiUrl}/api/skill/remove-skill-group/" + skillGroupId + "/" + skillId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                    ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                                    ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                                } else {
                                    isc.say("<spring:message code='error'/>");
                                }
                            }
                        });
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },
        dataPageSize: 50
    });

    var SectionStack_Skill_UnAttached_SkillGroup = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "گروه مهارتهای انتخاب نشده",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_UnAttached_SkillGroup
                ]
            }
        ]
    });

    var SectionStack_Skill_Attached_SkillGroup = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "گروه مهارتهای انتخاب شده",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_Selected_SkillGroup
                ]
            }
        ]
    });

    var HStack_Skill_AddSkillGroup = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_Skill_UnAttached_SkillGroup,
            SectionStack_Skill_Attached_SkillGroup
        ]
    });

    var HLayOut_Skill_AddSkillGroup_Header = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_Skill_SkillData_Add_SkillGroup
        ]
    });

    var VLayOut_Skill_SkillGroup_Add_Main = isc.VLayout.create({
        width: "100%",
        height: 400,
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_Skill_AddSkillGroup_Header,
            HStack_Skill_AddSkillGroup
        ]
    });

    var Window_Skill_AddSkillGroup = isc.Window.create({
        title: "مرتبط کردن/حذف ارتباط گروه مهارت با مهارت",
        width: 900,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        closeClick: function () {
            this.hide();
            Skill_Finish_SkillGroup();
        },
        items: [
            VLayOut_Skill_SkillGroup_Add_Main
        ]
    });

    function Skill_Add_SkillGroup() {

        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است",
                icon: "<spring:url value='[SKIN]ask.png'/>",
                title: "پیام",
                buttons: [isc.Button.create({title: "تایید"})],
                buttonClick: function () {
                    this.close();
                }
            });
        } else {
            RestDataSource_Skill_UnAttached_SkillGroups.fetchDataURL = skill_SkillUrl + record.id + "/unattached-skill-groups";
            RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillUrl + record.id + "/skill-groups";
            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
            DynamicForm_Skill_SkillData_Add_SkillGroup.invalidateCache();
            DynamicForm_Skill_SkillData_Add_SkillGroup.setValue("titleFa", record.titleFa);
            DynamicForm_Skill_SkillData_Add_SkillGroup.setValue("titleEn", record.titleEn);
            DynamicForm_Skill_SkillData_Add_SkillGroup.setValue("code", record.code);
            ListGrid_Skill_UnAttached_SkillGroup.fetchData();
            ListGrid_Skill_Selected_SkillGroup.fetchData();
            Window_Skill_AddSkillGroup.show();
        }

    };

    function Skill_Finish_SkillGroup() {
        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null) {
            skill_selectedSkillId = -1;
            RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = "${restApiUrl}/api/skill/skill-group-dummy";
        } else {
            RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/skill-groups";
            selectedSkillId = record.id;
// // RestDataSource_Skill_Attached_SkillGroup.fetchData();

        }
        ListGrid_Skill_Attached_SkillGroups.invalidateCache();


    };
    // End Block Add Skill Groups To Skill ---------------------------------------------------------------
    // Start Block Add Competences To Skill ---------------------------------------------------------------

    // Start Block Add Competence To Skill ---------------------------------------------------------------
    var DynamicForm_Skill_SkillData_Add_Competence = isc.DynamicForm.create({
        titleWidth: 400,
        width: 700,
        align: "right",
        numCols: "6",
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                title: "کد",
                type: 'staticText',
                width: "100"
            },
            {
                name: "titleFa",
                title: "نام فارسی",
                type: 'staticText',
                length: "200",
                width: "150"
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'staticText',
                length: "200",
                width: "150"
            },
        ]
    });

    var ListGrid_Skill_UnAttached_Competence = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        dragTrackerMode: "none",
        dataSource: RestDataSource_Skill_UnAttached_Competences,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        border: "0px solid green",
        showConnectors: true,
        canDragRecordsOut: true,
        closedIconSuffix: "",
        openIconSuffix: "",
        selectedIconSuffix: "",
        dropIconSuffix: "",
        showOpenIcons: false,
        showDropIcons: false,
        selectionType: "multiple",
        canDragSelect: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"}
        ],
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            var competenceIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                competenceIds.add(dropRecords[i].id);
            }
// var JSONObj = {"ids": competenceIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/skill/remove-competence-list/" + competenceIds + "/" + skillId,
                httpMethod: "DELETE",
//  data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_Competence.invalidateCache();
                        ListGrid_Skill_UnAttached_Competence.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },

        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
            var competenceRecord = record;
            var competenceId = competenceRecord.id;
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/skill/add-competence/" + competenceId + "/" + skillId,
                httpMethod: "POST",
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_Competence.invalidateCache();
                        ListGrid_Skill_UnAttached_Competence.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },
        sortField: 0,
        dataPageSize: 50,
    });

    var ListGrid_Skill_Selected_Competence = isc.ListGrid.create({
        width: "100%",
        height: "100%",
//autoDraw: false,
        canDragRecordsOut: true,
        dragTrackerMode: "none",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Skill_Attached_Competences,
        canDragSelect: true,
        autoFetchData: false,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        canEdit: false,
//editEvent: "click",
//editByCell: true,
//rowEndEditAction: "done",
//listEndEditAction: "next",
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"},
            {name: "OnDelete", title: "حذف", align: "center"}

        ],
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            var competenceIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                competenceIds.add(dropRecords[i].id);
            }
            var JSONObj = {"ids": competenceIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/skill/add-competence-list/" + skillId,
                httpMethod: "POST",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_Competence.invalidateCache();
                        ListGrid_Skill_UnAttached_Competence.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },

        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName == "OnDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 22,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });

                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "pieces/16/icon_delete.png",
                    prompt: "<spring:message code='global.form.remove'/>",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {

                        var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                        var skillId = skillRecord.id;
                        var competenceRecord = record;
                        var competenceId = competenceRecord.id;

                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL: "${restApiUrl}/api/skill/remove-competence/" + competenceId + "/" + skillId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                    ListGrid_Skill_UnAttached_Competence.invalidateCache();
                                    ListGrid_Skill_Selected_Competence.invalidateCache();
                                } else {
                                    isc.say("<spring:message code='error'/>");
                                }
                            }
                        });
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },
        dataPageSize: 50
    });

    var SectionStack_Skill_UnAttached_Competence = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "شایستگی های انتخاب نشده",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_UnAttached_Competence
                ]
            }
        ]
    });

    var SectionStack_Skill_Attached_Competence = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "شایستگی های انتخاب شده",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_Selected_Competence
                ]
            }
        ]
    });

    var HStack_Skill_AddCompetence = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_Skill_UnAttached_Competence,
            SectionStack_Skill_Attached_Competence
        ]
    });

    var HLayOut_Skill_AddCompetence_Header = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_Skill_SkillData_Add_Competence
        ]
    });

    var VLayOut_Skill_Competence_Add_Main = isc.VLayout.create({
        width: "100%",
        height: 400,
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_Skill_AddCompetence_Header,
            HStack_Skill_AddCompetence
        ]
    });

    var Window_Skill_AddCompetence = isc.Window.create({
        title: "مرتبط کردن/حذف ارتباط شایستگی با مهارت",
        width: 900,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        closeClick: function () {
            this.hide();
            Skill_Finish_Competence();
        },
        items: [
            VLayOut_Skill_Competence_Add_Main
        ]
    });

    function Skill_Add_Competence() {

        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است",
                icon: "<spring:url value='[SKIN]ask.png'/>",
                title: "پیام",
                buttons: [isc.Button.create({title: "تایید"})],
                buttonClick: function () {
                    this.close();
                }
            });
        } else {
            RestDataSource_Skill_UnAttached_Competences.fetchDataURL = skill_SkillUrl + record.id + "/unattached-competences";
            RestDataSource_Skill_Attached_Competences.fetchDataURL = skill_SkillUrl + record.id + "/competences";
            ListGrid_Skill_UnAttached_Competence.invalidateCache();
            ListGrid_Skill_Selected_Competence.invalidateCache();
            DynamicForm_Skill_SkillData_Add_Competence.invalidateCache();

            DynamicForm_Skill_SkillData_Add_Competence.setValue("titleFa", record.titleFa);
            DynamicForm_Skill_SkillData_Add_Competence.setValue("titleEn", record.titeEn);
            DynamicForm_Skill_SkillData_Add_Competence.setValue("id", record.id);
            ListGrid_Skill_UnAttached_Competence.fetchData();
            ListGrid_Skill_Selected_Competence.fetchData();
            Window_Skill_AddCompetence.show();
        }

    };

    function Skill_Finish_Competence() {
        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null) {
            skill_selectedSkillId = -1;
            RestDataSource_Skill_Attached_Competences.fetchDataURL = "${restApiUrl}/api/skill/competence-dummy";
        } else {
            RestDataSource_Skill_Attached_Competences.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/competences";
            selectedSkillId = record.id;
// // RestDataSource_Skill_Attached_SkillGroup.fetchData();

        }
        ListGrid_Skill_Attached_Competences.invalidateCache();


    };


    // End Block Add Competences To Skill ---------------------------------------------------------------
    // Start Block Add Courses To Skill ---------------------------------------------------------------
    // Start Block Add Courses To Skill ---------------------------------------------------------------
    // Start Block Add Course To Skill ---------------------------------------------------------------
    var DynamicForm_Skill_SkillData_Add_Course = isc.DynamicForm.create({
        titleWidth: 400,
        width: 700,
        align: "right",
        numCols: "6",
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                title: "کد",
                type: 'staticText',
                width: "100"
            },
            {
                name: "titleFa",
                title: "نام فارسی",
                type: 'staticText',
                length: "200",
                width: "150"
            },
            {
                name: "titleEn",
                title: "نام لاتین ",
                type: 'staticText',
                length: "200",
                width: "150"
            },
        ]
    });

    var ListGrid_Skill_UnAttached_Course = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        dragTrackerMode: "none",
        dataSource: RestDataSource_Skill_UnAttached_Courses,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        border: "0px solid green",
        showConnectors: true,
        canDragRecordsOut: true,
        closedIconSuffix: "",
        openIconSuffix: "",
        selectedIconSuffix: "",
        dropIconSuffix: "",
        showOpenIcons: false,
        showDropIcons: false,
        selectionType: "multiple",
        canDragSelect: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"}
        ],
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            var courseIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                courseIds.add(dropRecords[i].id);
            }
// var JSONObj = {"ids": courseIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/skill/remove-course-list/" + courseIds + "/" + skillId,
                httpMethod: "DELETE",
//  data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_Course.invalidateCache();
                        ListGrid_Skill_UnAttached_Course.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },

        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
            var courseRecord = record;
            var courseId = courseRecord.id;
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/skill/add-course/" + courseId + "/" + skillId,
                httpMethod: "POST",
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_Course.invalidateCache();
                        ListGrid_Skill_UnAttached_Course.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },
        sortField: 0,
        dataPageSize: 50,
    });

    var ListGrid_Skill_Selected_Course = isc.ListGrid.create({
        width: "100%",
        height: "100%",
//autoDraw: false,
        canDragRecordsOut: true,
        dragTrackerMode: "none",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Skill_Attached_Courses,
        canDragSelect: true,
        autoFetchData: false,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        canEdit: false,
//editEvent: "click",
//editByCell: true,
//rowEndEditAction: "done",
//listEndEditAction: "next",
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"},
            {name: "OnDelete", title: "حذف", align: "center"}

        ],
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
            var skillId = skillRecord.id;
            var courseIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                courseIds.add(dropRecords[i].id);
            }
            var JSONObj = {"ids": courseIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: "${restApiUrl}/api/skill/add-course-list/" + skillId,
                httpMethod: "POST",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        ListGrid_Skill_Selected_Course.invalidateCache();
                        ListGrid_Skill_UnAttached_Course.invalidateCache();
                    } else {
                        isc.say("<spring:message code='error'/>");
                    }
                }
            });
        },

        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName == "OnDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 22,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });

                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "pieces/16/icon_delete.png",
                    prompt: "<spring:message code='global.form.remove'/>",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {

                        var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                        var skillId = skillRecord.id;
                        var courseRecord = record;
                        var courseId = courseRecord.id;

                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL: "${restApiUrl}/api/skill/remove-course/" + courseId + "/" + skillId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                    ListGrid_Skill_UnAttached_Course.invalidateCache();
                                    ListGrid_Skill_Selected_Course.invalidateCache();
                                } else {
                                    isc.say("<spring:message code='error'/>");
                                }
                            }
                        });
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },
        dataPageSize: 50
    });

    var SectionStack_Skill_UnAttached_Course = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "گروه مهارتهای انتخاب نشده",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_UnAttached_Course
                ]
            }
        ]
    });

    var SectionStack_Skill_Attached_Course = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "گروه مهارتهای انتخاب شده",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_Selected_Course
                ]
            }
        ]
    });

    var HStack_Skill_AddCourse = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_Skill_UnAttached_Course,
            SectionStack_Skill_Attached_Course
        ]
    });

    var HLayOut_Skill_AddCourse_Header = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_Skill_SkillData_Add_Course
        ]
    });

    var VLayOut_Skill_Course_Add_Main = isc.VLayout.create({
        width: "100%",
        height: 400,
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_Skill_AddCourse_Header,
            HStack_Skill_AddCourse
        ]
    });

    var Window_Skill_AddCourse = isc.Window.create({
        title: "مرتبط کردن/حذف ارتباط دوره با مهارت",
        width: 900,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        closeClick: function () {
            this.hide();
            Skill_Finish_Course();
        },
        items: [
            VLayOut_Skill_Course_Add_Main
        ]
    });

    function Skill_Add_Course() {

        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "رکوردی انتخاب نشده است",
                icon: "<spring:url value='[SKIN]ask.png'/>",
                title: "پیام",
                buttons: [isc.Button.create({title: "تایید"})],
                buttonClick: function () {
                    this.close();
                }
            });
        } else {
            RestDataSource_Skill_UnAttached_Courses.fetchDataURL = skill_SkillUrl + record.id + "/unattached-courses";
            RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillUrl + record.id + "/courses";
            ListGrid_Skill_UnAttached_Course.invalidateCache();
            ListGrid_Skill_Selected_Course.invalidateCache();
            DynamicForm_Skill_SkillData_Add_Course.invalidateCache();

            DynamicForm_Skill_SkillData_Add_Course.setValue("titleFa", record.titleFa);
            DynamicForm_Skill_SkillData_Add_Course.setValue("titleEn", record.titeEn);
            DynamicForm_Skill_SkillData_Add_Course.setValue("id", record.id);
            ListGrid_Skill_UnAttached_Course.fetchData();
            ListGrid_Skill_Selected_Course.fetchData();
            Window_Skill_AddCourse.show();
        }

    };

    function Skill_Finish_Course() {
        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null) {
            skill_selectedSkillId = -1;
            RestDataSource_Skill_Attached_Courses.fetchDataURL = "${restApiUrl}/api/skill/course-dummy";
        } else {
            RestDataSource_Skill_Attached_Courses.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/courses";
            selectedSkillId = record.id;
// // RestDataSource_Skill_Attached_SkillGroup.fetchData();

        }
        ListGrid_Skill_Attached_Courses.invalidateCache();


    };


    // End Block Add Courses To Skill ---------------------------------------------------------------


    //مشخص نمودن قالب ظاهر فرم
    var HLayout_Action_Skill_Skill = isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_Skill_Skill]
    });
    var HLayout_Grid_Skill_Skill = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_Skill_Skill
        ]
    });
    var VLayout_Body_Skill_Skill = isc.VLayout.create({
        width: "100%",
        height: "50%",
        <%--border: "2px solid blue",--%>
        members: [HLayout_Action_Skill_Skill, HLayout_Grid_Skill_Skill]
    });


    var VLayout_Action_Skill_SkillCourses = isc.VLayout.create({
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Action_Skill_SkillCourses]
    });
    var VLayout_Action_Skill_SkillGroups = isc.VLayout.create({
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Action_Skill_SkillGroups]
    });
    var VLayout_Action_Skill_SkillCompetences = isc.VLayout.create({
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Action_Skill_SkillCompetences]
    });


    var HLayout_Skill_SkillCourses_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_Skill_Attached_Courses
        ]
    });
    var HLayout_Skill_SkillGroups_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_Skill_Attached_SkillGroups
        ]
    });
    var HLayout_Skill_SkillCompetences_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_Skill_Attached_Competences
        ]
    });

    var HLayout_Tab_Skill_Competences = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            HLayout_Skill_SkillCompetences_Grid, VLayout_Action_Skill_SkillCompetences
        ]
    });
    var HLayout_Tab_Skill_SkillGroups = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            HLayout_Skill_SkillGroups_Grid, VLayout_Action_Skill_SkillGroups
        ]
    });
    var HLayout_Tab_Skill_Courses = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            HLayout_Skill_SkillCourses_Grid, VLayout_Action_Skill_SkillCourses
        ]
    });

    var Detail_Tab_Skill = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {
                id: "TabPane_Skill_SkillGroup",
                title: "گروه مهارت",
                pane: HLayout_Tab_Skill_SkillGroups

            },
            {
                id: "TabPane_Skill_Competence",
                title: "شایستگی",
                pane: HLayout_Tab_Skill_Competences
            },
            {
                id: "TabPane_Skill_Course",
                title: "دوره",
                pane: HLayout_Tab_Skill_Courses
            }
        ]
    });

    var VLayout_Tab_Skill = isc.VLayout.create({
        width: "100%",
        height: "50%",
        <%--border: "2px solid blue",--%>
        members: [Detail_Tab_Skill]
    });

    var VLayout_Skill_Body_All = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [VLayout_Body_Skill_Skill, VLayout_Tab_Skill]
    });
