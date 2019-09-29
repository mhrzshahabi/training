<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>

    <%
        final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    %>

    var skill_Level_Symbol = ""
    var skill_Method = "GET";
    var skill_SkillHomeUrl = rootUrl + "/skill";
    var skill_CategoryHomeUrl = rootUrl + "/category";
    var skill_ActionUrl = rootUrl + "/skill";
    var skill_CategoryUrl = rootUrl + "/category/spec-list";
    var skill_SkillLevelUrl = rootUrl + "/skill-level/spec-list";
    var skill_selectedSkillId = -1;

    // Start Block Of Combo And List Data Sources ----------------------------------------------------------

    var RestDataSource_Skill_Skill_Level = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "version"}
        ],
        fetchDataURL: skill_SkillLevelUrl
    });

    var RestDataSource_Skill_Category = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"}
        ],
        fetchDataURL: skill_CategoryUrl
    });

    var RestDataSource_Skill_SubCategory = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, canEdit: false,},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"},
        ]
    });


    //End Block Of Combo And List Data Sources ----------------------------------------------------------


    // Start Block Of Main And Detail Data Sources ----------------------------------------------------------

    var RestDataSource_Skill_Skill = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "category.titleFa"},
            {name: "subCategory.titleFa"},
            {name: "skillLevel.titleFa"},
            {name: "description"},
        ],
        fetchDataURL: skill_SkillHomeUrl + "/spec-list"
    });

    var RestDataSource_Skill_Attached_SkillGroups = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"}
        ],
        fetchDataURL: skill_SkillHomeUrl + "/skill-group-dummy"
    });

    var RestDataSource_Skill_UnAttached_SkillGroups = isc.MyRestDataSource.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"}
        ],
        fetchDataURL: skill_SkillHomeUrl + "/skill-group-dummy"
    });

    var RestDataSource_Skill_Attached_Courses = isc.MyRestDataSource.create({
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
        fetchDataURL: skill_SkillHomeUrl + "/course-dummy"
    });

    var RestDataSource_Skill_Need_Assessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "post.titleFa", title: "<spring:message code="post"/>", filterOperator: "contains"},
            {name: "competence.titleFa", title: "<spring:message code="competence"/>", filterOperator: "contains"},
            {
                name: "edomainType.titleFa",
                title: "<spring:message code="domain"/>",
                filterOperator: "contains"
            },
            {
                name: "eneedAssessmentPriority.titleFa",
                title: "<spring:message code="priority"/>",
                filterOperator: "contains"
            },
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "contains"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "contains"},
        ],
        fetchDataURL: skill_SkillHomeUrl + "/0/need-assessment"
    });

    var RestDataSource_Skill_UnAttached_Courses = isc.MyRestDataSource.create({
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
        fetchDataURL: skill_SkillHomeUrl + "/course-dummy"
    });

    //End Block Of Main And Detail Data Sources ----------------------------------------------------------

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
                        RestDataSource_Skill_SubCategory.fetchDataURL = skill_CategoryHomeUrl + "/" + value + "/sub-categories";
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
            //console.log(JSON.stringify(data));

            isc.RPCManager.sendRequest({
                actionURL: skill_ActionUrl,
                httpMethod: skill_Method,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
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
            icon: "<spring:url value="remove.png"/>",
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
        showFilterEditor: false,
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
        showFilterEditor: false,
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


    ListGrid_Skill_Need_Assessment = isc.TrLG.create({
        dataSource: RestDataSource_Skill_Need_Assessment,
        showFilterEditor: false,
        filterOnKeypress: false,
        fields: [
            {name: "post.titleFa",},
            {name: "competence.titleFa",},
            {name: "edomainType.titleFa",},
            {name: "eneedAssessmentPriority.titleFa",},
            {name: "skill.titleFa", hidden: true},
            {name: "description",},
        ],
        autoFetchData: false,
        sortField: 0
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
                            actionURL: skill_SkillHomeUrl + "/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
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
            //console.log('record:' + JSON.stringify(record));
            var id = record.categoryId;
            DynamicForm_Skill_Skill.clearValues();
            RestDataSource_Skill_SubCategory.fetchDataURL = skill_CategoryHomeUrl + "/" + id + "/sub-categories";
            DynamicForm_Skill_Skill.getItem("subCategoryId").fetchData();
            skill_Method = "PUT";
            skill_ActionUrl = skill_SkillHomeUrl + "/" + record.id;
            DynamicForm_Skill_Skill.editRecord(record);
            DynamicForm_Skill_Skill.getItem("categoryId").setDisabled(true);
            DynamicForm_Skill_Skill.getItem("subCategoryId").setDisabled(true);
            DynamicForm_Skill_Skill.getItem("skillLevelId").setDisabled(true);
            DynamicForm_Skill_Skill.getItem("code").visible = true;
            Window_Skill_Skill.setTitle(" ویرایش مهارت " + getFormulaMessage(ListGrid_Skill_Skill.getSelectedRecord().code, 3, "red", "I"));
            Window_Skill_Skill.show();

        }
    };
    function ListGrid_Skill_Skill_Add() {
        skill_Method = "POST";
        skill_ActionUrl = skill_SkillHomeUrl;
        DynamicForm_Skill_Skill.clearValues();
        DynamicForm_Skill_Skill.getItem("categoryId").setDisabled(false);
        DynamicForm_Skill_Skill.getItem("subCategoryId").setDisabled(true);
        DynamicForm_Skill_Skill.getItem("skillLevelId").setDisabled(false);
        DynamicForm_Skill_Skill.getItem("code").visible = false;
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
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Skill_Skill_refresh();
            }
        }, {
            title: "ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Skill_Skill_Add();
            }
        }, {
            title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {

                ListGrid_Skill_Skill_Edit();

            }
        }, {
            title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {
                ListGrid_Skill_Skill_Remove();
            }
        }, {isSeparator: true}, {
            title: "ارسال به Pdf", icon: "<spring:url value="pdf.png"/>", click: function () {
                "<spring:url value="/skill/print-all/pdf" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "ارسال به Excel", icon: "<spring:url value="excel.png"/>", click: function () {
                "<spring:url value="/skill/print-all/excel" var="printUrl"/>"
                window.open('${printUrl}');
            }
        }, {
            title: "ارسال به Html", icon: "<spring:url value="html.png"/>", click: function () {
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
            {name: "description", title: "توضیحات", align: "center", hidden: true, filterOperator: "iContains"}
        ],
        selectionType: "single",
        selectionChanged: function (record, state) {
            if (record == null) {
                skill_selectedSkillId = -1;
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/skill-group-dummy";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillHomeUrl + "/course-dummy";
                RestDataSource_Skill_Need_Assessment.fetchDataURL = skill_SkillHomeUrl + "/0/need-assessment";
                ListGrid_Skill_Need_Assessment.invalidateCache();
                ListGrid_Skill_Need_Assessment.setData([]);
            } else {
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/skill-groups";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/courses";
                RestDataSource_Skill_Need_Assessment.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/need-assessment";
                ListGrid_Skill_Need_Assessment.invalidateCache();
                ListGrid_Skill_Need_Assessment.fetchData();
                selectedSkillId = record.id;
            }
            ListGrid_Skill_Attached_SkillGroups.invalidateCache();
            ListGrid_Skill_Attached_Courses.invalidateCache();
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
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/skill-group-dummy";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillHomeUrl + "/course-dummy";
                RestDataSource_Skill_Need_Assessment.fetchDataURL = skill_SkillHomeUrl + "/0/need-assessment";
                ListGrid_Skill_Need_Assessment.invalidateCache();
                ListGrid_Skill_Need_Assessment.setData([]);
            } else {
                RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/skill-groups";
                RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/courses";
                RestDataSource_Skill_Need_Assessment.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/need-assessment";
                ListGrid_Skill_Need_Assessment.invalidateCache();
                ListGrid_Skill_Need_Assessment.fetchData();
                selectedSkillId = record.id;
            }
            ListGrid_Skill_Attached_SkillGroups.invalidateCache();
            ListGrid_Skill_Attached_Courses.invalidateCache();


        },
    });


    var ToolStripButton_Skill_Skill_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
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
            <%--console.log('${printUrl}')   ;--%>
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
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/add-skill-group/" + skillGroupId + "/" + skillId,
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
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/add-skill-group-list/" + skillId,
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
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/remove-skill-group/" + skillGroupId + "/" + skillId,
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
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/remove-skill-group-list/" + skillGroupIds + "/" + skillId,
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
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: skill_SkillHomeUrl + "/add-skill-group/" + skillGroupId + "/" + skillId,
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
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: skill_SkillHomeUrl + "/remove-skill-group/" + skillGroupId + "/" + skillId,
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
            RestDataSource_Skill_UnAttached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/unattached-skill-groups";
            RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/skill-groups";
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
            RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/skill-group-dummy";
        } else {
            RestDataSource_Skill_Attached_SkillGroups.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/skill-groups";
            selectedSkillId = record.id;
        }
        ListGrid_Skill_Attached_SkillGroups.invalidateCache();
    };

    // End Block Add Skill Groups To Skill ---------------------------------------------------------------


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
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/add-course/" + courseId + "/" + skillId,
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
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/add-course-list/" + skillId,
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
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/remove-course/" + courseId + "/" + skillId,
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
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    actionURL: skill_SkillHomeUrl + "/remove-course-list/" + courseIds + "/" + skillId,
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
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: skill_SkillHomeUrl + "/add-course/" + courseId + "/" + skillId,
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
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: skill_SkillHomeUrl + "/remove-course/" + courseId + "/" + skillId,
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
            RestDataSource_Skill_UnAttached_Courses.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/unattached-courses";
            RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/courses";
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
            RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillHomeUrl + "/course-dummy";
        } else {
            RestDataSource_Skill_Attached_Courses.fetchDataURL = skill_SkillHomeUrl + "/" + record.id + "/courses";
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


    var HLayout_Skill_Need_Assessment_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            ListGrid_Skill_Need_Assessment
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
    var HLayout_Tab_Skill_Need_Assessment = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            HLayout_Skill_Need_Assessment_Grid
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
                id: "TabPane_Skill_Course",
                title: "لیست دوره ها",
                pane: HLayout_Tab_Skill_Courses
            },
            {
                id: "TabPane_Skill_Course",
                title: "لیست نیازسنجی مرتبط",
                pane: HLayout_Tab_Skill_Need_Assessment
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
