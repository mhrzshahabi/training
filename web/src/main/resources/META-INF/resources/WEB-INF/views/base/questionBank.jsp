<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="sprig" uri="http://java.sun.com/jsp/jstl/fmt" %>

// <script>

    let questionBankMethod_questionBank;
    let forceToCloseWindow=true;
    let oLoadAttachments_questionBank;
    // ------------------------------------------- Menu -------------------------------------------
    QuestionBankMenu_questionBank = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    refresh_questionBank();
                }
            },
            {
                title: "<spring:message code="create"/>",
                icon: "<spring:url value="create.png"/>",
                click: function () {
                    showNewForm_questionBank();
                }
            },
            {
                title: "<spring:message code="edit"/>",
                icon: "<spring:url value="edit.png"/>",
                click: function () {
                    showEditForm_questionBank();
                }
            },
            {
                title: "<spring:message code="remove"/>",
                icon: "<spring:url value="remove.png"/>",
                click: function () {
                    showRemoveForm_questionBank();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------

    QuestionBankTS_questionBank = isc.ToolStrip.create({
        members: [
            isc.ToolStripButtonAdd.create({
                click: function () {
                    showNewForm_questionBank();
                }
            }),
            isc.ToolStripButtonEdit.create({
                click: function () {
                    showEditForm_questionBank();
                }
            }),
            isc.ToolStripButtonRemove.create({
                click: function () {
                    showRemoveForm_questionBank();
                }
            }),

            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = QuestionBankLG_questionBank.getCriteria();
                    ExportToFile.downloadExcel(null, QuestionBankLG_questionBank, "questionBank", 0, null, '', "بانک سوالات", criteria, null);
                }
            }),

            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStripButtonRefresh.create({
                click: function () {
                    refresh_questionBank();
                }
            }),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    QuestionBankDS_questionBank = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "question",
                title: "<spring:message code="question.bank.question"/>",
                filterOperator: "iContains"
            },
            {
                name: "questionType.title",
                title: "<spring:message code="question.bank.question.type"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "displayType.title",
                title: "<spring:message code="question.bank.display.type"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "category.titleFa",
                title: "<spring:message code="category"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "subCategory.titleFa",
                title: "<spring:message code="subcategory"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "teacher.fullNameFa",
                title: "<spring:message code="teacher"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "tclass.course.titleFa",
                title: "<spring:message code="class"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "tclass.code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "tclass.startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "tclass.endDate",
                title: "<spring:message code='end.date'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "course.titleFa",
                title: "<spring:message code="course"/>",
                filterOperator: "iContains", autoFitWidth: true
            }

        ],
        fetchDataURL: questionBankUrl + "/spec-list"
    });

    var RestDataSource_category = isc.TrDS.create({
        ID: "categoryDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });

    var RestDataSourceSubCategory = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "code"}
        ],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    AnswerTypeDS_questionBank = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        //autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/AnswerType"
    });

    DisplayTypeDS_questionBank = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        //autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/DisplayType"
    });

    CourseDS_questionBank = isc.TrDS.create({
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "categoryId"},
            {name: "subCategory.titleFa"},
            {name: "erunType.titleFa"},
            {name: "elevelType.titleFa"},
            {name: "etheoType.titleFa"},
            {name: "theoryDuration"},
            {name: "etechnicalType.titleFa"},
            {name: "minTeacherDegree"},
            {name: "minTeacherExpYears"},
            {name: "minTeacherEvalScore"},
            // {name: "know   ledge"},
            // {name: "skill"},
            // {name: "attitude"},
            {name: "needText"},
            {name: "description"},
            {name: "workflowStatus"},
            {name: "workflowStatusCode"},
            {name: "hasGoal"},
            {name: "hasSkill"},
            {
                name: "evaluation",
            },
            {
                name: "behavioralLevel",
            }
            // {name: "version"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });

    EQuestionLevelDS_questionBank = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eQuestionLevel/spec-list"
    });
    questionTargetDS_questionBank = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/questionTarget"
    });

    ClassDS_questionBank = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
            {name: "titleClass"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "studentCount", canFilter: false, canSort: false},
            {name: "code"},
            {name: "term.titleFa"},
            {name: "course.titleFa"},
            {name: "course.id"},
            {name: "teacherId"},
            {
                name: "teacher",
            },
            {
                name: "teacher.personality.lastNameFa",
            },
            {name: "reason"},
            {name: "classStatus"},
            {name: "topology"},
            {name: "trainingPlaceIds"},
            {name: "instituteId"},
            {name: "workflowEndingStatusCode"},
            {name: "workflowEndingStatus"},
            {name: "preCourseTest", type: "boolean"},
            {name: "course.code"},
            {name: "course.theoryDuration"},
            {name: "scoringMethod"}
        ],
        fetchDataURL: classUrl + "spec-list"
    });

    TeacherDS_questionBank = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.id"},
            {name: "teacherCode"},
            {name: "personnelCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.educationLevel.titleFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personality.contactInfo.mobile"},
            {name: "categories"/*, filterOperator: "inSet"*/},
            {name: "subCategories"/*, filterOperator: "inSet"*/},
            {name: "personality.contactInfo.homeAddress.id"},
            {name: "personality.contactInfo.workAddress.id"},
            {name: "personality.accountInfo.id"},
            {name: "personality.educationLevelId"}
        ],
        fetchDataURL: teacherUrl + "spec-list"
    });


    QuestionBankLG_questionBank = isc.TrLG.create({
        dataSource: QuestionBankDS_questionBank,
        fields: [
            {name: "code",
                sortNormalizer: function (record) {
                    return parseInt(record.code);
                }
            },
            {name: "question",},
            {name: "displayType.id",
                optionDataSource: DisplayTypeDS_questionBank,
                title: "<spring:message code="question.bank.display.type"/>",
                editorType: "SelectItem",
                valueField: "id",
                displayField: "title",
                filterOnKeypress: true,
                filterEditorProperties:{
                optionDataSource: DisplayTypeDS_questionBank,
                valueField: "id",
                displayField: "title",
                autoFetchData: true,
                filterFields: ["id","title"],
                textMatchStyle: "substring",
                generateExactMatchCriteria: true,
                pickListProperties: {
                showFilterEditor: false,
                autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {name: "title"}
                    ]
                },
                sortNormalizer: function (record) {
                    return record.displayType?.title;
                }
            },
            {name: "questionType.id",
                optionDataSource: AnswerTypeDS_questionBank,
                title: "<spring:message code="question.bank.question.type"/>",
                editorType: "SelectItem",
                valueField: "id",
                displayField: "title",
                filterOnKeypress: true,
                filterEditorProperties:{
                optionDataSource: AnswerTypeDS_questionBank,
                valueField: "id",
                displayField: "title",
                autoFetchData: true,
                filterFields: ["id","title"],
                textMatchStyle: "substring",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {name: "title"}
                ]
                },
                sortNormalizer: function (record) {
                    return record.questionType?.title;
                }
            },
            {
                name: "category.id",
                optionDataSource: RestDataSource_category,
                title: "<spring:message code="category"/>",
                editorType: "SelectItem",
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                filterEditorProperties:{
                    optionDataSource: RestDataSource_category,
                    valueField: "id",
                    displayField: "titleFa",
                    autoFetchData: true,
                    filterFields: ["id","titleFa"],
                    textMatchStyle: "substring",
                    generateExactMatchCriteria: true,
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    },
                    pickListFields: [
                        {name: "titleFa"}
                    ]
                },
                sortNormalizer: function (record) {
                    return record.category?.titleFa;
                }
            },
            {
                name: "subCategory.id",
                optionDataSource: RestDataSourceSubCategory,
                title: "<spring:message code="subcategory"/>",
                editorType: "SelectItem",
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                filterEditorProperties:{
                    optionDataSource: RestDataSourceSubCategory,
                    valueField: "id",
                    displayField: "titleFa",
                    autoFetchData: true,
                    filterFields: ["id","titleFa"],
                    textMatchStyle: "substring",
                    generateExactMatchCriteria: true,
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    },
                    pickListFields: [
                        {name: "titleFa"}
                    ]
                },
                sortNormalizer: function (record) {
                    return record.subCategory?.titleFa;
                }
            },
            {name: "teacher.fullNameFa",canFilter: false,canSort: false},
            {name: "course.titleFa",sortNormalizer: function (record) {let tmp=record.course?.titleFa; tmp=(typeof(tmp)=="undefined")?"":tmp; return tmp; }},
            {name: "tclass.course.titleFa",sortNormalizer: function (record) {let tmp=record.tclass?.course?.titleFa; tmp=(typeof(tmp)=="undefined")?"":tmp; return tmp; }},
            {name: "tclass.code",sortNormalizer: function (record) { return record.tclass?.code; }},
            {name: "tclass.startDate",sortNormalizer: function (record) { return record.tclass?.startDate; }},
            {name: "tclass.endDate",sortNormalizer: function (record) { return record.tclass?.endDate; }},
        ],
        autoFetchData: true,
        gridComponents: [QuestionBankTS_questionBank, "filterEditor", "header", "body",],
        contextMenu: QuestionBankMenu_questionBank,
        sortField: "id",
        filterOperator: "iContains",
        filterOnKeypress: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionUpdated: function (record) {
            loadAttachment();

        },
        doubleClick: function () {
            showEditForm_questionBank();
        },
        filterEditorSubmit: function () {
            QuestionBankLG_questionBank.invalidateCache();
        },
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    let QuestionBankDF_questionBank = isc.DynamicForm.create({
        ID: "QuestionBankDF_questionBank",
        //width: 780,
        overflow: "hidden",
        //autoSize: false,
        wrapItemTitles: true,
        numCols: 4,
        colWidths: ["10%", "25%", "10%", "25%"],
        fields: [
            {name: "id", hidden: true},
            {
                name: "code", title: "<spring:message code="code"/>",
                type: "staticText",
                width: "100%",
                colSpan: 4,
                startRow: true,
            },
            {
                name: "question", title: "<spring:message code="question.bank.question"/>",
                required: true,
                type: "TextAreaItem",
                height: 100,
                width: "100%",
                length: 1000,
                colSpan: 4,
                startRow: true,
                wrap: "OFF",
            },
            {
                name: "categoryId",
                title: "<spring:message code="category"/>",
                textAlign: "center",
                width: "*",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_category,
                filterFields: ["titleFa"],
                pickListProperties: {
                    showFilterEditor: false
                },
                sortField: ["id"],
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
                            QuestionBankDF_questionBank.getItem("subCategoryId").disable();
                            QuestionBankDF_questionBank.getItem("subCategoryId").setValue();

                            QuestionBankDF_questionBank.getItem("courseId").disable();
                            QuestionBankDF_questionBank.getItem("courseId").setValue();

                            QuestionBankDF_questionBank.getItem("tclassId").disable();
                            QuestionBankDF_questionBank.getItem("tclassId").setValue();
                        }
                    }
                ],
                changed: function (form, item, value) {
                    if (!value) {
                        QuestionBankDF_questionBank.getItem("subCategoryId").setValue();
                        QuestionBankDF_questionBank.getItem("subCategoryId").disable();
                        return;
                    }

                    QuestionBankDF_questionBank.getItem("subCategoryId").enable();
                    QuestionBankDF_questionBank.getItem("subCategoryId").setValue();
                    RestDataSourceSubCategory.fetchDataURL = categoryUrl + value + "/sub-categories";
                    QuestionBankDF_questionBank.getItem("subCategoryId").fetchData();

                    QuestionBankDF_questionBank.getItem("courseId").setValue();
                    QuestionBankDF_questionBank.getItem("courseId").disable();

                    QuestionBankDF_questionBank.getItem("tclassId").setValue();
                    QuestionBankDF_questionBank.getItem("tclassId").disable();
                },
                click: function (form, item) {
                    item.fetchData();
                }
            },
            {
                name: "subCategoryId",
                title: "<spring:message code="subcategory"/>",
                prompt: "<spring:message code="first.select.group"/>",
                textAlign: "center",
                autoFetchData: false,
                width: "*",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSourceSubCategory,
                filterFields: ["titleFa"],
                sortField: ["id"],
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

                            QuestionBankDF_questionBank.getItem("courseId").disable();
                            QuestionBankDF_questionBank.getItem("courseId").setValue();

                            QuestionBankDF_questionBank.getItem("tclassId").disable();
                            QuestionBankDF_questionBank.getItem("tclassId").setValue();

                        }
                    }
                ],
                endRow: true,
                startRow: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    if (!value) {
                        QuestionBankDF_questionBank.getItem("courseId").disable();
                        return;
                    }

                    QuestionBankDF_questionBank.getItem("courseId").enable();
                    QuestionBankDF_questionBank.getItem("courseId").setValue();
                    CourseDS_questionBank.implicitCriteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [{fieldName: "subCategoryId", operator: "equals", value: value}]
                    };
                    QuestionBankDF_questionBank.getItem("courseId").fetchData();

                    QuestionBankDF_questionBank.getItem("tclassId").setValue();
                    QuestionBankDF_questionBank.getItem("tclassId").disable();
                }
            },
            {
                name: "courseId",
                title: "<spring:message code="course"/>",
                prompt: "<spring:message code="first.select.sub.group"/>",
                textAlign: "center",
                autoFetchData: false,
                width: "*",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: CourseDS_questionBank,
                filterFields: ["titleFa"],
                sortField: ["id"],
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
                            QuestionBankDF_questionBank.getItem("tclassId").disable();
                            QuestionBankDF_questionBank.getItem("tclassId").setValue();

                        }
                    }
                ],
                endRow: false,
                startRow: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                changed: function (form, item, value) {
                    if (!value) {
                        QuestionBankDF_questionBank.getItem("tclassId").disable();
                        return;
                    }

                    QuestionBankDF_questionBank.getItem("tclassId").enable();
                    QuestionBankDF_questionBank.getItem("tclassId").setValue();
                    ClassDS_questionBank.implicitCriteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [{fieldName: "courseId", operator: "equals", value: value}]
                    };
                    QuestionBankDF_questionBank.getItem("tclassId").fetchData()
                }
            },
            {
                name: "tclassId",
                title: "<spring:message code="class"/>",
                prompt: "<spring:message code="first.select.course"/>",
                textAlign: "center",
                autoFetchData: false,
                width: "*",
                displayField: "code",
                valueField: "id",
                optionDataSource: ClassDS_questionBank,
                sortField: ["id"],
                filterFields: ["id"],
                //type: "ComboBoxItem",
                pickListFields: [
                    {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "course.titleFa",
                        title: "<spring:message code='course.title'/>",
                        align: "center",
                        filterOperator: "iContains",
                        sortNormalizer: function (record) {
                            return record.course.titleFa;
                        }
                    },
                    {
                        name: "term.titleFa",
                        title: "term",
                        align: "center",
                        filterOperator: "iContains",
                        hidden: true
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        autoFitWidth: true
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        autoFitWidth: true
                    },
                    {
                        name: "teacher",
                        title: "<spring:message code='teacher'/>",
                        displayField: "teacher.personality.lastNameFa",
                        displayValueFromRecord: false,
                        type: "TextItem",
                        sortNormalizer(record) {
                            return record.teacher.personality.lastNameFa;
                        },

                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        // sortNormalizer(record) {
                        //     return record.teacher.personality.lastNameFa;
                        // }
                    },
                    {
                        name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                        valueMap: {
                            "1": "برنامه ریزی",
                            "2": "در حال اجرا",
                            "3": "پایان یافته",
                        },
                        filterEditorProperties: {
                            pickListProperties: {
                                showFilterEditor: false
                            },
                        },
                        filterOnKeypress: true,
                        autoFitWidth: true,
                    },
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListWidth: 800,
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
                endRow: true,
                startRow: false,

                changed: function (form, item, value) {
                    //DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                }
            },
            {
                name: "teacherId",
                title: "<spring:message code="teacher"/>",
                textAlign: "center",
                autoFetchData: false,
                colSpan: 4,
                width: "100%",
                displayField: "fullName",
                valueField: "id",
                optionDataSource: TeacherDS_questionBank,
                sortField: ["id"],
                filterFields: ["id"],
                //type: "ComboBoxItem",
                pickListFields: [
                    {name: "id", title: "id", canEdit: false, hidden: true, filterOperator: "equals"},
                    {
                        name: "teacherCode",
                        title: "<spring:message code='national.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {
                        name: "personality.firstNameFa",
                        title: "<spring:message code='firstName'/>",
                        align: "center",
                        filterOperator: "iContains",

                        sortNormalizer: function (record) {
                            return record.personality.firstNameFa;
                        }
                    },
                    {
                        name: "personality.lastNameFa",
                        title: "<spring:message code='lastName'/>",
                        align: "center",
                        filterOperator: "iContains",

                        sortNormalizer: function (record) {
                            return record.personality.lastNameFa;
                        }
                    },
                    {
                        name: "personnelCode",
                        title: "<spring:message code='personnel.code.six.digit'/>",
                        align: "center",
                        filterOperator: "iContains",

                    },
                    {
                        name: "personality.educationLevel.titleFa",
                        title: "<spring:message code='education.level'/>",
                        align: "center",
                        filterOperator: "equals",
                        sortNormalizer: function (record) {
                            return record.personality.educationLevel.titleFa;
                        }
                    },
                    {
                        name: "personality.educationMajor.titleFa",
                        title: "<spring:message code='education.major'/>",
                        align: "center",
                        filterOperator: "equals",
                        sortNormalizer: function (record) {
                            return record.personality.educationMajor.titleFa;
                        }
                    },
                    {
                        name: "personality.contactInfo.mobile",
                        title: "<spring:message code='mobile.connection'/>",
                        align: "center",
                        type: "phoneNumber",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        },
                        sortNormalizer: function (record) {
                            return record.personality.contactInfo.mobile;
                        }
                    },
                    {
                        name: "enableStatus",
                        title: "<spring:message code='status'/>",
                        align: "center",
                        type: "boolean"
                    }
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListWidth: 800,
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
                startRow: true,
                changed: function (form, item, value) {
                    //DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                }
            },
            {
                type: "BlurbItem",
                value: " ",
                colSpan: 4,
            },
            {
                name: "questionTypeId",
                //editorType: "ComboBoxItem",
                title: "<spring:message code="question.bank.question.type"/>",
                textAlign: "center",
                required: true,
                width: "*",
                displayField: "title",
                valueField: "id",
                optionDataSource: AnswerTypeDS_questionBank,
                filterFields: ["title"],
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", title: "<spring:message code="title"/>"}
                ],
                sortField: ["id"],
                changed: function (form, item, value) {
                    if (value == 520) {
                        QuestionBankDF_questionBank.getItem("displayTypeId").enable();

                        QuestionBankDF_questionBank.getItem("option1").enable();
                        QuestionBankDF_questionBank.getItem("option2").enable();
                        QuestionBankDF_questionBank.getItem("option3").enable();
                        QuestionBankDF_questionBank.getItem("option4").enable();

                        QuestionBankDF_questionBank.getItem("descriptiveAnswer").disable();
                        QuestionBankDF_questionBank.getItem("lines").disable();
                        QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").enable();

                        QuestionBankDF_questionBank.getItem("hasAttachment").disable();
                        //QuestionBankDF_questionBank.getItem("option1").setRequired(true);
                        //QuestionBankDF_questionBank.getItem("option2").setRequired(true);
                        QuestionBankDF_questionBank.getItem("displayTypeId").setRequired(true);
                        //QuestionBankDF_questionBank.redraw();

                    } else {
                        QuestionBankDF_questionBank.getItem("displayTypeId").disable();

                        //QuestionBankDF_questionBank.getItem("option1").setRequired(false);
                        //QuestionBankDF_questionBank.getItem("option2").setRequired(false);
                        QuestionBankDF_questionBank.getItem("displayTypeId").setRequired(false);
                         QuestionBankDF_questionBank.getItem("hasAttachment").enable();

                        QuestionBankDF_questionBank.getItem("option1").disable();
                        QuestionBankDF_questionBank.getItem("option2").disable();
                        QuestionBankDF_questionBank.getItem("option3").disable();
                        QuestionBankDF_questionBank.getItem("option4").disable();


                        QuestionBankDF_questionBank.getItem("descriptiveAnswer").enable();
                        QuestionBankDF_questionBank.getItem("lines").enable();
                        QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").disable();


                        //QuestionBankDF_questionBank.redraw();
                    }

                },
                click: function (form, item) {
                    item.fetchData();
                }
            },
            {
                name: "displayTypeId",
                //required: true,
                //editorType: "ComboBoxItem",
                title: "<spring:message code="question.bank.display.type"/>",
                textAlign: "center",
                width: "*",
                displayField: "title",
                valueField: "id",
                optionDataSource: DisplayTypeDS_questionBank,
                filterFields: ["title"],
                endRow: true,
                startRow: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", title: "<spring:message code="title"/>"}
                ],
                sortField: ["id"],
                click: function (form, item) {
                    item.fetchData();
                }
            },
            {
                name: "hasAttachment",
                title: "جواب کاربر نیاز به الصاق فایل دارد",
                type: "checkbox",
                titleOrientation: "left",
                labelAsTitle: true
            },
            {
                name: "eQuestionLevel.id",
                title: "درجه سختی سوال",
                required: true,
                textAlign: "center",
                optionDataSource: EQuestionLevelDS_questionBank,
                valueField: "id",
                displayField: "titleFa",
                sortField: ["id"],
                pickListProperties:{
                    showFilterEditor: false
                }
            },
            {
                name: "questionTargets",
                title: "تعیین هدف سوال",
                required: true,
                type: "SelectItem",
                multiple: true,
                textAlign: "center",
                optionDataSource: questionTargetDS_questionBank,
                valueField: "id",
                displayField: "title",
                sortField: ["id"],
                pickListProperties:{
                    showFilterEditor: false
                }
            },
            {
                name: "lines",
                title: "<spring:message code="question.bank.lines"/>",
                width: "*",
                colSpan: 4,
                defaultValue: "1",
                keyPressFilter: "[0-9]",
                blur: function () {
                    var lines=QuestionBankDF_questionBank.getValue("lines")

                    if(lines && (parseInt(lines)>10||parseInt(lines)<1)){
                        createDialog("info", "<spring:message code="question.bank.lines.validation"/>");
                    }
                },
            },
            {
                type: "BlurbItem",
                value: " ",
                colSpan: 4,
            },
            {
                name: "option1",
                title: "<spring:message code="question.bank.option1"/>",
                //required: true,
                colSpan: 4,
                blur: function () {
                    if (!QuestionBankDF_questionBank.getItem("option1").getValue()) {
                        QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").setValue(1);
                    }
                }
            },
            {
                name: "option2",
                title: "<spring:message code="question.bank.option2"/>",
                //required: true,
                colSpan: 4,
                focus: function () {
                    if (QuestionBankDF_questionBank.getItem("option2").getValue()) {
                        return;
                    }
                    let option1Value = QuestionBankDF_questionBank.getItem("option1").getValue();


                    if (!option1Value) {
                        createDialog("info", "<spring:message code="question.bank.fill.previous.option"/>");
                        QuestionBankDF_questionBank.getItem("option1").focusInItem();
                    }
                },
                blur: function () {
                    if (!QuestionBankDF_questionBank.getItem("option2").getValue()) {
                        QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").setValue(1);
                    }
                    let option1Value = QuestionBankDF_questionBank.getItem("option1").getValue();


                    if (!option1Value && QuestionBankDF_questionBank.getItem("option2").getValue()) {
                        createDialog("info", "<spring:message code="question.bank.fill.previous.option"/>");

                        QuestionBankDF_questionBank.getItem("option2").focusInItem();

                    }
                }
            },
            {
                name: "option3",
                title: "<spring:message code="question.bank.option3"/>",
                colSpan: 4,
                focus: function () {
                    if (QuestionBankDF_questionBank.getItem("option3").getValue()) {
                        return;
                    }
                    let option1Value = QuestionBankDF_questionBank.getItem("option1").getValue();
                    let option1Value2 = QuestionBankDF_questionBank.getItem("option2").getValue();

                    if (!option1Value || !option1Value2) {
                        createDialog("info", "<spring:message code="question.bank.fill.previous.option"/>");
                        if (!option1Value)
                            QuestionBankDF_questionBank.getItem("option1").focusInItem();
                        else
                            QuestionBankDF_questionBank.getItem("option2").focusInItem();
                    }

                },
                blur: function () {
                    if (!QuestionBankDF_questionBank.getItem("option3").getValue()) {
                        QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").setValue(1);
                    }
                    let option1Value = QuestionBankDF_questionBank.getItem("option1").getValue();
                    let option1Value2 = QuestionBankDF_questionBank.getItem("option2").getValue();
                    if ((!option1Value || !option1Value2) && QuestionBankDF_questionBank.getItem("option3").getValue()) {
                        createDialog("info", "<spring:message code="question.bank.fill.previous.options"/>");
                        QuestionBankDF_questionBank.getItem("option3").focusInItem();
                    }
                }
            },
            {
                name: "option4",
                title: "<spring:message code="question.bank.option4"/>",
                colSpan: 4,
                focus: function () {
                    if (QuestionBankDF_questionBank.getItem("option4").getValue()) {
                        return;
                    }
                    let option1Value = QuestionBankDF_questionBank.getItem("option1").getValue();
                    let option1Value2 = QuestionBankDF_questionBank.getItem("option2").getValue();
                    let option1Value3 = QuestionBankDF_questionBank.getItem("option3").getValue();

                    if (!option1Value || !option1Value2 || !option1Value3) {
                        createDialog("info", "<spring:message code="question.bank.fill.previous.option"/>");
                        if (!option1Value)
                            QuestionBankDF_questionBank.getItem("option1").focusInItem();
                        else if (!option1Value2)
                            QuestionBankDF_questionBank.getItem("option2").focusInItem();
                        else if (!option1Value3)
                            QuestionBankDF_questionBank.getItem("option3").focusInItem();

                    }
                },
                blur: function () {
                    if (!QuestionBankDF_questionBank.getItem("option4").getValue()) {
                        QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").setValue(1);
                    }
                    let option1Value = QuestionBankDF_questionBank.getItem("option1").getValue();
                    let option1Value2 = QuestionBankDF_questionBank.getItem("option2").getValue();
                    let option1Value3 = QuestionBankDF_questionBank.getItem("option3").getValue();
                    if ((!option1Value || !option1Value2 || !option1Value3) && QuestionBankDF_questionBank.getItem("option4").getValue()) {
                        createDialog("info", "<spring:message code="question.bank.fill.previous.options"/>");
                        QuestionBankDF_questionBank.getItem("option4").focusInItem();
                    }

                }
            },
            {
                type: "BlurbItem",
                value: " ",
                colSpan: 4,
            },
            {
                name: "descriptiveAnswer",
                title: "<spring:message code="question.bank.descriptive.answer"/>",
                type: "TextAreaItem",
                height: 100,
                width: "100%",
                length: 5000,
                colSpan: 4,
                wrap: "OFF",
            },
            {
                name: "multipleChoiceAnswer",
                title: "<spring:message code='question.bank.multiple.choice.answer'/>:",
                type: "radioGroup",
                vertical: false,
                fillHorizontalSpace: true,
                valueMap: {
                    "1": "<spring:message code="question.bank.option1"/>",
                    "2": "<spring:message code="question.bank.option2"/>",
                    "3": "<spring:message code="question.bank.option3"/>",
                    "4": "<spring:message code="question.bank.option4"/>"
                },
                colSpan: 4,
                changed: function (form, item, value) {

                    if ((!QuestionBankDF_questionBank.getItem("option1").getValue() && value == 1) || (!QuestionBankDF_questionBank.getItem("option2").getValue() && value == 2) || (!QuestionBankDF_questionBank.getItem("option3").getValue() && value == 3) || (!QuestionBankDF_questionBank.getItem("option4").getValue() && value == 4)) {
                        createDialog("info", "<spring:message code='question.bank.option.not.exist'/>");
                        QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").setValue(1);
                    }
                }
            },

        ]
    });

    let QuestionBankWin_questionBank = isc.Window.create({
        width: 800,
        height: 920,
        //autoCenter: true,
        overflow: "hidden",
        showMaximizeButton: false,
        autoSize: false,
        canDragResize: false,
        items: [QuestionBankDF_questionBank, isc.TrHLayoutButtons.create({
            members: [
                isc.TrSaveBtn.create({
                    click: function () {
                        forceToCloseWindow=true;
                        saveQuestionBank_questionBank();
                    }
                }),
                isc.TrCancelBtn.create({
                    click: function () {
                        QuestionBankWin_questionBank.close();
                    }
                }),
                isc.TrSaveNextBtn.create({
ID:"QuestionBankWin_questionBank_TrSaveNextBtn",
                    click: function () {
                        forceToCloseWindow=false;
                        saveQuestionBank_questionBank();
                    }
                }),
            ]
        })]
    });
    // ------------------------------------------- TabSet -------------------------------------------
    var TabSet_questionBank = isc.TabSet.create({
        enabled: false,
        tabBarPosition: "top",
        tabs: [

            {
                ID: "questionBankAttachmentsTab",
                name: "questionBankAttachmentsTab",
                title: "<spring:message code="attachments"/>",
            }
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
        }
    });


    // ------------------------------------------- Page UI -------------------------------------------
    let HLayout_Tab_Class = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "39%",
        members: [TabSet_questionBank]
    });


    isc.TrVLayout.create({
        members: [QuestionBankTS_questionBank, QuestionBankLG_questionBank, HLayout_Tab_Class],
    });

    if (!loadjs.isDefined('load_Attachments')) {
        loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments');
    }

    setTimeout(function () {
        loadjs.ready('load_Attachments', function () {
            oLoadAttachments_questionBank = new loadAttachments();
            TabSet_questionBank.updateTab("questionBankAttachmentsTab", oLoadAttachments_questionBank.VLayout_Body_JspAttachment)
        });
    }, 0);

    // ------------------------------------------- Functions -------------------------------------------
    function refresh_questionBank() {
        if (QuestionBankWin_questionBank.isDrawn() && forceToCloseWindow) {
            QuestionBankWin_questionBank.close();
        }
        QuestionBankLG_questionBank.invalidateCache();
        loadAttachment();
    }

    function showNewForm_questionBank() {
        questionBankMethod_questionBank = "POST";
        QuestionBankDF_questionBank.clearValues();
        QuestionBankWin_questionBank.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="question.bank"/>");

        isc.RPCManager.sendRequest(TrDSRequest(questionBankUrl + "/max", "GET", null, function (resp) {

            wait.close();

            if (generalGetResp(resp)) {
                if (resp.httpResponseCode == 200) {
                    QuestionBankDF_questionBank.getItem("code").setValue(resp.data);
                } else {
                    createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
                }
            }


        }));

        QuestionBankDF_questionBank.getItem("categoryId").enable();
        QuestionBankDF_questionBank.getItem("subCategoryId").disable();
        QuestionBankDF_questionBank.getItem("courseId").disable();
        QuestionBankDF_questionBank.getItem("tclassId").disable();
        QuestionBankDF_questionBank.getItem("teacherId").enable();

        QuestionBankDF_questionBank.getItem("displayTypeId").disable();

        //QuestionBankDF_questionBank.getItem("option1").setRequired(false);
        //QuestionBankDF_questionBank.getItem("option2").setRequired(false);
        QuestionBankDF_questionBank.getItem("displayTypeId").setRequired(false);

        QuestionBankDF_questionBank.clearErrors();

        QuestionBankDF_questionBank.getItem("option1").disable();
        QuestionBankDF_questionBank.getItem("option2").disable();
        QuestionBankDF_questionBank.getItem("option3").disable();
        QuestionBankDF_questionBank.getItem("option4").disable();

        QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").setValue(1);
        QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").disable();
        QuestionBankDF_questionBank.getItem("descriptiveAnswer").enable();
        QuestionBankDF_questionBank.getItem("lines").enable();

        QuestionBankDF_questionBank.getItem("questionTypeId").setValue(519);

        QuestionBankWin_questionBank.show();
QuestionBankWin_questionBank.items[1].members[2].setVisibility(true);

}

    function showEditForm_questionBank() {


        let record = QuestionBankLG_questionBank.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            isc.RPCManager.sendRequest(TrDSRequest(questionBankUrl + "/" + record.id, "GET", null, result_EditQuestionBank));

        }
    }


    function result_EditQuestionBank(resp) {

        wait.close();

        if (generalGetResp(resp)) {
            if (resp.httpResponseCode == 200) {

                let record = JSON.parse(resp.data);

                questionBankMethod_questionBank = "PUT";
                QuestionBankDF_questionBank.clearValues();


                QuestionBankWin_questionBank.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="question.bank"/>" + '&nbsp;\'' + record.question + '\'');

                QuestionBankDF_questionBank.getItem("categoryId").enable();
                QuestionBankDF_questionBank.getItem("subCategoryId").enable();

                QuestionBankDF_questionBank.getItem("courseId").enable();
                QuestionBankDF_questionBank.getItem("tclassId").enable();
                QuestionBankDF_questionBank.getItem("teacherId").enable();

                if (record.categoryId) {
                    RestDataSourceSubCategory.fetchDataURL = categoryUrl + record.categoryId + "/sub-categories";
                    QuestionBankDF_questionBank.getItem("subCategoryId").fetchData();
                } else {
                    QuestionBankDF_questionBank.getItem("subCategoryId").setValue();

                    QuestionBankDF_questionBank.getItem("subCategoryId").disable();
                    QuestionBankDF_questionBank.getItem("courseId").disable();
                    QuestionBankDF_questionBank.getItem("tclassId").disable();
                }

                if (record.subCategoryId) {
                    QuestionBankDF_questionBank.getItem("courseId").setValue();
                    CourseDS_questionBank.implicitCriteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [{fieldName: "subCategoryId", operator: "equals", value: record.subCategoryId}]
                    };
                    QuestionBankDF_questionBank.getItem("courseId").fetchData();
                } else {
                    QuestionBankDF_questionBank.getItem("courseId").setValue();

                    QuestionBankDF_questionBank.getItem("courseId").disable();
                    QuestionBankDF_questionBank.getItem("tclassId").disable();
                }

                if (record.courseId) {
                    QuestionBankDF_questionBank.getItem("tclassId").setValue();
                    ClassDS_questionBank.implicitCriteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [{fieldName: "courseId", operator: "equals", value: record.courseId}]
                    };
                    QuestionBankDF_questionBank.getItem("tclassId").fetchData()
                } else {
                    QuestionBankDF_questionBank.getItem("tclassId").setValue();

                    QuestionBankDF_questionBank.getItem("tclassId").disable();
                }

                QuestionBankDF_questionBank.editRecord(record);
                QuestionBankDF_questionBank.getItem("eQuestionLevel.id").setValue(record.questionLevelId);

                if (record.questionTypeId == 520) {
                    QuestionBankDF_questionBank.getItem("displayTypeId").enable();

                    QuestionBankDF_questionBank.getItem("option1").enable();
                    QuestionBankDF_questionBank.getItem("option2").enable();
                    QuestionBankDF_questionBank.getItem("option3").enable();
                    QuestionBankDF_questionBank.getItem("option4").enable();

                    QuestionBankDF_questionBank.getItem("descriptiveAnswer").disable();
                    QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").enable();

                    //QuestionBankDF_questionBank.getItem("option1").setRequired(true);
                    //QuestionBankDF_questionBank.getItem("option2").setRequired(true);
                    QuestionBankDF_questionBank.getItem("displayTypeId").setRequired(true);
                    QuestionBankDF_questionBank.getItem("lines").disable();
                    //QuestionBankDF_questionBank.redraw();

                } else {
                    QuestionBankDF_questionBank.getItem("displayTypeId").disable();

                    QuestionBankDF_questionBank.getItem("option1").disable();
                    QuestionBankDF_questionBank.getItem("option2").disable();
                    QuestionBankDF_questionBank.getItem("option3").disable();
                    QuestionBankDF_questionBank.getItem("option4").disable();

                    QuestionBankDF_questionBank.getItem("descriptiveAnswer").enable();
                    QuestionBankDF_questionBank.getItem("multipleChoiceAnswer").disable();

                    //QuestionBankDF_questionBank.getItem("option1").setRequired(false);
                    //QuestionBankDF_questionBank.getItem("option2").setRequired(false);
                    QuestionBankDF_questionBank.getItem("displayTypeId").setRequired(false);
                    QuestionBankDF_questionBank.getItem("lines").enable();
                    // QuestionBankDF_questionBank.redraw();
                }


                QuestionBankWin_questionBank.show();
                QuestionBankWin_questionBank.items[1].members[2].setVisibility(false);
            } else {
                createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
            }
        }
    }

    function saveQuestionBank_questionBank() {

        if (!QuestionBankDF_questionBank.validate()) {
            return;
        }
        if(QuestionBankDF_questionBank.getItem("questionTypeId").getValue()==520){

            let option1Value = QuestionBankDF_questionBank.getItem("option1").getValue();
            let option1Value2 = QuestionBankDF_questionBank.getItem("option2").getValue();
            let option1Value3 = QuestionBankDF_questionBank.getItem("option3").getValue();
            let option1Value4 = QuestionBankDF_questionBank.getItem("option4").getValue();

            if (option1Value4) {
                if (!option1Value3 || !option1Value2 || !option1Value) {
                    createDialog("info", "<spring:message code="question.bank.fill.previous.option"/>");
                    if (!option1Value) {
                        QuestionBankDF_questionBank.getItem("option1").focusInItem();
                    } else if (!option1Value2) {
                        QuestionBankDF_questionBank.getItem("option2").focusInItem();
                    } else if (!option1Value3) {
                        QuestionBankDF_questionBank.getItem("option3").focusInItem();
                    }
                    return;
                }

            }

            if (option1Value3) {
                if (!option1Value2 || !option1Value) {
                    createDialog("info", "<spring:message code="question.bank.fill.previous.option"/>");

                    if (!option1Value)
                        QuestionBankDF_questionBank.getItem("option1").focusInItem();
                    else if (!option1Value2)
                        QuestionBankDF_questionBank.getItem("option2").focusInItem();

                    return;
                }

            }

           if (option1Value2) {
                if (!option1Value) {
                    createDialog("info", "<spring:message code="question.bank.fill.previous.option"/>");
                    QuestionBankDF_questionBank.getItem("option1").focusInItem();
                    return;
                }

            }

           if(!option1Value||!option1Value2){
                createDialog("info", "<spring:message code="question.bank.required.options"/>");

                if (!option1Value) {
                    QuestionBankDF_questionBank.getItem("option1").focusInItem();
                }else{
                    QuestionBankDF_questionBank.getItem("option2").focusInItem();
                }

                return;
           }

           if(option1Value3) {

                if (option1Value4) {

                    if (option1Value === option1Value2 || option1Value === option1Value3 || option1Value === option1Value4 || option1Value2 === option1Value3 ||
                        option1Value2 === option1Value4 || option1Value3 === option1Value4) {
                        createDialog("info", "<spring:message code="question.bank.equal.options"/>");
                        return;
                    }

                } else {

                    if (option1Value === option1Value2 || option1Value === option1Value3 || option1Value2 === option1Value3) {
                        createDialog("info", "<spring:message code="question.bank.equal.options"/>");
                        return;
                    }
                }
           } else {

                if (option1Value === option1Value2) {
                    createDialog("info", "<spring:message code="question.bank.equal.options"/>");
                    return;
                }
           }

        }



        let questionBankSaveUrl = questionBankUrl;

        let questionBankAction = '<spring:message code="created"/>';

        if (questionBankMethod_questionBank.localeCompare("PUT") == 0) {
            let record = QuestionBankLG_questionBank.getSelectedRecord();
            questionBankSaveUrl += "/" + record.id;
            questionBankAction = '<spring:message code="edited"/>';
        }

        let data = QuestionBankDF_questionBank.getValues();
        delete data["eQuestionLevel"];
        data.questionLevelId = QuestionBankDF_questionBank.getField("eQuestionLevel.id").getValue();
        data.questionTargets = QuestionBankDF_questionBank.getField("questionTargets").getValue();

        isc.RPCManager.sendRequest(
            TrDSRequest(questionBankSaveUrl, questionBankMethod_questionBank, JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                    let question = JSON.parse(resp.httpResponseText).question;
                    if (question!==null && question!==undefined &&  question.length > 50)
                        question = question.slice(0, 50) + " ...";
                    if (forceToCloseWindow)
                    QuestionBankWin_questionBank.close();
                    createDialog("info", "سوال ( " + question + " ) " + questionBankAction);
                    QuestionBankLG_questionBank.invalidateCache();
                } else if (resp.httpResponseCode == 403) {
                    createDialog("warning", "<spring:message code="msg.question.bank.question.not.editable"/>", "<spring:message code="error"/>");
                }
                else {
                    QuestionBankWin_questionBank.close();
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }
        }));
    }

    function showRemoveForm_questionBank() {
        let record = QuestionBankLG_questionBank.getSelectedRecord();
        let entityType = '<spring:message code="question.bank"/>';
        if (checkRecordAsSelected(record, true, entityType)) {

            let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(TrDSRequest(questionBankUrl + "/" + record.id, "DELETE", null, (resp) => {
                            wait.close();
                            if (generalGetResp(resp)) {
                                if (resp.httpResponseCode == 200) {
                                    let dialog = createDialog("info", "<spring:message code="msg.successfully.done"/>");
                                    Timer.setTimeout(function () {
                                        dialog.close();
                                    }, dialogShowTime);
                                    refresh_questionBank();
                                } else if(resp.httpResponseCode == 404){
                                    createDialog("warning", "چنین سوالی وجود ندارد", "اخطار");
                                }else if(resp.httpResponseCode == 406){
                                    createDialog("warning", "بدلیل استفاده در سوالات «آزمون پایانی» یا «پیش آزمون» امکان حذف این سوال وجود ندارد.", "اخطار");
                                } else {
                                    createDialog("warning", "خطا در حذف سوال", "اخطار");
                                }
                            }
                        }))
                    }
                }
            })

        }
    };

    function rcpResponse(resp, entityType, action, entityName) {
        if (generalGetResp(resp)) {
            let respCode = resp.httpResponseCode;
            if (respCode == 200 || respCode == 201) {
                let name;
                if (entityName && (entityName !== 'undefined')) {
                    name = entityName;
                } else {
                    name = JSON.parse(resp.data).question;
                }
                let msg = entityType + '&nbsp;\'<b>' + name + '</b>\'&nbsp;' + action + '.';
                showOkDialog(msg);
            } else {
                showOkDialog("<spring:message code="exception.data-validation"/>");
            }
            refresh_questionBank();
        }
    };

    // To check the 'record' argument is a valid selected record of list grid
    function checkRecordAsSelected(record, flagShowDialog, dialogMsg) {
        if (record ? (record.constructor === Array ? ((record.length > 0) ? true : false) : true) : false) {
            return true;
        }
        if (flagShowDialog) {
            dialogMsg = dialogMsg ? dialogMsg : "<spring:message code="msg.no.records.selected"/>";
            showOkDialog(dialogMsg, 'notify');
        }
        return false;
    };

    // To show an ok dialog
    function showOkDialog(msg, iconName) {
        // createDialog('info', 'info');
        // createDialog('ask', 'ask');
        // createDialog('confirm', 'confirm');
        iconName = iconName ? iconName : 'say';
        // let dialog = isc.TrOkDialog.create({message: msg, icon: "[SKIN]" + iconName + ".png", autoDraw: true});
        let dialog = isc.MyOkDialog.create({message: msg, autoDraw: true});
        Timer.setTimeout(function () {
            dialog.close();
        }, 3000);
    };

    function loadAttachment() {
        if (QuestionBankLG_questionBank.getSelectedRecord() === null) {
            TabSet_questionBank.disable();
            oLoadAttachments_questionBank.loadPage_attachment_Job("QuestionBank", 0, "<spring:message code="document"/>", {
                1: "صورت سوال",
                2: "سوالات عملی",
                3: "فایل گزینه اول",
                4: "فایل گزینه دوم",
                5: "فایل گزینه سوم",
                6: "فایل گزینه چهارم",
            });

            return;
        }

        oLoadAttachments_questionBank.loadPage_attachment_Job("QuestionBank", QuestionBankLG_questionBank.getSelectedRecord().id, "<spring:message code="document"/>", {
            1: "صورت سوال",
            2: "سوالات عملی",
            3: "فایل گزینه اول",
            4: "فایل گزینه دوم",
            5: "فایل گزینه سوم",
            6: "فایل گزینه چهارم",
        });

        TabSet_questionBank.enable();
    }

    //</script>
