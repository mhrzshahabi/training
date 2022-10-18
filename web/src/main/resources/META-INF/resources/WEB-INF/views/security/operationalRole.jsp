<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    "use strict"

    var methodOperationalRole;
    var saveActionUrlOperationalRole;
    var wait_Permission;
    let departmentCriteria = [];
    let hasRoleCategoriesChanged = false;
    let selected_record = null;
    //--------------------------------------------------------------------------------------------------------------------//
    /*DS*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_JspOperationalRole = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "code"},
                {name: "title"},
                {name: "description"},
                {name: "operationalUnit.operationalUnit"},
                {name: "userIds", title: "<spring:message code="post"/>", filterOperator: "inSet"},
                {name: "postIds", title: "<spring:message code="users"/>", filterOperator: "inSet"},
                {name: "complexId"},
                {name: "objectType"}
            ],
    });

    var UserDS_JspOperationalRole = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "username",
                title: "<spring:message code="username"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "version", hidden: true}
        ],
        fetchDataURL: oauthUserUrl + "/spec-list"
    });

    let RestDataSource_OperationalRole_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });


    var RestDataSource_JspOperationalUnit = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "unitCode"},
                {name: "operationalUnit"}
            ],
        fetchDataURL: operationalUnitUrl + "spec-list"
    });

    let PostDS_OperationalRole = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "postGradeTitleFa",
                title: "<spring:message code="post.grade.title"/>",
                filterOperator: "iContains"
            },
        ],
        // fetchDataURL: viewPostUrl + "/iscList"
        // fetchDataURL: viewPostUrl + "/rolePostList"
    });

    let PostDS_just_Show_OperationalRole = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "departmentId", title: "departmentId", primaryKey: true, canEdit: false, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals",  valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains",  autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains"},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains"},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains"},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains"},
            {name: "description", hidden: true, title: "توضیحات", align: "center", filterOperator: "iContains",  autoFitWidthApproach: "both"},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals",  autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals",  autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals",  autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains",  autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals",  filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        transformRequest: function (dsRequest) {
            transformCriteriaForLastModifiedDateNA(dsRequest);
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: viewTrainingPostUrl + "/iscList"
    });

    let PostDS_just_Show_Non_Used_OperationalRole = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "departmentId", title: "departmentId", primaryKey: true, canEdit: false, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals",  valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains",  autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", hidden: true, title: "توضیحات", align: "center", filterOperator: "iContains",  autoFitWidthApproach: "both"},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals",  autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals",  autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals",  autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains",  autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals",  filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        transformRequest: function (dsRequest) {
            transformCriteriaForLastModifiedDateNA(dsRequest);
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: viewTrainingPostUrl + "/iscList"
    });

    var RestDataSource_Categories_OperationalRole = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true}
        ],
        cacheAllData: true,
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategories_OperationalRole = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"},{name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true}],
        fetchDataURL: subCategoryUrl + "iscList"
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_JspOperationalRole = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                refreshLG(ListGrid_JspOperationalRole);
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                // PostDS_OperationalRole.fetchDataURL = viewPostUrl+"/rolePostList/0";
                PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + 0;
                ListGrid_OperationalRole_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                let record = ListGrid_JspOperationalRole.getSelectedRecord();
                selected_record = record;
                // PostDS_OperationalRole.fetchDataURL = viewPostUrl + "/rolePostList/" + record.id;
                PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + record.id;
                ListGrid_OperationalRole_Edit(selected_record);
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_OperationalRole_Remove();
            }
        },
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ListGrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_JspOperationalRole = isc.TrLG.create({
        dataSource: RestDataSource_JspOperationalRole,
        contextMenu: Menu_JspOperationalRole,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "title",
                title: "<spring:message code="title"/>",
                filterOperator: "iContains"
            },
            {
                name: "code",
                title: "<spring:message code="code"/>",
                filterOperator: "iContains"
            },
            {
                name: "operationalUnit.operationalUnit",
                title: "<spring:message code="unitName"/>",
                filterOperator: "iContains"
            },
            {
                name: "description",
                title: "<spring:message code="description"/>",
                filterOperator: "iContains"
            },
            {
                name: "userIds",
                type: "selectItem",
                title: "<spring:message code="users"/>",
                filterOperator: "inSet",
                optionDataSource: UserDS_JspOperationalRole,
                valueField: "id",
                displayField: "lastName",
                filterField: "lastName",
                filterOnKeypress: true,
                multiple: true,
                canSort: false,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "firstName",
                        title: "<spring:message code="firstName"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "lastName",
                        title: "<spring:message code="lastName"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "username",
                        title: "<spring:message code="username"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "nationalCode",
                        title: "<spring:message code="national.code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ]
            }
        ],
        rowDoubleClick: function (record) {
            PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + record.id;
            selected_record = record;
            ListGrid_OperationalRole_Edit(selected_record);
        },
        filterEditorSubmit: function () {
            ListGrid_JspOperationalRole.invalidateCache();
        }
    });

    // پست های انتخاب شده
    let ListGrid_Post_OperationalRole = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canAutoFitWidth: true,
        selectionType: "simple",
        selectionAppearance: "checkbox",
        dataSource: PostDS_just_Show_OperationalRole,
        autoFetchData: true,
        sortField: 1,
        sortDirection: "descending",
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "departmentId", title: "departmentId", primaryKey: true, canEdit: false, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals",  valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", },
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", },
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", },
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", },
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", },
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", },
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", },
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains"},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", },
            {name: "description", hidden: true, title: "توضیحات", align: "center", filterOperator: "iContains"},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals",  filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ]
    });
    // پست های انتخاب نشده
    let ListGrid_Non_Used_Post_OperationalRole = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canAutoFitWidth: true,
        selectionType: "simple",
        selectionAppearance: "checkbox",
        dataSource: PostDS_just_Show_Non_Used_OperationalRole,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "departmentId", title: "departmentId", primaryKey: true, canEdit: false, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals",  valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", },
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", },
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", },
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", },
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", },
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", },
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", },
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", },
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", },
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", },
            {name: "description", hidden: true, title: "توضیحات", align: "center", filterOperator: "iContains"},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals",  filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
            ],
        autoFetchData: true,
        sortField: 1,
        sortDirection: "descending"
    });


    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm */
    //--------------------------------------------------------------------------------------------------------------------//


    var DynamicForm_JspOperationalRole = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "title",
                title: "<spring:message code="title"/>",
                required: true,
                validateOnExit: true,
                length: 255
            },
            {
                name: "complexId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="complex"/>:",
                // pickListWidth: 200,
                optionDataSource: RestDataSource_OperationalRole_Department_Filter,
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
            },
            {
                name: "operationalUnitId",
                title: "<spring:message code="unitName"/>",
                optionDataSource: RestDataSource_JspOperationalUnit,
                valueField: "id",
                displayField: "operationalUnit",
                required: true,
                validateOnExit: true,
                length: 255,
                canSort: false,
            },
            {
                name: "categories",
                title: "<spring:message code='educational.category'/>",
                // editorType: "MultiComboBoxItem",
                length: 255,
                type: "SelectItem",

                // pickListWidth: 200,
                multiple: true,
                textAlign: "center",
                autoFetchData: false,
                optionDataSource: RestDataSource_Categories_OperationalRole,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                operator: "inSet",
                // filterOnKeypress: true,
                autoFitButtons: true,
                titleVAlign: "top",
                pickListProperties: {
                    showFilterEditor: false
                },
                changed: function () {
                    hasRoleCategoriesChanged = true;
                    var subCategoryField = DynamicForm_JspOperationalRole.getField("subCategories");
                    subCategoryField.clearValue();
                    if (this.value === null || this.getValue() === null || this.getValue() === undefined || this.getValue() === "") {
                        hasRoleCategoriesChanged = false;
                        subCategoryField.clearValue();
                        DynamicForm_JspOperationalRole.getField("subCategories").disable();
                        return;
                    }

                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    let categoryIds = this.getValue();
                    var SubCats = [];
                    for (var i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "subCategories",
                title: "<spring:message code='educational.sub.category'/>",
                // editorType: "MultiComboBoxItem",
                length: 255,
                type: "SelectItem",

                operator: "inSet",
                filterOnKeypress: true,
                autoFitButtons: true,
                titleVAlign: "top",

                // pickListWidth: 200,
                multiple: true, textAlign: "center",
                autoFetchData: true,
                disabled: true,
                optionDataSource: RestDataSource_SubCategories_OperationalRole,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                pickListProperties: {
                    showFilterEditor: false
                },
                focus: function () {
                    if (hasRoleCategoriesChanged) {
                        console.log("hasRoleCategoriesChanged", hasRoleCategoriesChanged);
                        hasRoleCategoriesChanged = false;
                        var ids = DynamicForm_JspOperationalRole.getField("categories").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategories_OperationalRole.implicitCriteria = null;
                        } else {
                            console.log("ids in subCategories :", ids);
                            RestDataSource_SubCategories_OperationalRole.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
                }
            },
            {
                name: "postIds",
                hidden: true,
                // type: "MultiComboBoxItem",
                title: "<spring:message code="post"/>",
                optionDataSource: PostDS_OperationalRole,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                multiple: true,
                comboBoxProperties: {
                    hint: "",
                    filterFields: ["code", "titleFa", "jobTitleFa", "postGradeTitleFa"],
                    textMatchStyle: "substring",
                    pickListWidth: 450,
                    pickListProperties: {
                        autoFitWidthApproach: "both",
                    },
                    pickListFields: [
                        {
                            name: "code",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {name: "titleFa",  filterOperator: "iContains"},
                        {
                            name: "jobTitleFa",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {
                            name: "postGradeTitleFa",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        }
                    ],
                }
            },
            {
                name: "description",
                title: "<spring:message code="description"/>",
                length: 255
            },
            {
                name: "objectType",
                title: "نوع نقش:",
                multiple: false,
                type: "SelectItem",
                valueMap: {
                    "EXECUTIVE_SUPERVISOR": "سرپرست اجرا",
                    "CHIEF_EXECUTIVE_OFFICER": "رییس اجرا",
                    "EXECUTION_EXPERT": "کارشناس اجرا",
                    "MASTER_OF_PLANNING": "کارشناس ارشد برنامه ریزی",
                    "HEAD_OF_PLANNING": "رییس برنامه ریزی",
                    "CERTIFICATION_RESPONSIBLE": "مسئول صدور گواهی نامه آموزشی",
                    "FINANCIAL_RESPONSIBLE": "مسئول مالی",
                    "TRAINING_MANAGER": "مدیر آموزش"
                },
                valueField: "id",
                displayField: "title",
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                        }
                    }
                ],
                required: false,
                validateOnExit: true,
                length: 255,
                canSort: false
            },
            {
                name: "userIds",
                type: "MultiComboBoxItem",
                title: "<spring:message code="users"/>",
                optionDataSource: UserDS_JspOperationalRole,
                valueField: "id",
                displayField: "lastName",
                filterOnKeypress: true,
                multiple: true,
                comboBoxProperties: {
                    hint: "",
                    filterFields: ["firstName", "lastName", "username", "nationalCode"],
                    textMatchStyle: "substring",
                    pickListWidth: 335,
                    pickListProperties: {
                        autoFitWidthApproach: "both",
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
                                            let fItem = DynamicForm_JspOperationalRole.getField("userIds");
                                            fItem.setValue(fItem.comboBox.pickList.data.localData.map(user => user.id));
                                            fItem.comboBox.pickList.hide();
                                        }
                                    }),
                                    isc.ToolStripButton.create({
                                        width: "50%",
                                        icon: "[SKIN]/actions/close.png",
                                        title: "<spring:message code='deselect.all'/>",
                                        click: function () {
                                            let fItem = DynamicForm_JspOperationalRole.getField("userIds");
                                            fItem.setValue([]);
                                            fItem.comboBox.pickList.hide();
                                        }
                                    })
                                ]
                            }),
                            "header", "body"
                        ]
                    },
                    pickListFields: [
                        {
                            name: "firstName",
                            title: "<spring:message code="firstName"/>",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
                        {
                            name: "username",
                            title: "<spring:message code="username"/>",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {
                            name: "nationalCode",
                            title: "<spring:message code="national.code"/>",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        }
                    ],
                }
            },
        ]
    });

    let Section_Stack_Non_Used_posts = isc.SectionStack.create({
        width: "100%",
        height: "100%",
        border: "1px solid green",
        sections: [{
            title: "پست های انتخاب نشده",
            expanded: true,
            canCollapse: false,
            align: "center",
            items: [ListGrid_Non_Used_Post_OperationalRole]
        }]
    });

    let Section_Stack_Used_Posts = isc.SectionStack.create({
        width: "100%",
        height: "100%",
        border: "1px solid red",
        sections: [{
        title: "پست های انتخاب شده",
        expanded: true,
        canCollapse: false,
        align: "center",
        items: [ ListGrid_Post_OperationalRole]
        }]
    });

    var IButton_Save_JspOperationalRole = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspOperationalRole.validate())
                return;
            if (!DynamicForm_JspOperationalRole.valuesHaveChanged()) {
                Window_JspOperationalRole.close();
                return;
            }

            let data = DynamicForm_JspOperationalRole.getValues();

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlOperationalRole,
                methodOperationalRole,
                JSON.stringify(data),
                OperationalRole_save_result));
        }
    });
    var IButton_Show_Selected_Posts_JspOperationalRole = isc.ToolStripButton.create({
        title: "لیست پست های انتخاب شده",
        top: 260,
        click: function () {
            ListGrid_Post_OperationalRole.invalidateCache();
            // PostDS_just_Show_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/roleUsedPostList/" + DynamicForm_JspOperationalRole.getField("id").getValue();
            // PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + 0;

            ListGrid_Post_OperationalRole.fetchData();
            Window_show_Operational_Role_Post.show();
        }
    });

    let IButton_Remove_IndividualPost = isc.ToolStripButtonRemove.create({
        width:"10%",
        height:30,
        title: "<spring:message code="global.form.remove"/>",
        click: function () {
            deletePostFromOperationalRole();
        }
    })

    let IButton_Add_Individual_Post = isc.ToolStripButtonAdd.create({
        width:"10%",
        height:30,
        title:"افزودن",
        click: function () {
            addPostToOperationalRole();
            refreshLG(ListGrid_Post_OperationalRole);
        }
    });
    let IButton_DownLoad_Excel_Post = isc.ToolStripButton.create({
        title: "دریافت فایل خام اکسل",
        width: "10%",
        height: 30,
        click: function () {
            window.open("excel/operationalRole-post-input.xlsx");
        }
    });
    let IButton_Upload_Excel_Post = isc.ToolStripButtonAdd.create({
        title: "افزودن لیست پست ها",
        width: "10%",
        height: 30,
        click: function () {
            uploadExcelFile();
        }
    });

    let ToolStrip_Actions_Post_JspOperationalRole = isc.ToolStrip.create({
        width: "35%",
        membersMargin: 5,
        align: "center",
        members:
            [
                IButton_Add_Individual_Post,
                IButton_DownLoad_Excel_Post,
                IButton_Upload_Excel_Post
            ]
    });

    let Spacer_Top = isc.LayoutSpacer.create({height: 5});
    let Spacer_Bottom = isc.LayoutSpacer.create({height: 35});

    var Window_show_Operational_Role_Post = isc.Window.create({
        title: "لیست پست ها",
        align: "center",
        placement: "fillScreen",
        border: "1px solid gray",
        closeClick: function () {
            refreshLG(ListGrid_Non_Used_Post_OperationalRole);
            refreshLG(ListGrid_Post_OperationalRole);
            this.close();
        },
        items: [isc.TrVLayout.create({
            members: [
                // ListGrid_Post_OperationalRole , HLayout_AddOrRemove_IndividualPost
                Section_Stack_Non_Used_posts, Spacer_Top,
                ToolStrip_Actions_Post_JspOperationalRole,
                Spacer_Bottom, Section_Stack_Used_Posts,
                Spacer_Top,
                IButton_Remove_IndividualPost,
                Spacer_Bottom
            ]
        })]
    });

    var IButton_Cancel_JspOperationalRole = isc.IButtonCancel.create({
        click: function () {
            DynamicForm_JspOperationalRole.clearValues();
            Window_JspOperationalRole.close();
        }
    });

    var HLayout_SaveOrExit_JspOperationalRole = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspOperationalRole, IButton_Cancel_JspOperationalRole, IButton_Show_Selected_Posts_JspOperationalRole]
    });

    var Window_JspOperationalRole = isc.Window.create({
        width: "800",
        minWidth: "600",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code="operational.role"/>",
        items: [isc.TrVLayout.create({
            members: [
                DynamicForm_JspOperationalRole,
                HLayout_SaveOrExit_JspOperationalRole
            ]
        })]
    });

    var DynamicForm_departmentFilter_Filter = isc.DynamicForm.create({
        width: "600",
        height: 30,
        numCols: 6,
        colWidths: ["2%", "28%", "2%", "68%"],
        fields: [
            {
                name: "departmentFilter",
                title: "<spring:message code='complex'/>",
                width: "300",
                height: 30,
                optionDataSource: RestDataSource_OperationalRole_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {
                    load_roles_by_department(value);
                },
            },
        ]
    });


    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Refresh_JspOperationalRole = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(ListGrid_JspOperationalRole);
        }
    });

    var ToolStripButton_Edit_JspOperationalRole = isc.ToolStripButtonEdit.create({
        click: function () {
            let record = ListGrid_JspOperationalRole.getSelectedRecord();
            selected_record = record;
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {
                PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + record.id;
                ListGrid_OperationalRole_Edit(selected_record);
            }
        }
    });
    var ToolStripButton_Add_JspOperationalRole = isc.ToolStripButtonCreate.create({
        click: function () {
            PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + 0;
            ListGrid_OperationalRole_Add();
        }
    });
    var ToolStripButton_Remove_JspOperationalRole = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_OperationalRole_Remove();
        }
    });

    var ToolStrip_Actions_JspOperationalRole = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspOperationalRole,
                ToolStripButton_Edit_JspOperationalRole,
                ToolStripButton_Remove_JspOperationalRole,
                DynamicForm_departmentFilter_Filter,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspOperationalRole
                    ]
                })
            ]
    });

    var VLayout_Body_JspOperationalRole = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspOperationalRole,
            ListGrid_JspOperationalRole,
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_OperationalRole_Add() {
        methodOperationalRole = "POST";
        // IButton_Show_Selected_Posts_JspOperationalRole.disable();
        IButton_Show_Selected_Posts_JspOperationalRole.hide();
        // ListGrid_Post_OperationalRole.invalidateCache();
        // PostDS_OperationalRole.fetchDataURL = viewPostUrl + "/rolePostList/";
        saveActionUrlOperationalRole = operationalRoleUrl;
        DynamicForm_JspOperationalRole.clearValues();
        Window_JspOperationalRole.show();
    }

    function ListGrid_OperationalRole_Edit(record) {
        // ListGrid_Post_OperationalRole.invalidateCache();
        IButton_Show_Selected_Posts_JspOperationalRole.show();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            PostDS_just_Show_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/roleUsedPostList/" + record.id;
            methodOperationalRole = "PUT";
            // PostDS_OperationalRole.fetchDataURL = viewPostUrl + "/iscList";
            saveActionUrlOperationalRole = operationalRoleUrl + "/" + record.id;
            DynamicForm_JspOperationalRole.clearValues();
            DynamicForm_JspOperationalRole.editRecord(record);
            var categoryIds = selected_record.categories;
            var subCategoryIds = selected_record.subCategories;
            if (categoryIds === null || categoryIds.length === 0)
                DynamicForm_JspOperationalRole.getField("subCategories").disable();
            else {
                DynamicForm_JspOperationalRole.getField("subCategories").enable();
                var catIds = [];
                for (let i = 0; i < categoryIds.length; i++)
                    catIds.add(categoryIds[i].id);
                DynamicForm_JspOperationalRole.getField("categories").setValue(catIds);
                hasRoleCategoriesChanged = true;
                DynamicForm_JspOperationalRole.getField("subCategories").focus(null, null);
            }
            if (subCategoryIds != null && subCategoryIds.length > 0) {
                var subCatIds = [];
                for (let i = 0; i < subCategoryIds.length; i++)
                    subCatIds.add(subCategoryIds[i].id);
                DynamicForm_JspOperationalRole.getField("subCategories").setValue(subCatIds);
            }

            DynamicForm_JspOperationalRole.getField("objectType").setValue(selected_record.objectType);

            Window_JspOperationalRole.show();
        }
    }

    function OperationalRole_save_result(resp) {
        wait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshLG(ListGrid_JspOperationalRole);
            Window_JspOperationalRole.close();
            createDialog("info", "<spring:message code="global.form.request.successful"/>");
        } else {
            if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function ListGrid_OperationalRole_Remove() {
        let recordIds = ListGrid_JspOperationalRole.getSelectedRecords().map(r => r.id);
        if (recordIds == null || recordIds.length === 0) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait_Permission = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(operationalRoleUrl + "/" + recordIds,
                            "DELETE",
                            null,
                            OperationalRole_remove_result));
                    }
                }
            });
        }
    }

    function OperationalRole_remove_result(resp) {
        wait_Permission.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshLG(ListGrid_JspOperationalRole);
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function load_roles_by_department(value) {
        if (value !== undefined) {
            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {
                        fieldName: "complexId", operator: "inSet", value: value
                    }
                ]
            };
            RestDataSource_JspOperationalRole.fetchDataURL = operationalRoleUrl + "/spec-list";
            departmentCriteria = criteria;
            let mainCriteria = createMainCriteriaInRoles();
            ListGrid_JspOperationalRole.invalidateCache();
            ListGrid_JspOperationalRole.fetchData(mainCriteria);
        } else {
            createDialog("info", "<spring:message code="msg.select.complex.ask"/>", "<spring:message code="message"/>")
        }

    }

    function createMainCriteriaInRoles() {
        let mainCriteria = {};
        mainCriteria._constructor = "AdvancedCriteria";
        mainCriteria.operator = "and";
        mainCriteria.criteria = [];
        mainCriteria.criteria.add(departmentCriteria);
        return mainCriteria;
    }

    function addPostToOperationalRole() {
        let selectedOperationalRoleId = ListGrid_JspOperationalRole.getSelectedRecord().id
        let selectedRecords = ListGrid_Non_Used_Post_OperationalRole.getSelectedRecords()
        let postIds = []
        if (selectedRecords.length === 0) {
            createDialog("info", "<spring:message code="msg.no.records.selected"/>");
            return;
        }
        for (let i = 0; i < selectedRecords.length; i++) {
            postIds.push(selectedRecords[i].id)
        }
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(addIndividualPost + "/" + selectedOperationalRoleId, "POST", JSON.stringify(postIds), function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                window.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                refreshLG(ListGrid_Post_OperationalRole);
            } else {
                window.close();
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }));
    }

    function uploadExcelFile() {

        let HLayout_Upload_Excel_Post = isc.HLayout.create({
            width: "100%",
            members: [
                isc.DynamicForm.create({
                    width: "100%",
                    fields: [
                        {
                            ID:"postCodesExcelFile",
                            name: "postCodesExcelFile",
                            type: "file",
                            title: "",
                            endRow: false
                        },
                        {
                            name: "import",
                            title: "وارد کردن کد پست ها",
                            type: "ButtonItem",
                            startRow: false,
                            click:function () {
                                addPostsFromExcelToOperationalRole(Window_Upload_Excel_Post);
                            }
                        }
                    ]
                })
            ]
        });
        let Window_Upload_Excel_Post = isc.Window.create({
            title: "انتخاب فایل",
            align: "center",
            width: "15%",
            height: "10%",
            isModal: true,
            showModalMask: true,
            dismissOnEscape: true,
            closeClick: function () {
                this.destroy()
            },
            items: [
                HLayout_Upload_Excel_Post
            ]
        });
        Window_Upload_Excel_Post.show();
    }

    function addPostsFromExcelToOperationalRole(window) {

        window.close();
        let selectedOperationalRoleId = ListGrid_JspOperationalRole.getSelectedRecord().id;
        let address = postCodesExcelFile.getValue();
        if (address == null) {
            createDialog("info", "فايل خود را انتخاب نماييد.");
        } else {
            let ExcelToJSON = function () {

                this.parseExcel = function (file) {
                    let reader = new FileReader();
                    let records = [];

                    reader.onload = function (e) {
                        let data = e.target.result;
                        let workbook = XLSX.read(data, {
                            type: 'binary'
                        });
                        workbook.SheetNames.forEach(function (sheetName) {

                            let XL_row_object = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
                            for (let i = 0; i < XL_row_object.length; i++) {

                                let current = {
                                    postCode: XL_row_object[i]["کد پست"]
                                };
                                records.add(current);
                            }
                            postCodesExcelFile.setValue('');
                        });

                        if (records.length > 0) {
                            wait.show();
                            isc.RPCManager.sendRequest(TrDSRequest(viewTrainingPostUrl + "/addPostCodes/" + selectedOperationalRoleId, "POST", JSON.stringify(records.map(item => item.postCode)), function (resp) {
                                wait.close();
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    let result = JSON.parse(resp.httpResponseText);
                                    refreshLG(ListGrid_Post_OperationalRole);
                                    if (result.size() !== 0)
                                        showReturnPostCodes(result);
                                } else {
                                    createDialog("info", "<spring:message code="msg.operation.error"/>");
                                }
                            }));
                        } else {
                            createDialog("info", "پست جدیدی برای اضافه کردن وجود ندارد.");
                        }
                    };
                    reader.onerror = function (ex) {
                        createDialog("info", "خطا در باز کردن فایل");
                    };
                    reader.readAsBinaryString(file);
                };
            };

            let split = $('[name = "postCodesExcelFile"]')[0].files[0].name.split('.');
            if (split[split.length - 1] === 'xls' || split[split.length - 1] === 'csv' || split[split.length - 1] === 'xlsx') {
                let xl2json = new ExcelToJSON();
                xl2json.parseExcel($('[name="postCodesExcelFile"]')[0].files[0]);
            } else {
                createDialog("info", "فایل انتخابی نادرست است. پسوندهای فایل مورد تایید xlsx,xls,csv هستند.");
            }
        }
    }

    function showReturnPostCodes(result) {

        let RestDataSource_Return_Post_Codes = isc.TrDS.create({
            fields: [
                {name: "code", title: "کد پست", filterOperator: "iContains"},
            ]
        });

        let ListGrid_Return_Post_Codes = isc.ListGrid.create({
            width: "100%",
            height: "350",
            autoFetchData: false,
            showRowNumbers: true,
            showFilterEditor: false,
            selectCellTextOnClick: true,
            dataSource: RestDataSource_Return_Post_Codes,
            fields: [
                {
                    name: "code",
                    width: "10%",
                    align: "center"
                }
            ]
        });

        let Window_Return_Post_Codes = isc.Window.create({
            width: "20%",
            height: "300",
            title: "لیست کدپست هایی که اضافه نشده اند",
            items: [
                ListGrid_Return_Post_Codes,
                isc.MyHLayoutButtons.create({
                    members: [
                        isc.IButtonCancel.create({
                            title: "<spring:message code="close"/>",
                            click: function () {
                                Window_Return_Post_Codes.close();
                            }
                        })
                    ]
                })
            ]
        });

        ListGrid_Return_Post_Codes.setData(result);
        Window_Return_Post_Codes.show();
    }

    function deletePostFromOperationalRole() {
        let selectedOperationalRoleId = ListGrid_JspOperationalRole.getSelectedRecord().id
        let selectedRecords = ListGrid_Post_OperationalRole.getSelectedRecords()
        let postIds = []
        if (selectedRecords.length === 0) {
            createDialog("info", "<spring:message code="msg.no.records.selected"/>");
            return;
        }
        for (let i = 0; i < selectedRecords.length; i++) {
            postIds.push(selectedRecords[i].id)
        }
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(deleteIndividualPost + "/" + selectedOperationalRoleId, "POST", JSON.stringify(postIds), function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                window.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                refreshLG(ListGrid_Post_OperationalRole);
            } else {
                window.close();
                createDialog("info", "<spring:message code="delete.was.not.successful"/>");
            }
        }));

        let selectedNonUsedPosts = ListGrid_Non_Used_Post_OperationalRole.getSelectedRecords();
        for(let i = 0; i < selectedNonUsedPosts.length; i++) {
            for(let j = 0; j < selectedRecords.length; j++) {
                if (selectedNonUsedPosts[i].id === selectedRecords[j].id) {
                    ListGrid_Non_Used_Post_OperationalRole.deselectRecord(selectedNonUsedPosts[i]);
                    break;
                }
            }
        }

    }

//</script>