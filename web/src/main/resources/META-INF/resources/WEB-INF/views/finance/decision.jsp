<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------


    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Decision_Header = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "complex", title: "مجتمع", filterOperator: "iContains"},
            {name: "itemFromDate", title: "تاریخ شروع", filterOperator: "iContains"},
            {name: "itemToDate", title: "تاریخ پایان", filterOperator: "iContains"},
        ],
        fetchDataURL: educationalDecisionHeaderRequestUrl + "/list"
    });

    let RestDataSource_decision_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });


    RestDataSource_Decision_Educational_history = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "itemFromDate"},
            {name: "itemToDate"},
            {name: "educationalHistoryCoefficient"},
            {name: "educationalHistoryFrom"},
            {name: "educationalHistoryTo"},


        ],

    });
    let RestDataSource_teaching_methods = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/intraOrganizationalHoldingClassType"
    });

    let RestDataSource_course_type = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eTheoType",
    });


    let RestDataSource_e_level_type_decision= isc.TrDS.create({
        autoCacheAllData: false,
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ],
        fetchDataURL: enumUrl + "eLevelType",
    });

    let RestDataSource_e_for_course_type_decision = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/TargetPopulation"
    });

    RestDataSource_Decision_teaching_method = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "itemFromDate"},
            {name: "itemToDate"},
            {name: "teachingMethod"},
            {name: "courseTypeTeachingMethod"},
            {name: "coefficientOfTeachingMethod"},


        ],

    });

    RestDataSource_Decision_course_type = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "itemFromDate"},
            {name: "itemToDate"},
            {name: "coefficientOfCourseType"},
            {name: "courseForCourseType"},
            {name: "courseLevelCourseType"},
            {name: "typeOfSpecializationCourseType"},


        ],

    });
    RestDataSource_Basic_Tuition = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "itemFromDate"},
            {name: "itemToDate"},
            {name: "baseTuitionFee"},
            {name: "professorTuitionFee"},
            {name: "knowledgeAssistantTuitionFee"},
            {name: "teacherAssistantTuitionFee"},
            {name: "instructorTuitionFee"},
            {name: "educationalAssistantTuitionFee"},

        ]

    });

    //----------------------------------------------------Request Window------------------------------------------------

    DynamicForm_Decision = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "itemFromDate",
                ID: "date_itemFromDate",
                title: "تاریخ شروع هدر",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemFromDate', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "itemToDate",
                ID: "date_itemToDate",
                title: "تاریخ پایان هدر",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemToDate', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "complex",
                title: "مجتمع",
                required: true,
                optionDataSource: RestDataSource_decision_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "title",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
            }
        ]
    });
    DynamicForm_Decision_history = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "itemFromDate",
                ID: "date_itemFromDate_history",
                title: "تاریخ شروع",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemFromDate_history', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "itemToDate",
                ID: "date_itemToDate_history",
                title: "تاریخ پایان ",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemToDate_history', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "educationalHistoryCoefficient",
                title: "ضريب",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "educationalHistoryFrom",
                title: "از سال",
                length: 5,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "educationalHistoryTo",
                title: "تا سال",
                length: 5,
                keyPressFilter: "[0-9.]",
                required: true}
        ]
    });
    DynamicForm_Decision_base = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "itemFromDate",
                ID: "date_itemFromDate_base",
                title: "تاریخ شروع",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemFromDate_base', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "itemToDate",
                ID: "date_itemToDate_base",
                title: "تاریخ پایان ",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemToDate_base', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "baseTuitionFee",
                title: "پايه",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "professorTuitionFee",
                title: "استاد",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "knowledgeAssistantTuitionFee",
                title: "دانشيار",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "teacherAssistantTuitionFee",
                title: "استاديار",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "instructorTuitionFee",
                title: "مربي",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true},
            {
                name: "educationalAssistantTuitionFee",
                title: "مربي آموزشيار",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true}
        ]
    });
    DynamicForm_teaching_method = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "itemFromDate",
                ID: "date_itemFromDate_teaching_method",
                title: "تاریخ شروع",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemFromDate_teaching_method', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "itemToDate",
                ID: "date_itemToDate_teaching_method",
                title: "تاریخ پایان ",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemToDate_teaching_method', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                optionDataSource: RestDataSource_teaching_methods,
                displayField: "title",
                autoFetchData: false,
                valueField: "title",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                name: "teachingMethod",
                title: "روش آموزش",
                type: "ComboBoxItem",

            },
            {
                optionDataSource: RestDataSource_course_type,
                displayField: "titleFa",
                autoFetchData: false,
                valueField: "titleFa",
                textAlign: "center",
                 textMatchStyle: "substring",
                pickListFields: [
                    {name: "titleFa", autoFitWidth: true, autoFitWidthApproach: true}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                  type: "ComboBoxItem",
                name: "courseTypeTeachingMethod",
                title: "نوع دوره",
                required: false
            },{
                name: "coefficientOfTeachingMethod",
                title: "ضریب روش تدریس",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true
            },

        ]
    });
    DynamicForm_course_type = isc.DynamicForm.create({
        width: 400,
        height: "100%",
        numCols: 2,
        fields: [
            {
                name: "id",
                title: "id",
                primaryKey: true,
                canEdit: false,
                hidden: true
            },
            {
                name: "itemFromDate",
                ID: "date_itemFromDate_course_type",
                title: "تاریخ شروع",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemFromDate_course_type', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                name: "itemToDate",
                ID: "date_itemToDate_course_type",
                title: "تاریخ پایان ",
                required: true,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('date_itemToDate_course_type', this, 'ymd', '/');
                    }
                }],
                changed: function (form, item, value) {
                    if (value == null || value === "" || checkDate(value))
                        item.clearErrors();
                    else
                        item.setErrors("<spring:message code='msg.correct.date'/>");
                }
            },
            {
                textAlign: "center",
                required: true,
                displayField: "titleFa",
                valueField: "id",
                //optionDataSource: RestDataSource_eTechnicalType,
                sortField: ["id"],
                // titleOrientation: "top",
                width: "*",
                // height: "30",
                pickListProperties:{
                    showFilterEditor: false
                },
                valueMap: {
                    "1": "عمومي",
                    "2": "تخصصی",
                    "3": "مديريتي",
                },
                name: "typeOfSpecializationCourseType",
                title: "نوع تخصص",
                type: "ComboBoxItem",

            },
            {
                optionDataSource: RestDataSource_e_level_type_decision,
                displayField: "titleFa",
                autoFetchData: false,
                valueField: "titleFa",
                textAlign: "center",
                 textMatchStyle: "substring",
                pickListFields: [
                    {name: "titleFa", autoFitWidth: true, autoFitWidthApproach: true}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                  type: "ComboBoxItem",
                name: "courseLevelCourseType",
                title: "سطح دوره",
                required: false
            },
            {
                optionDataSource: RestDataSource_e_for_course_type_decision,
                displayField: "title",
                autoFetchData: false,
                valueField: "title",
                textAlign: "center",
                 textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                  type: "ComboBoxItem",
                name: "courseForCourseType",
                title: "دوره ویژه ی",
                required: false
            },
            {
                name: "coefficientOfCourseType",
                title: "ضریب نوع دوره",
                length: 20,
                keyPressFilter: "[0-9.]",
                required: true
            },

        ]
    });



    Save_Button_Add_Decision = isc.IButtonSave.create({
        top: 260,
        layoutMargin: 5,
        membersMargin: 5,
        click: function () {
            saveDecisionHeader();
        }
    });

    Cancel_Button_Add_Decision = isc.IButtonCancel.create({
        layoutMargin: 5,
        membersMargin: 5,
        width: 120,
        click: function () {
            Window_header_Decision.close();
        }
    });



    //------------------------------------------------------List Grids--------------------------------------------------

    ListGrid_Decision_Header = isc.ListGrid.create({
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Decision_Header,
        autoFetchData: true,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        recordClick: function () {
            selectionUpdated_Tabs();
        },
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },
            {
                name: "complex",
                title: "مجتمع",
                width: "10%",
                align: "center"
            },
            {
                name: "itemFromDate",
                title: "تاریخ شروع",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "itemToDate",
                title: "تاریخ پایان",
                width: "10%",
                align: "center",
                canFilter: false
            }
        ],

    });

    history_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    addChildDecision(DynamicForm_Decision_history,Window_history_Decision)
                }.bind(this)
            }),
            isc.ToolStripButtonRemove.create({
                title: "حذف",
                click: function () {
                    deleteChildDecision(ListGrid_Decision_Educational_history)
                }.bind(this)
            })
        ]
    });
    teaching_method_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    addChildDecision(DynamicForm_teaching_method,Window_teaching_method)
                }.bind(this)
            }),
            isc.ToolStripButtonRemove.create({
                title: "حذف",
                click: function () {
                    deleteChildDecision(ListGrid_Decision_teaching_method)
                }.bind(this)
            })
        ]
    });
    course_type_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    addChildDecision(DynamicForm_course_type,Window_course_type)
                }.bind(this)
            }),
            isc.ToolStripButtonRemove.create({
                title: "حذف",
                click: function () {
                    deleteChildDecision(ListGrid_Decision_course_type)
                }.bind(this)
            })
        ]
    });
    base_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                title: "افزودن",
                click: function () {
                    addChildDecision(DynamicForm_Decision_base,Window_base_Decision)
                }.bind(this)
            }),
            isc.ToolStripButtonRemove.create({
                title: "حذف",
                click: function () {
                    deleteChildDecision(ListGrid_Basic_Tuition)
                }.bind(this)
            })
        ]
    });

    ListGrid_Decision_Educational_history = isc.ListGrid.create({
        dataSource: RestDataSource_Decision_Educational_history,
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        autoFetchData: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },
            {
                name: "itemFromDate",
                title: "تاریخ شروع",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "itemToDate",
                title: "تاریخ پایان",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "educationalHistoryCoefficient",
                title: " ضريب ميزان سابقه آموزشي در صنعت",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "educationalHistoryFrom",
                title: "از ",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "educationalHistoryTo",
                title: "تا",
                width: "10%",
                align: "center",
                canFilter: false
            },

        ],
        gridComponents: [history_actions, "filterEditor", "header", "body", "summaryRow"]


    });
    ListGrid_Decision_teaching_method = isc.ListGrid.create({
        dataSource: RestDataSource_Decision_teaching_method,
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        autoFetchData: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },
            {
                name: "itemFromDate",
                title: "تاریخ شروع",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "itemToDate",
                title: "تاریخ پایان",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "teachingMethod",
                title: "روش آموزش",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "courseTypeTeachingMethod",
                title: "نوع دوره",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "coefficientOfTeachingMethod",
                title: "ضریب روش تدریس",
                width: "10%",
                align: "center",
                canFilter: false
            },


        ],
        gridComponents: [teaching_method_actions, "filterEditor", "header", "body", "summaryRow"]


    });
    ListGrid_Decision_course_type = isc.ListGrid.create({
        dataSource: RestDataSource_Decision_course_type,
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        autoFetchData: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },
            {
                name: "itemFromDate",
                title: "تاریخ شروع",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "itemToDate",
                title: "تاریخ پایان",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "typeOfSpecializationCourseType",
                title: "نوع تخصص",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "courseLevelCourseType",
                title: "سطح دوره",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "courseForCourseType",
                title: "دوره ویژه ی",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "coefficientOfCourseType",
                title: "ضریب نوع دوره",
                width: "10%",
                align: "center",
                canFilter: false
            },


        ],
        gridComponents: [course_type_actions, "filterEditor", "header", "body", "summaryRow"]


    });
    ListGrid_Basic_Tuition = isc.ListGrid.create({
        dataSource: RestDataSource_Basic_Tuition,
        sortDirection: "descending",
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        autoFetchData: false,
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },

            {
                name: "itemFromDate",
                title: "تاریخ شروع",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "itemToDate",
                title: "تاریخ پایان",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "baseTuitionFee",
                title: "پايه",
                width: "10%",
                canFilter: false,
                align: "center"
            },
            {
                name: "professorTuitionFee",
                title: "استاد",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "knowledgeAssistantTuitionFee",
                title: "دانشيار",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "teacherAssistantTuitionFee",
                title: "استاديار",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "instructorTuitionFee",
                title: "مربي",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "educationalAssistantTuitionFee",
                title: " آموزشيار",
                width: "10%",
                align: "center",
                canFilter: false
            }
        ],
        gridComponents: [base_actions, "filterEditor", "header", "body", "summaryRow"]

    });

    //----------------------------------------------------Actions --------------------------------------------------

    ToolStripButton_Add_Decision = isc.ToolStripButtonCreate.create({
        title: "افزودن هدر تصمیم گیری",
        click: function () {
            addHeaderDecision();
        }
    });

    ToolStripButton_Delete_Decision = isc.ToolStripButtonRemove.create({
        click: function () {
            deleteDecisionHeader();
        }
    });

    ToolStripButton_Refresh_Decision = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Decision_Header.invalidateCache();
        }
    });



    //////////////////// tab ////////////////////////////////////////////


    Decision_Tabs = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {name: "TabPane_Decision_Educational_history", title: "مبلغ پایه حق التدریس", pane: ListGrid_Basic_Tuition},
            {name: "TabPane_Basic_Tuition", title: "ضریب سابقه آموزشی", pane: ListGrid_Decision_Educational_history},
            {name: "TabPane_teaching_method", title: "ضریب روش تدریس", pane: ListGrid_Decision_teaching_method},
            {name: "TabPane_course_type", title: "ضریب روش تدریس", pane: ListGrid_Decision_course_type},
        ],
        tabSelected: function () {
            selectionUpdated_Tabs();
        }
    });



    //----------------------------------- layOut -----------------------------------------------------------------------

    HLayout_IButtons_Decision = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            Save_Button_Add_Decision,
            Cancel_Button_Add_Decision
        ]
    });
    HLayout_IButtons_Decision_history = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            isc.IButtonSave.create({
                top: 260,
                layoutMargin: 5,
                membersMargin: 5,
                click: function () {
                    saveChildDecision(ListGrid_Decision_Educational_history,DynamicForm_Decision_history,Window_history_Decision,"history")
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    Window_history_Decision.close();
                }
            })
        ]
    });
    HLayout_IButtons_Decision_base = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            isc.IButtonSave.create({
                top: 260,
                layoutMargin: 5,
                membersMargin: 5,
                click: function () {
                    saveChildDecision(ListGrid_Basic_Tuition,DynamicForm_Decision_base,Window_base_Decision,"base")
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    Window_base_Decision.close();
                }
            })
        ]
    });
    HLayout_IButtons_teaching_method = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            isc.IButtonSave.create({
                top: 260,
                layoutMargin: 5,
                membersMargin: 5,
                click: function () {
                    saveChildDecision(ListGrid_Decision_teaching_method,DynamicForm_teaching_method,Window_teaching_method,"teaching-method")
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    Window_teaching_method.close();
                }
            })
        ]
    });
    HLayout_IButtons_course_type = isc.HLayout.create({
        layoutMargin: 5,
        membersMargin: 15,
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            isc.IButtonSave.create({
                top: 260,
                layoutMargin: 5,
                membersMargin: 5,
                click: function () {
                    saveChildDecision(ListGrid_Decision_course_type,DynamicForm_course_type,Window_course_type,"course-type")
                }
            }),
            isc.IButtonCancel.create({
                layoutMargin: 5,
                membersMargin: 5,
                width: 120,
                click: function () {
                    Window_course_type.close();
                }
            })
        ]
    });
    Window_header_Decision = isc.Window.create({
        title: "افزودن هدر تصمیم گیری",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Decision,
            HLayout_IButtons_Decision
        ]
    });

    Window_history_Decision = isc.Window.create({
        title: "افزودن ضریب سابقه آموزشی",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Decision_history,
            HLayout_IButtons_Decision_history
        ]
    });
    Window_base_Decision = isc.Window.create({
        title: "افزودن مبلغ پایه حق التدریس",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_Decision_base,
            HLayout_IButtons_Decision_base
        ]
    });

    Window_teaching_method = isc.Window.create({
        title: "افزودن ضریب روش تدریس",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_teaching_method,
            HLayout_IButtons_teaching_method
        ]
    });
    Window_course_type = isc.Window.create({
        title: "افزودن ضریب نوع دوره",
        width: 450,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        items: [
            DynamicForm_course_type,
            HLayout_IButtons_course_type
        ]
    });

    ToolStrip_Actions_Decision = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Decision,
            ToolStripButton_Delete_Decision,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Decision
                ]
            })
        ]
    });

    VLayout_Body_Decision = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_Decision,
            ListGrid_Decision_Header
        ]
    });

    HLayout_Tabs_Decision = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "80%",
        members: [Decision_Tabs]
    });

    VLayout_Body_Decision_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_Decision,
            HLayout_Tabs_Decision
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    function addHeaderDecision() {

        DynamicForm_Decision.clearValues();
        DynamicForm_Decision.clearErrors();
        Window_header_Decision.show();
    }



    function saveDecisionHeader() {

        if (!DynamicForm_Decision.validate())
            return;
        if(DynamicForm_Decision.getValue("itemToDate") < DynamicForm_Decision.getValue("itemFromDate")) {
            createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
            return;
        }
        let data = DynamicForm_Decision.getValues();

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionHeaderRequestUrl, "POST", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    Window_header_Decision.close();
                    ListGrid_Decision_Header.invalidateCache();
                } else {
                    wait.close();
                    createDialog("info", "خطایی رخ داده است");
                }
            }));


    }

    function addChildDecision(dynamicForm,window) {
        dynamicForm.clearValues();
        dynamicForm.clearErrors();
        window.show();
    }
    function saveChildDecision(listGrid,dynamicForm,window,ref) {
        let record = ListGrid_Decision_Header.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        if (!dynamicForm.validate())
            return;
        if(dynamicForm.getValue("itemToDate") < dynamicForm.getValue("itemFromDate")) {
            createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
            return;
        }
        let data = dynamicForm.getValues();
        data.ref =ref
        data.educationalDecisionHeaderId =record.id
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionRequestUrl, "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                window.close();
                listGrid.invalidateCache();
            } else {
                wait.close();
                createDialog("info", "خطایی رخ داده است");
            }
        }));


    }
    function deleteChildDecision(listGrid) {
        let record = listGrid.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_dec_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_dec_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionRequestUrl + "/" + record.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                listGrid.invalidateCache();

                            } else {
                                wait.close();
                                createDialog("info", "خطایی رخ داده است");
                            }
                        }));
                    }
                }
            });
        }
    }

    function deleteDecisionHeader() {
        let record = ListGrid_Decision_Header.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Competence_Request_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Competence_Request_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(educationalDecisionHeaderRequestUrl + "/" + record.id, "DELETE", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                wait.close();
                                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                ListGrid_Decision_Header.invalidateCache();

                            } else {
                                wait.close();
                                createDialog("info", "رکورد مورد نظر دارای زیر مجموعه می باشد");
                            }
                        }));
                    }
                }
            });
        }
    }

    function selectionUpdated_Tabs() {

        let record = ListGrid_Decision_Header.getSelectedRecord();
        let tab = Decision_Tabs.getSelectedTab();

        if (record == null && tab.pane != null) {
            tab.pane.setData([]);
            return;
        }


        switch (tab.name) {
            case "TabPane_Decision_Educational_history": {
                RestDataSource_Basic_Tuition.fetchDataURL = educationalDecisionRequestUrl + "/list/base/"+record.id;
                ListGrid_Basic_Tuition.invalidateCache();
                ListGrid_Basic_Tuition.fetchData();
                break;
            }
            case "TabPane_Basic_Tuition": {
                RestDataSource_Decision_Educational_history.fetchDataURL = educationalDecisionRequestUrl + "/list/history/"+record.id;
                ListGrid_Decision_Educational_history.invalidateCache();
                ListGrid_Decision_Educational_history.fetchData();
                break;
            }
            case "TabPane_teaching_method": {
                RestDataSource_Decision_teaching_method.fetchDataURL = educationalDecisionRequestUrl + "/list/teaching-method/"+record.id;
                ListGrid_Decision_teaching_method.invalidateCache();
                ListGrid_Decision_teaching_method.fetchData();
                break;
            }
            case "TabPane_course_type": {
                RestDataSource_Decision_course_type.fetchDataURL = educationalDecisionRequestUrl + "/list/course-type/"+record.id;
                ListGrid_Decision_course_type.invalidateCache();
                ListGrid_Decision_course_type.fetchData();
                break;
            }

        }
    }


    // </script>