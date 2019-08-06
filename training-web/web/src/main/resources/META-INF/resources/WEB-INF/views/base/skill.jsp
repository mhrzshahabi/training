<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>
    var skill_Level_Symbol = ""
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
    var DF_L_Opener;

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

    var RestDataSource_Skill_All_Competences = isc.RestDataSource.create({
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
        fetchDataURL: "${restApiUrl}/api/competence/spec-list"
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

    var RestDataSource_Skill_Attached_Jobs = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد شغل", align: "center"},
            {name: "costCenter", title: "مرکز هزينه", align: "center"},
            {name: "titleFa", title: "عنوان شغل", align: "center"},
            {name: "titleEn", title: "عنوان انگليسي", align: "center"},
            {name: "description", title: "توضيحات", align: "center"}
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
        fetchDataURL: "${restApiUrl}/api/skill/job-dummy"
    });


    //End Block Of Main And Detail Data Sources ----------------------------------------------------------
    //Start Competence PickList

    var ListGrid_Skill_All_Competences = isc.MyListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Skill_All_Competences,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین ", align: "center"},
            {name: "etechnicalType.titleFa", title: "نوع تخصص", align: "center"},
            {name: "ecompetenceInputType.titleFa", title: "مرجع تعریف", align: "center"}
        ],
        sortDirection: "descending",
        dataPageSize: 50,
        showFilterEditor: true,
        filterOnKeypress: false,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
        autoFetchData: false,
        doubleClick: function () {
            if (method_Skill_Select_Competence() == 1) {
                Window_Skill_All_Competence.close();
            }
        },
        sortField: 0,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single"
    });

    function method_skill_Show_Competences() {
        ListGrid_Skill_All_Competences.fetchData();
        Window_Skill_All_Competence.show();
    }

    function method_Skill_Select_Competence(record) {
        var record = ListGrid_Skill_All_Competences.getSelectedRecord()
        if (record == null) {
            isc.Dialog.create({
                message: "هیچ شایستگی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                    return 0;
                }

            });

        }
        DynamicForm_Skill_Skill.getItem("defaultCompetenceId").setValue(record.id);
        DynamicForm_Skill_Skill.getItem("defaultCompetenceTitle").setValue(record.titleFa);
        return 1;
    }

    var HLayout_Skill_All_Competence_Action = isc.HLayout.create({
        width: "100%",
        height: "30",
        align: "center",
        padding: 10,
        membersMargin: 10,

        <%--border: "2px solid blue",--%>
        members: [
            isc.MyButton.create({
                title: "انتخاب",
icon: "pieces/16/ok.png",

                prompt: "",
                width: 100,
                orientation: "vertical",
                click: function () {
                    if (method_Skill_Select_Competence() == 1) {
                        Window_Skill_All_Competence.close();
                    }
                }
            }),
            isc.MyButton.create({
                title: "لغو",
icon: "pieces/16/icon_delete.png",
                prompt: "",
                width: 100,
                orientation: "vertical",
                click: function () {
                    Window_Skill_All_Competence.close();
                }
            })
        ]
    });

    var VLayout_Skill_All_Competence_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [ListGrid_Skill_All_Competences]
    });

    var Window_Skill_All_Competence = isc.Window.create({
        title: "شایستگی ها",
        width: "1000",
        height: "500",
// autoSize: true,
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
            align: "center",
            members: [VLayout_Skill_All_Competence_Grid, HLayout_Skill_All_Competence_Action]
        })]
    });

    //End Competence PickList

    var DynamicForm_Skill_Skill = isc.MyDynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        showInlineErrors: true,
        numCols: "4",
        showErrorText: true,
        showErrorStyle: true,
        errorOrientation: "right",
        titleAlign: "left",
        requiredMessage: "فیلد اجباری است.",
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                colSpan: 2,
                title: "کد مهارت",
                length: 10,
                type: 'staticText',
                required: false,
// editable:false,
                keyPressFilter: "^[A-Z|0-9 ]",
                width: "300"
            },
            {
                name: "titleFa",
                title: "عنوان فارسی",
                required: true,
                hint: " عنوان فارسی",
                showHintInField: true,
                type: 'text',
                default: "125",
                readonly: true,
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|A-Z|a-z]| ",
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
                title: "عنوان لاتین ",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9| ]",
                hint: " عنوان لاتین",
                showHintInField: true,
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
                title: "سطح مهارت",
                hint: "سطح مهارت",
                showHintInField: true,
                width: "300",
                required: true,
                textAlign: "right",
                editorType: "ComboBoxItem",
                pickListWidth: 300,
                addUnknownValues: false,
                useClientFiltering: true,
                cachePickListResults: true,
                changeOnKeypress: false,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Skill_Skill_Level,
                autoFetchData: true,
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
                changed: function (form, item, value) {
                    switch (value) {
                        case 1:
                            skill_Level_Symbol = "A";
                            break;
                        case 2:
                            skill_Level_Symbol = "B";
                            break;
                        case 3:
                            skill_Level_Symbol = "C";
                            break;
                    }

                }
            },
            {
                name: "categoryId",
                title: "گروه مهارت",
                hint: "گروه مهارت",
                showHintInField: true,
                width: "300",
                required: true,
                textAlign: "right",
                editorType: "ComboBoxItem",
                addUnknownValues: false,
                useClientFiltering: true,
                cachePickListResults: true,
                changeOnKeypress: false,
                filterOnKeypress: true, pickListWidth: 300,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Skill_Category,
                autoFetchData: true,
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
                title: " زیر گروه مهارت",
                hint: "زیرگروه مهارت",
                showHintInField: true,
                width: "300",
                required: true,
                textAlign: "right",
                editorType: "ComboBoxItem",
                pickListWidth: 300,
                displayField: "titleFa",
                valueField: "id",
                addUnknownValues: false,
                useClientFiltering: true,
                cachePickListResults: true,
                changeOnKeypress: false,
                filterOnKeypress: true, optionDataSource: RestDataSource_Skill_SubCategory,
                autoFetchData: false,
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
            },
            {
                name: "edomainTypeId",
                type: "IntegerItem",
                title: "نوع مهارت",
                hint: " نوع مهارت",
                showHintInField: true,
                width: "300",
                required: true,
                textAlign: "right",
                editorType: "ComboBoxItem",
                pickListWidth: 300,
                addUnknownValues: false,
                useClientFiltering: true,
                cachePickListResults: true,
                changeOnKeypress: false,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Skill_EDomainType,
                autoFetchData: false,
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
                name: "defaultCompetenceId",
                hidden: true
            },
            {
                name: "defaultCompetenceTitle",
                title: "شایستگی",
                icons: [{
                    name: "add",
                    src: "[SKIN]/actions/add.png", // if inline icons are not supported by the browser, revert to a blank icon
                    inline: true
                }],
                iconWidth: 16,
                iconHeight: 16,
                width: "317",
                colSpan: 3,
                canEdit: false,
                textAlign: "right",
                click: function (form, item, icon) {
// item.clearValue();
                    method_skill_Show_Competences();
                },
                editorType: "text"
            },
            {
                name: "description",
                colSpan: 4,
                hint: " توضیحات",
                showHintInField: true,
                title: "توضيحات",
                length: "500",
                width: "700",
                type: 'areaText'
            }
        ]
    });

    var IButton_Skill_Skill_Save = isc.IButton.create({
        top: 260, title: "ذخیره", icon: "pieces/16/save.png",
        click: function () {
            if (skill_Method == "POST") {
                var sub_cat_code;
                if (DynamicForm_Skill_Skill.getItem('subCategoryId').getSelectedRecord() != null)
                    sub_cat_code = DynamicForm_Skill_Skill.getItem('subCategoryId').getSelectedRecord().code;
                DynamicForm_Skill_Skill.getItem('code').setValue(sub_cat_code + skill_Level_Symbol);
            }
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
                            title: "توجه"
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
        align: "center",
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Skill_Skill_Save, isc.IButton.create({
            title: "لغو",
            prompt: "",
            width: 100,
            icon: "pieces/16/icon_delete.png",
            orientation: "vertical",
            click: function () {
                Window_Skill_Skill.close();
            }
        })]
    });

    var Window_Skill_Skill = isc.Window.create({
        title: "مهارت",
        width: "830",
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
            align: "center",
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

    var ListGrid_Skill_Attached_Jobs = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Skill_Attached_Jobs,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد شغل", align: "center"},
            {name: "costCenter", title: "مرکز هزينه", align: "center"},
            {name: "titleFa", title: "عنوان فارسی", align: "center"},
            {name: "titleEn", title: "عنوان لاتین ", align: "center"},
            {name: "description", title: "توضيحات", align: "center"}
        ],
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        filterOnKeypress: false,
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
                    message: "لطفا یک مهارت را انتخاب کنید.",
                    icon: "[SKIN]ask.png",
                    title: "توجه",
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
                    message: "لطفا یک مهارت را انتخاب کنید.",
                    icon: "[SKIN]ask.png",
                    title: "توجه",
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
                    message: "لطفا یک مهارت را انتخاب کنید",
                    icon: "[SKIN]ask.png",
                    title: "توجه",
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
                                console.log(resp.httpResponseCode);
                                wait.close();
                                console.log(resp.httpResponseCode);
                                if (resp.data == "true") {
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
                message: "مهارتی برای ویرایش انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
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
            DynamicForm_Skill_Skill.getItem("categoryId").setDisabled(true);
            DynamicForm_Skill_Skill.getItem("subCategoryId").setDisabled(true);
            DynamicForm_Skill_Skill.getItem("skillLevelId").setDisabled(true);
            DynamicForm_Skill_Skill.getItem("code").visible = true;
            DynamicForm_Skill_Skill.getItem("defaultCompetenceTitle").visible = false;
            DynamicForm_Skill_Skill.getItem("defaultCompetenceId").setRequired(false);
            DynamicForm_Skill_Skill.getItem("defaultCompetenceTitle").setRequired(false);
            Window_Skill_Skill.setTitle(" ویرایش مهارت " + getFormulaMessage(ListGrid_Skill_Skill.getSelectedRecord().code, 3, "red", "I"));
            Window_Skill_Skill.show();

        }
    };

    function ListGrid_Skill_Skill_Add() {
        skill_Method = "POST";
        skill_ActionUrl = "${restApiUrl}/api/skill";
        DynamicForm_Skill_Skill.clearValues();
        DynamicForm_Skill_Skill.getItem("categoryId").setDisabled(false);
        DynamicForm_Skill_Skill.getItem("subCategoryId").setDisabled(true);
        DynamicForm_Skill_Skill.getItem("skillLevelId").setDisabled(false);
        DynamicForm_Skill_Skill.getItem("code").visible = false;
        DynamicForm_Skill_Skill.getItem("defaultCompetenceTitle").visible = true;
        DynamicForm_Skill_Skill.getItem("defaultCompetenceId").setRequired(true);
        DynamicForm_Skill_Skill.getItem("defaultCompetenceTitle").setRequired(true);
        Window_Skill_Skill.setTitle("ایجاد مهارت جدید");
        Window_Skill_Skill.show();
    };

    function ListGrid_Skill_Skill_refresh() {
        var record = ListGrid_Skill_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_Skill_Skill.selectRecord(record);
        }
        ListGrid_Skill_Skill.invalidateCache();
    };

    var Menu_ListGrid_Skill_Skill = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_Skill_Skill_refresh();
            }
        }, {
            title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_Skill_Skill_Add();
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
                "<spring:url value="/skill/print-all/pdf" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
                "<spring:url value="/skill/print-all/excel" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
                "<spring:url value="/skill/print-all/html" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }]
    });

    var ListGrid_Skill_Skill = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Skill_Skill,
        contextMenu: Menu_ListGrid_Skill_Skill,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,

        doubleClick: function () {
            ListGrid_Skill_Skill_Edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "کد", align: "center", filterOperator: "iContains"},
            {name: "titleFa", title: "نام فارسی", align: "center", filterOperator: "iContains"},
            {name: "titleEn", title: "نام لاتین ", align: "center", filterOperator: "iContains"},
            {name: "category.titleFa", title: "گروه", align: "center", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "زیر گروه", align: "center", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", title: "سطح مهارت", align: "center", filterOperator: "iContains"},
            {name: "edomainType.titleFa", title: "نوع مهارت", align: "center",canFilter:false},//filterOperator: "iContains"},
            {name: "description", title: "توضیحات", align: "center", hidden: true, filterOperator: "iContains"}
        ],
        selectionType: "single",
        selectionChanged: function (record, state) {
            if (record == null) {
                skill_selectedSkillId = -1;
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = "${restApiUrl}/api/skill/skill-group-dummy";
                RestDataSource_Skill_Attached_Competences.fetchDataURL = "${restApiUrl}/api/skill/competence-dummy";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = "${restApiUrl}/api/skill/course-dummy";
                RestDataSource_Skill_Attached_Jobs.fetchDataURL = "${restApiUrl}/api/skill/job-dummy";
            } else {
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/skill-groups";
                RestDataSource_Skill_Attached_Competences.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/competences";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/courses";
                RestDataSource_Skill_Attached_Jobs.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/jobs";
                selectedSkillId = record.id;
            }
            ListGrid_Skill_Attached_SkillGroups.invalidateCache();
            ListGrid_Skill_Attached_Competences.invalidateCache();
            ListGrid_Skill_Attached_Courses.invalidateCache();
            ListGrid_Skill_Attached_Jobs.invalidateCache();
        },
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
        dataArrived: function (startRow, endRow) {
            record = ListGrid_Skill_Skill.getSelectedRecord();
            if (record == null) {
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = "${restApiUrl}/api/skill/skill-group-dummy";
                RestDataSource_Skill_Attached_Competences.fetchDataURL = "${restApiUrl}/api/skill/competence-dummy";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = "${restApiUrl}/api/skill/course-dummy";
                RestDataSource_Skill_Attached_Jobs.fetchDataURL = "${restApiUrl}/api/skill/job-dummy";
            } else {
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/skill-groups";
                RestDataSource_Skill_Attached_Competences.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/competences";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/courses";
                RestDataSource_Skill_Attached_Jobs.fetchDataURL = "${restApiUrl}/api/skill/" + record.id + "/jobs";
                selectedSkillId = record.id;
            }
            ListGrid_Skill_Attached_SkillGroups.invalidateCache();
            ListGrid_Skill_Attached_Competences.invalidateCache();
            ListGrid_Skill_Attached_Courses.invalidateCache();
            ListGrid_Skill_Attached_Jobs.invalidateCache();


        },
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
            <%--skill_Method = "POST";--%>
            <%--skill_ActionUrl = "${restApiUrl}/api/skill";--%>
            <%--DynamicForm_Skill_Skill.clearValues();--%>
            <%--Window_Skill_Skill.show();--%>
            ListGrid_Skill_Skill_Add();
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
            "<spring:url value="/skill/print-all/pdf" var="printUrl"/>"
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

    var ToolStripButton_Skill_AddSkillGroup_Select_Single = isc.ToolStripButton.create({
        // icon: "pieces/512/right-arrow.png",
        width: 300,
        title: getFormulaMessage(">", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_UnAttached_SkillGroup.getSelectedRecord() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skillGroupRecord = ListGrid_Skill_UnAttached_SkillGroup.getSelectedRecord();
                var skillGroupId = skillGroupRecord.id;
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: "${restApiUrl}/api/skill/add-skill-group/" + skillGroupId + "/" + skillId,
                    httpMethod: "POST",
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });


            }

        }
    });
    var ToolStripButton_Skill_AddSkillGroup_Select_Multiple = isc.ToolStripButton.create({
// icon: "[SKIN]/actions/add.png",
        title: getFormulaMessage(">>", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_UnAttached_SkillGroup.getSelectedRecord() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skilGroupRecords = ListGrid_Skill_UnAttached_SkillGroup.getSelectedRecords();
                var skillGroupIds = new Array();
                for (i = 0; i < skilGroupRecords.getLength(); i++) {
                    skillGroupIds.add(skilGroupRecords[i].id);
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
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });
            }
        }
    });
    var ToolStripButton_Skill_AddSkillGroup_Deselect_Single = isc.ToolStripButton.create({
        // icon: "pieces/512/left-arrow.png",
        title: getFormulaMessage("<", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_Selected_SkillGroup.getSelectedRecords() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skillGroupRecord = ListGrid_Skill_Selected_SkillGroup.getSelectedRecord();
                var skillGroupId = skillGroupRecord.id;
// var JSONObj = {"ids": skillGroupIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: "${restApiUrl}/api/skill/remove-skill-group/" + skillGroupId + "/" + skillId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });

            }

        }
    });
    var ToolStripButton_Skill_AddSkillGroup_Deselect_Multiple = isc.ToolStripButton.create({
// icon: "[SKIN]/actions/add.png",
        title: getFormulaMessage("<<", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_Selected_SkillGroup.getSelectedRecords() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skillGroupRecords = ListGrid_Skill_Selected_SkillGroup.getSelectedRecords();
                var skillGroupIds = new Array();
                for (i = 0; i < skillGroupRecords.getLength(); i++) {
                    skillGroupIds.add(skillGroupRecords[i].id);
                }
// var JSONObj = {"ids": skillGroupIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: "${restApiUrl}/api/skill/remove-skill-group-list/" + skillGroupIds + "/" + skillId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_SkillGroup.invalidateCache();
                            ListGrid_Skill_UnAttached_SkillGroup.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });


            }
        }
    });
    var ToolStrip_Skill_AddSkillGroup = isc.ToolStrip.create({
        height: "100%",
        vertical: true,
        align: "center",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,

        members: [
            ToolStripButton_Skill_AddSkillGroup_Select_Single,
            ToolStripButton_Skill_AddSkillGroup_Deselect_Single,
            ToolStripButton_Skill_AddSkillGroup_Select_Multiple,
            ToolStripButton_Skill_AddSkillGroup_Deselect_Multiple
        ]
    });

    var DynamicForm_Skill_SkillData_Add_SkillGroup = isc.MyDynamicForm.create({
        titleWidth: 400,
// border:2,
        width: "100%",
        height: "100%",
        align: "right",
        titleAlign: "left",
        numCols: "6",
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                title: "کد مهارت",
                type: 'staticText',
                width: "100"
            },
            {
                name: "titleFa",
                title: "عنوان فارسی",
                type: 'staticText',
                length: "200",
                width: "150"
            },
            {
                name: "titleEn",
                title: "عنوان لاتین ",
                type: 'staticText',
                length: "200",
                width: "150"
            },
        ]
    });

    var ListGrid_Skill_UnAttached_SkillGroup = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canReorderRecords: true,
        dataSource: RestDataSource_Skill_UnAttached_SkillGroups,
        showRowNumbers: true,
        autoFetchData: false,
        border: "0px solid green",
        selectionType: "multiple",
        rowNumberFieldProperties: {
            //          autoFitWidthApproach: "both",
            //           canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"}
        ],
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
                        isc.say("اجرای این دستور با مشکل مواجه شده است");
                    }
                }
            });
        },
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
    });

    var ListGrid_Skill_Selected_SkillGroup = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        selectionType: "multiple",
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Skill_Attached_SkillGroups,
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
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"},
            {name: "OnDelete", title: "حذف", align: "center"}

        ],
        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
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
                        isc.say("اجرای این دستور با مشکل مواجه شده است");
                    }
                }
            });

        },
        dataPageSize: 50
    });

    var SectionStack_Skill_UnAttached_SkillGroup = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "45%",
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
        width: "45%",
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

    var VLayOut_Skill_SkillGroup_Add_Action = isc.VLayout.create({
        width: "10%",
        height: "100%",
        autoDraw: false,
// border: "0px solid red", layoutMargin: 5,
        align: "center",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,

        members: [ToolStrip_Skill_AddSkillGroup
        ]
    });

    var HStack_Skill_AddSkillGroup = isc.HStack.create({
        width: "100%",
        height: "100%",
        members: [
            SectionStack_Skill_UnAttached_SkillGroup,
            VLayOut_Skill_SkillGroup_Add_Action,
            SectionStack_Skill_Attached_SkillGroup
        ]
    });

    var HLayOut_Skill_AddSkillGroup_Header = isc.HLayout.create({
        width: "100%",
        height: 30,
//autoDraw: true,
        autoSize: false,
        border: "0px solid yellow",
        backgroundColor: "lightgray",

        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_Skill_SkillData_Add_SkillGroup
        ]
    });

    var VLayOut_Skill_SkillGroup_Add_Main = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_Skill_AddSkillGroup_Header,
            isc.HLayout.create({
                width: "100%",
                height: 10,
                backgroundColor: "blue",
                autoDraw: false,
                border: "0px solid red", layoutMargin: 5,
                members: []
            }),

            HStack_Skill_AddSkillGroup
        ]
    });

    var Window_Skill_AddSkillGroup = isc.Window.create({
        title: "مرتبط کردن/حذف ارتباط گروه مهارت با مهارت",
        width: "80%",
        height: "80%",
        autoSize: false,
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
                message: "لطفا یک مهارت را انتخاب کنید.",
                icon: "<spring:url value='[SKIN]ask.png'/>",
                title: "توجه",
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
        }
        ListGrid_Skill_Attached_SkillGroups.invalidateCache();
    };

    // End Block Add Skill Groups To Skill ---------------------------------------------------------------
    // Start Block Add Competences To Skill ---------------------------------------------------------------

    // Start Block Add Competence To Skill ---------------------------------------------------------------
    var ToolStripButton_Skill_AddCompetence_Select_Single = isc.ToolStripButton.create({
// icon: "pieces/512/right-arrow.png",
        width: 300,
        title: getFormulaMessage(">", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_UnAttached_Competence.getSelectedRecord() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var competenceRecord = ListGrid_Skill_UnAttached_Competence.getSelectedRecord();
                var competenceId = competenceRecord.id;
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: "${restApiUrl}/api/skill/add-competence/" + competenceId + "/" + skillId,
                    httpMethod: "POST",
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_Competence.invalidateCache();
                            ListGrid_Skill_UnAttached_Competence.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });


            }

        }
    });
    var ToolStripButton_Skill_AddCompetence_Select_Multiple = isc.ToolStripButton.create({
// icon: "[SKIN]/actions/add.png",
        title: getFormulaMessage(">>", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_UnAttached_Competence.getSelectedRecord() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skilGroupRecords = ListGrid_Skill_UnAttached_Competence.getSelectedRecords();
                var competenceIds = new Array();
                for (i = 0; i < skilGroupRecords.getLength(); i++) {
                    competenceIds.add(skilGroupRecords[i].id);
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
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_Competence.invalidateCache();
                            ListGrid_Skill_UnAttached_Competence.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });
            }
        }
    });
    var ToolStripButton_Skill_AddCompetence_Deselect_Single = isc.ToolStripButton.create({
// icon: "pieces/512/left-arrow.png",
        title: getFormulaMessage("<", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_Selected_Competence.getSelectedRecords() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var competenceRecord = ListGrid_Skill_Selected_Competence.getSelectedRecord();
                var competenceId = competenceRecord.id;
// var JSONObj = {"ids": competenceIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: "${restApiUrl}/api/skill/remove-competence/" + competenceId + "/" + skillId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_Competence.invalidateCache();
                            ListGrid_Skill_UnAttached_Competence.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });

            }

        }
    });
    var ToolStripButton_Skill_AddCompetence_Deselect_Multiple = isc.ToolStripButton.create({
// icon: "[SKIN]/actions/add.png",
        title: getFormulaMessage("<<", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_Selected_Competence.getSelectedRecords() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var competenceRecords = ListGrid_Skill_Selected_Competence.getSelectedRecords();
                var competenceIds = new Array();
                for (i = 0; i < competenceRecords.getLength(); i++) {
                    competenceIds.add(competenceRecords[i].id);
                }
// var JSONObj = {"ids": competenceIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: "${restApiUrl}/api/skill/remove-competence-list/" + competenceIds + "/" + skillId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_Competence.invalidateCache();
                            ListGrid_Skill_UnAttached_Competence.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });


            }
        }
    });
    var ToolStrip_Skill_AddCompetence = isc.ToolStrip.create({
        height: "100%",
        vertical: true,
        align: "center",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,

        members: [
            ToolStripButton_Skill_AddCompetence_Select_Single,
            ToolStripButton_Skill_AddCompetence_Deselect_Single,
            ToolStripButton_Skill_AddCompetence_Select_Multiple,
            ToolStripButton_Skill_AddCompetence_Deselect_Multiple
        ]
    });

    var DynamicForm_Skill_SkillData_Add_Competence = isc.MyDynamicForm.create({
        titleWidth: 400,
// border:2,
        width: "100%",
        height: "100%",
        align: "right",
        titleAlign: "left",
        numCols: "6",
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                title: "کد مهارت",
                type: 'staticText',
                width: "100"
            },
            {
                name: "titleFa",
                title: "عنوان فارسی",
                type: 'staticText',
                length: "200",
                width: "150"
            },
            {
                name: "titleEn",
                title: "عنوان لاتین ",
                type: 'staticText',
                length: "200",
                width: "150"
            },
        ]
    });

    var ListGrid_Skill_UnAttached_Competence = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canReorderRecords: true,
        dataSource: RestDataSource_Skill_UnAttached_Competences,
        showRowNumbers: true,
        autoFetchData: false,
        border: "0px solid green",
        selectionType: "multiple",
        rowNumberFieldProperties: {
//          autoFitWidthApproach: "both",
//           canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"}
        ],
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
                        isc.say("اجرای این دستور با مشکل مواجه شده است");
                    }
                }
            });
        },
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
    });

    var ListGrid_Skill_Selected_Competence = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        selectionType: "multiple",
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Skill_Attached_Competences,
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
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"},
            {name: "OnDelete", title: "حذف", align: "center"}

        ],
        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
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
                        isc.say("اجرای این دستور با مشکل مواجه شده است");
                    }
                }
            });

        },
        dataPageSize: 50
    });

    var SectionStack_Skill_UnAttached_Competence = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "45%",
        sections: [
            {
                title: "شایستگیهای انتخاب نشده",
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
        width: "45%",
        sections: [
            {
                title: "شایستگیهای انتخاب شده",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_Selected_Competence
                ]
            }
        ]
    });

    var VLayOut_Skill_Competence_Add_Action = isc.VLayout.create({
        width: "10%",
        height: "100%",
        autoDraw: false,
// border: "0px solid red", layoutMargin: 5,
        align: "center",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,

        members: [ToolStrip_Skill_AddCompetence
        ]
    });

    var HStack_Skill_AddCompetence = isc.HStack.create({
        width: "100%",
        height: "100%",
        members: [
            SectionStack_Skill_UnAttached_Competence,
            VLayOut_Skill_Competence_Add_Action,
            SectionStack_Skill_Attached_Competence
        ]
    });

    var HLayOut_Skill_AddCompetence_Header = isc.HLayout.create({
        width: "100%",
        height: 30,
//autoDraw: true,
        autoSize: false,
        border: "0px solid yellow",
        backgroundColor: "lightgray",

        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_Skill_SkillData_Add_Competence
        ]
    });

    var VLayOut_Skill_Competence_Add_Main = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_Skill_AddCompetence_Header,
            isc.HLayout.create({
                width: "100%",
                height: 10,
                backgroundColor: "blue",
                autoDraw: false,
                border: "0px solid red", layoutMargin: 5,
                members: []
            }),

            HStack_Skill_AddCompetence
        ]
    });

    var Window_Skill_AddCompetence = isc.Window.create({
        title: "مرتبط کردن/حذف ارتباط شایستگی با مهارت",
        width: "80%",
        height: "80%",
        autoSize: false,
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
                message: "لطفا یک مهارت را انتخاب کنید.",
                icon: "<spring:url value='[SKIN]ask.png'/>",
                title: "توجه",
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
            DynamicForm_Skill_SkillData_Add_Competence.setValue("titleEn", record.titleEn);
            DynamicForm_Skill_SkillData_Add_Competence.setValue("code", record.code);
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
        }
        ListGrid_Skill_Attached_Competences.invalidateCache();
    };

    // End Block Add Competences To Skill ---------------------------------------------------------------

    // Start Block Add Courses To Skill ---------------------------------------------------------------
    var ToolStripButton_Skill_AddCourse_Select_Single = isc.ToolStripButton.create({
// icon: "pieces/512/right-arrow.png",
        width: 300,
        title: getFormulaMessage(">", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_UnAttached_Course.getSelectedRecord() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var courseRecord = ListGrid_Skill_UnAttached_Course.getSelectedRecord();
                var courseId = courseRecord.id;
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: "${restApiUrl}/api/skill/add-course/" + courseId + "/" + skillId,
                    httpMethod: "POST",
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_Course.invalidateCache();
                            ListGrid_Skill_UnAttached_Course.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });


            }

        }
    });
    var ToolStripButton_Skill_AddCourse_Select_Multiple = isc.ToolStripButton.create({
// icon: "[SKIN]/actions/add.png",
        title: getFormulaMessage(">>", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_UnAttached_Course.getSelectedRecord() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var skilGroupRecords = ListGrid_Skill_UnAttached_Course.getSelectedRecords();
                var courseIds = new Array();
                for (i = 0; i < skilGroupRecords.getLength(); i++) {
                    courseIds.add(skilGroupRecords[i].id);
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
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_Course.invalidateCache();
                            ListGrid_Skill_UnAttached_Course.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });
            }
        }
    });
    var ToolStripButton_Skill_AddCourse_Deselect_Single = isc.ToolStripButton.create({
// icon: "pieces/512/left-arrow.png",
        title: getFormulaMessage("<", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_Selected_Course.getSelectedRecords() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var courseRecord = ListGrid_Skill_Selected_Course.getSelectedRecord();
                var courseId = courseRecord.id;
// var JSONObj = {"ids": courseIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: "${restApiUrl}/api/skill/remove-course/" + courseId + "/" + skillId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_Course.invalidateCache();
                            ListGrid_Skill_UnAttached_Course.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });

            }

        }
    });
    var ToolStripButton_Skill_AddCourse_Deselect_Multiple = isc.ToolStripButton.create({
// icon: "[SKIN]/actions/add.png",
        title: getFormulaMessage("<<", "5", "blue", "B"),
        click: function () {
            if (ListGrid_Skill_Selected_Course.getSelectedRecords() != null) {
                var skillRecord = ListGrid_Skill_Skill.getSelectedRecord();
                var skillId = skillRecord.id;
                var courseRecords = ListGrid_Skill_Selected_Course.getSelectedRecords();
                var courseIds = new Array();
                for (i = 0; i < courseRecords.getLength(); i++) {
                    courseIds.add(courseRecords[i].id);
                }
// var JSONObj = {"ids": courseIds};
                isc.RPCManager.sendRequest({
                    httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: "${restApiUrl}/api/skill/remove-course-list/" + courseIds + "/" + skillId,
                    httpMethod: "DELETE",
// data: JSON.stringify(JSONObj),
                    serverOutputAsString: false,
                    callback: function (resp) {
                        if (resp.data == "true") {
                            ListGrid_Skill_Selected_Course.invalidateCache();
                            ListGrid_Skill_UnAttached_Course.invalidateCache();
                        } else {
                            isc.say("اجرای این دستور با مشکل مواجه شده است");
                        }
                    }
                });


            }
        }
    });
    var ToolStrip_Skill_AddCourse = isc.ToolStrip.create({
        height: "100%",
        vertical: true,
        align: "center",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,

        members: [
            ToolStripButton_Skill_AddCourse_Select_Single,
            ToolStripButton_Skill_AddCourse_Deselect_Single,
            ToolStripButton_Skill_AddCourse_Select_Multiple,
            ToolStripButton_Skill_AddCourse_Deselect_Multiple
        ]
    });

    var DynamicForm_Skill_SkillData_Add_Course = isc.MyDynamicForm.create({
        titleWidth: 400,
// border:2,
        width: "100%",
        height: "100%",
        align: "right",
        titleAlign: "left",
        numCols: "6",
        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                title: "کد مهارت",
                type: 'staticText',
                width: "100"
            },
            {
                name: "titleFa",
                title: "عنوان فارسی",
                type: 'staticText',
                length: "200",
                width: "150"
            },
            {
                name: "titleEn",
                title: "عنوان لاتین ",
                type: 'staticText',
                length: "200",
                width: "150"
            },
        ]
    });

    var ListGrid_Skill_UnAttached_Course = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canReorderRecords: true,
        dataSource: RestDataSource_Skill_UnAttached_Courses,
        showRowNumbers: true,
        autoFetchData: false,
        border: "0px solid green",
        selectionType: "multiple",
        rowNumberFieldProperties: {
//          autoFitWidthApproach: "both",
//           canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='global.grid.row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"}
        ],
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
                        isc.say("اجرای این دستور با مشکل مواجه شده است");
                    }
                }
            });
        },
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
    });

    var ListGrid_Skill_Selected_Course = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        selectionType: "multiple",
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Skill_Attached_Courses,
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
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
            {name: "titleEn", title: "نام لاتین", align: "center"},
            {name: "OnDelete", title: "حذف", align: "center"}

        ],
        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
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
                        isc.say("اجرای این دستور با مشکل مواجه شده است");
                    }
                }
            });

        },
        dataPageSize: 50
    });

    var SectionStack_Skill_UnAttached_Course = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "45%",
        sections: [
            {
                title: "دوره های انتخاب نشده",
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
        width: "45%",
        sections: [
            {
                title: "دوره های انتخاب شده",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Skill_Selected_Course
                ]
            }
        ]
    });

    var VLayOut_Skill_Course_Add_Action = isc.VLayout.create({
        width: "10%",
        height: "100%",
        autoDraw: false,
// border: "0px solid red", layoutMargin: 5,
        align: "center",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,

        members: [ToolStrip_Skill_AddCourse
        ]
    });

    var HStack_Skill_AddCourse = isc.HStack.create({
        width: "100%",
        height: "100%",
        members: [
            SectionStack_Skill_UnAttached_Course,
            VLayOut_Skill_Course_Add_Action,
            SectionStack_Skill_Attached_Course
        ]
    });

    var HLayOut_Skill_AddCourse_Header = isc.HLayout.create({
        width: "100%",
        height: 30,
//autoDraw: true,
        autoSize: false,
        border: "0px solid yellow",
        backgroundColor: "lightgray",

        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_Skill_SkillData_Add_Course
        ]
    });

    var VLayOut_Skill_Course_Add_Main = isc.VLayout.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_Skill_AddCourse_Header,
            isc.HLayout.create({
                width: "100%",
                height: 10,
                backgroundColor: "blue",
                autoDraw: false,
                border: "0px solid red", layoutMargin: 5,
                members: []
            }),

            HStack_Skill_AddCourse
        ]
    });

    var Window_Skill_AddCourse = isc.Window.create({
        title: "مرتبط کردن/حذف ارتباط دوره با مهارت",
        width: "80%",
        height: "80%",
        autoSize: false,
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
                message: "لطفا یک مهارت را انتخاب کنید.",
                icon: "<spring:url value='[SKIN]ask.png'/>",
                title: "توجه",
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
            DynamicForm_Skill_SkillData_Add_Course.setValue("titleEn", record.titleEn);
            DynamicForm_Skill_SkillData_Add_Course.setValue("code", record.code);
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


    var HLayout_Skill_SkillJobs_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_Skill_Attached_Jobs
        ]
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
    var HLayout_Tab_Skill_Jobs = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            HLayout_Skill_SkillJobs_Grid
        ]
    });


    var Detail_Tab_Skill = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {
                id: "TabPane_Skill_SkillGroup",
                title: "لیست گروه های مهارت",
                pane: HLayout_Tab_Skill_SkillGroups

            },
            {
                id: "TabPane_Skill_Competence",
                title: "لیست شایستگی ها",
                pane: HLayout_Tab_Skill_Competences
            },
            {
                id: "TabPane_Skill_Course",
                title: "لیست دوره ها",
                pane: HLayout_Tab_Skill_Courses
            },
            {
                id: "TabPane_Skill_Job",
                title: "لیست مشاغل",
                pane: HLayout_Tab_Skill_Jobs
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
