<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    var classMethod = "POST";
    var autoValid = false;
    var classWait;
    var class_userCartableId;
    var startDateCheck = true;
    var endDateCheck = true;

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_Teacher_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "fullNameFa"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"}
        ],
        fetchDataURL: teacherUrl + "fullName-list"
    });

    // var RestDataSource_EAttachmentType_JspClass = isc.TrDS.create({
    //     fields: [
    //         {name: "id", primaryKey: true},
    //         {name: "titleFa"}],
    //     fetchDataURL: enumUrl + "eClassAttachmentType/spec-list"
    // });

    var RestDataSource_Class_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
// {name: "lastModifiedDate",hidden:true},
// {name: "createdBy",hidden:true},
// {name: "createdDate",hidden:true,type:d},
            {name: "titleClass"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "code"},
            {name: "term.titleFa"},
// {name: "teacher.personality.lastNameFa"},
// {name: "course.code"},
            {name: "course.titleFa"},
            {name: "course.id"},
            {name: "teacherId"},
            {name: "teacher"},
            {name: "reason"},
            {name: "classStatus"},
            {name: "topology"},
            {name: "trainingPlaceIds"},
            {name: "instituteId"},
            {name: "workflowEndingStatusCode"},
            {name: "workflowEndingStatus"},
            {name: "preCourseTest", type: "boolean"}
        ],
        fetchDataURL: classUrl + "spec-list"
    });

    var RestDataSource_Course_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "scoringMethod"},
            {name: "acceptancelimit"},
            {name: "startEvaluation"},
            {
                name: "code",
                title: "<spring:message code="course.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},
            {name: "theoryDuration"},
        ],
        fetchDataURL: courseUrl + "spec-list"

    });

    // var RestDataSource_Course_JspClass_workFlow = isc.TrDS.create({
    // fields: [
    // {name: "id", primaryKey: true},
    // {name: "code"},
    // {name: "titleFa"},
    // {name: "theoryDuration"}
    // ],
    //
    // });

    var RestDataSource_Class_Student_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.lastNameFa"},
            {name: "studentID"}
        ],
        fetchDataURL: classUrl + "otherStudent"
    });

    var RestDataSource_Class_CurrentStudent_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.lastNameFa"},
            {name: "studentID"}
        ],
        fetchDataURL: classUrl + "student"
    });

    var RestDataSource_Term_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ],
        fetchDataURL: termUrl + "spec-list?_startRow=0&_endRow=55"
    });
    var RestDataSource_Institute_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "نام موسسه"},
            {name: "manager.firstNameFa", title: "نام مدیر"},
            {name: "manager.lastNameFa", title: "نام خانوادگی مدیر"},
            {name: "mobile", title: "موبایل"},
            {name: "restAddress", title: "آدرس"},
            {name: "phone", title: "تلفن"}
        ],
        fetchDataURL: instituteUrl + "spec-list",
        allowAdvancedCriteria: true,
    });
    var RestDataSource_TrainingPlace_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
// {name:"parentId", type:"Long", foreignKey:"instituteId"},
            {name: "instituteId"},
            {name: "instituteTitleFa", title: "نام موسسه"},
            {name: "titleFa", title: "نام مکان"},
            {name: "capacity", title: "ظرفیت"}
        ],
// fetchDataURL: instituteUrl + "0/training-places"
        fetchDataURL: trainingPlaceUrl + "/with-institute"
    });


    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_Class_JspClass = isc.Menu.create({
// width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Class_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Class_add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_class_edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>",
            click: function () {
                ListGrid_class_remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                ListGrid_class_print("pdf");
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "<spring:url value="excel.png"/>", click: function () {
                ListGrid_class_print("excel");
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "<spring:url value="html.png"/>", click: function () {
                ListGrid_class_print("html");
            }
        },
            {isSeparator: true}, {
                title: "<spring:message code='students.list'/>", icon: "icon/classroom.png", click: function () {
                    Add_Student();
                }
            }
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ListGrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Class_JspClass = isc.TrLG.create({
        ID: "classListGrid",
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Class_JspClass,
        contextMenu: Menu_ListGrid_Class_JspClass,
        // dataPageSize: 50,
        // allowAdvancedCriteria: true,
        // allowFilterExpressions: true,
        // filterOnKeypress: true,
        // selectionType: "single",

// showRecordComponents: true,
// showRecordComponentsByCell: true,
        selectionType: "single",
        <%--filterUsingText: "<spring:message code='filterUsingText'/>",--%>
        <%--groupByText: "<spring:message code='groupByText'/>",--%>
        <%--freezeFieldText: "<spring:message code='freezeFieldText'/>",--%>
        styleName: 'expandList-tapBar',
        cellHeight: 43,
        autoFetchData: true,
        alternateRecordStyles: true,
        canExpandRecords: true,
        canExpandMultipleRecords: false,
        wrapCells: true,
        showRollOver: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        expansionMode: "related",
        autoFitExpandField: true,
        virtualScrolling: true,
        loadOnExpand: true,
        loaded: false,
        initialSort: [
// {property: "createdBy", direction: "ascending"},
            {property: "code", direction: "descending", primarySort: true}
        ],
        // selectionUpdated: function (record) {
        //     refreshSelectedTab_class(tabSetClass.getSelectedTab());
        // },
        doubleClick: function () {
            ListGrid_class_edit();

        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "titleClass",
                title: "titleClass",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                hidden: true
            },
            {
                name: "course.titleFa",
                title: "<spring:message code='course.title'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
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
                filterOperator: "iContains"
            },
            {name: "endDate", title: "<spring:message code='end.date'/>", align: "center", filterOperator: "iContains"},
            {
                name: "group",
                title: "<spring:message code='group'/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true
            },
            <%--{name: "reason", title: "<spring:message code='training.request'/>", align: "center"},--%>
            {name: "teacher", title: "<spring:message code='teacher'/>", align: "center", filterOperator: "iContains"},
            {
                name: "reason", title: "<spring:message code='training.request'/>", align: "center",
                valueMap: {
                    "1": "نیازسنجی",
                    "2": "درخواست واحد",
                    "3": "نیاز موردی",
                },
            },
            {
                name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                },
            },
            {
                name: "topology", title: "<spring:message code='place.shape'/>", align: "center", valueMap: {
                    "1": "U شکل",
                    "2": "عادی",
                    "3": "مدور",
                    "4": "سالن"
                }
            },
// {name: "lastModifiedDate",
// type:"time"
// ,hidden:true
// },
            {name: "createdBy", hidden: true},
            {name: "createdDate", hidden: true},
            {
                name: "workflowEndingStatusCode",
                title: "workflowCode",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "workflowEndingStatus",
                title: "<spring:message code="ending.class.status"/>",
                align: "center",
                filterOperator: "iContains"
            },
            {name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif"}

        ],

        getCellCSSText: function (record, rowNum, colNum) {
            if (this.isSelected(record)) {
                return "background-color: #fe9d2a;";
            } else {
                if (record.classStatus === "1")
                    return "background-color: #a5a5a5;";
                else if (record.classStatus === "3")
                    return "background-color: #C7E1FF;";
            }
        },
        dataArrived: function () {
            selectWorkflowRecord();
        },
        getExpansionComponent: function (record) {
            ListGrid_Class_JspClass.selectSingleRecord(record);
            refreshSelectedTab_class(tabSetClass.getSelectedTab());
            var layout = isc.VLayout.create({
                styleName: "expand-layout",
                height: 300,
                padding: 0,
                membersMargin: 0,
                members: [HLayout_Tab_Class]
            });

            return layout;
        },
    });

    var VM_JspClass = isc.ValuesManager.create({});

    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//

    var DynamicForm_Class_JspClass = isc.DynamicForm.create({
// width: "700",
        validateOnExit: true,
        height: "100%",
        wrapItemTitles: true,
        isGroup: true,
        groupTitle: "اطلاعات پایه کلاس",
        groupBorderCSS: "1px solid lightBlue",
        borderRadius: "6px",
        titleAlign: "left",
        numCols: 10,
        itemHoverWidth: "20%",
        colWidths: ["5%", "24%", "5%", "12%", "5%", "6%", "6%", "5%", "7%", "12%"],
        padding: 10,
        valuesManager: "VM_JspClass",
        fields: [
            {name: "id", hidden: true},
            {
                name: "course.id", editorType: "TrComboAutoRefresh", title: "<spring:message code='course'/>:",
                textAlign: "center",
                pickListWidth: 500,
                optionDataSource: RestDataSource_Course_JspClass,
                // autoFetchData: false,
                displayField: "titleFa", valueField: "id",
                filterFields: ["titleFa", "code", "createdBy"],
                required: true,
                pickListFields: [
                    {name: "code"},
                    {name: "titleFa"},
                    {name: "createdBy"}
                ],
                changed: function (form, item, value) {
                    form.getItem("startEvaluation").setDisabled(false);
                    form.setValue("titleClass", item.getSelectedRecord().titleFa);
                    form.setValue("scoringMethod", item.getSelectedRecord().scoringMethod);
                    if (item.getSelectedRecord().startEvaluation != null) {
                        form.setValue("startEvaluation", item.getSelectedRecord().startEvaluation)
                    } else {
                        form.getItem("startEvaluation").setDisabled(true);
                        form.getItem("startEvaluation").setValue()
                    }
                    //==============
                    DynamicForm_Class_JspClass.getItem("scoringMethod").change(DynamicForm_Class_JspClass, DynamicForm_Class_JspClass.getItem("scoringMethod"), DynamicForm_Class_JspClass.getValue("scoringMethod"));
                    if (item.getSelectedRecord().scoringMethod == "1") {
                        form.setValue("acceptancelimit_a", item.getSelectedRecord().acceptancelimit);
                    } else {
                        form.setValue("acceptancelimit", item.getSelectedRecord().acceptancelimit);
                    }
                    //==================
                    form.clearValue("teacherId");
                    evalGroup();
                    RestDataSource_Teacher_JspClass.fetchDataURL = teacherUrl + "fullName-list/" + VM_JspClass.getField("course.id").getSelectedRecord().category.id;
                    form.getItem("teacherId").fetchData();
                    form.setValue("hduration", item.getSelectedRecord().theoryDuration);
                    if (item.getSelectedRecord().evaluation === "1") {
                        form.setValue("preCourseTest", false);
                        form.getItem("preCourseTest").hide();
                    } else
                        form.getItem("preCourseTest").show();
                }
            },
            {
                name: "minCapacity",
                title: "<spring:message code='capacity'/>:",
                textAlign: "center",
                hint: "حداقل نفر",
                showHintInField: true,
                keyPressFilter: "[0-9]",
                <%--validators:[{--%>
                <%--type: "custom",--%>
                <%--errorMessage: "<spring:message code='msg.min.capacity'/>",--%>
                <%--condition: function (item, validator, value) {--%>
                <%--if (value == null || this.form.getValue("maxCapacity") == null)--%>
                <%--return true;--%>
                <%--return value <= this.form.getValue("maxCapacity");--%>
                <%--}--%>
                <%--}]--%>
            },
            {
                name: "maxCapacity",
                colSpan: 2,
                showTitle: false,
                hint: "حداکثر نفر",
                textAlign: "center",
                showHintInField: true,
                keyPressFilter: "[0-9]"
            },
            {
                name: "code",
                title: "<spring:message code='class.code'/>:",
                colSpan: 3,
                // textAlign: "center",
                readOnlyHover: "به منظور تولید اتوماتیک کد کلاس، باید حتماً اطلاعات فیلدهای دوره و ترم تکمیل شده باشند.",
                canEdit: false,
                // type: "staticText", textBoxStyle: "textItemLite"
            },
            {
                name: "titleClass",
                textAlign: "center",
                required: true,
                title: "<spring:message code='class.title'/>:",
                wrapTitle: true
            },
            {
                name: "teachingType",
// titleOrientation:"top",
                colSpan: 1,
                rowSpan: 3,
                title: "<spring:message code='teaching.type'/>:",
                type: "radioGroup",
// vertical:false,
                fillHorizontalSpace: true,
                defaultValue: "حضوری",
                valueMap: [
                    "حضوری",
                    "غیر حضوری",
                    "مجازی",
                    "عملی و کارگاهی"
                ]
// textBoxStyle:"textItemLite"
            },
            {
                name: "topology",
                colSpan: 1,
                rowSpan: 3,
// rowSpan:2,
                title: "<spring:message code='place.shape'/>:",
                type: "radioGroup",
// vertical:false,
                fillHorizontalSpace: true,
                defaultValue: "2",
                valueMap: {
                    "1": "U شکل",
                    "2": "عادی",
                    "3": "مدور",
                    "4": "سالن"
                }
// textBoxStyle:"textItemLite"
            },
            {
                name: "hduration",
                colSpan: 2,
                formatOnBlur: true,
                title: "<spring:message code='duration'/>:",
                hint: "<spring:message code='hour'/>",
                textAlign: "center",
                required: true,
                showHintInField: true,
                keyPressFilter: "[0-9.]",
                mapValueToDisplay: function (value) {
                    if (isNaN(value)) {
                        return "";
                    }
                    return value + " ساعت ";
                }
            },
            {
                name: "dDuration",
                showTitle: false,
                canEdit: false,
                hint: "روز",
                textAlign: "center",
                showHintInField: true,
                mapValueToDisplay: function (value) {
                    if (isNaN(value)) {
                        if (value) {
                            return value;
                        }
                        return "";
                    }
                    return value + " روز ";
                }
            },
            {
                name: "teacherId",
// multipleAppearance: "picklist",
// colSpan:2,
                title: "<spring:message code='trainer'/>:",
                textAlign: "center",
                type: "ComboBoxItem",
                multiple: false,
// pickListWidth: 230,
// changeOnKeypress: true,
                displayField: "fullNameFa",
                valueField: "id",
                autoFetchData: false,
                required: true,
// filterLocally:true,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Teacher_JspClass,
                pickListFields: [
                    {
                        name: "personality.lastNameFa",
                        title: "<spring:message code='lastName'/>",
                        titleAlign: "center",
                        filterOperator: "iContains"
                    },
                    {
                        name: "personality.firstNameFa",
                        title: "<spring:message code='firstName'/>",
                        titleAlign: "center", filterOperator: "iContains"
                    },
                    {
                        name: "personality.nationalCode",
                        title: "<spring:message code='national.code'/>",
                        titleAlign: "center",
                        filterOperator: "iContains"
                    }
                ],
                filterFields: [
                    "personality.lastNameFa",
                    "personality.firstNameFa",
                    "personality.nationalCode"
                ],
                click: function (form, item) {
                    if (form.getValue("course.id")) {
                        RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/" + form.getValue("course.id");
                        item.fetchData();
                    } else {
                        RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/0";
                        item.fetchData();
                        dialogTeacher = isc.MyOkDialog.create({
                            message: "ابتدا دوره را انتخاب کنید",
                        });
                        dialogTeacher.addProperties({
                            buttonClick: function () {
                                this.close();
                                form.getItem("course.id").selectValue();
// DynamicForm_course_MainTab.getItem("titleFa").selectValue();
                            }
                        });

                    }
                }
// getPickListFilterCriteria : function () {
// VM_JspClass.getField("course.id").getSelectedRecord().category.id;
// return {category:category};
// }
            },
            {
                name: "supervisor",
                colSpan: 3,
                title: "<spring:message code="supervisor"/>:",
                type: "selectItem",
                textAlign: "center",
                valueMap: {
                    1: "آقای دکتر سعیدی",
                    2: "خانم شاکری",
                    3: "خانم اسماعیلی",
                    4: "خانم احمدی",
                }
// textBoxStyle:"textItemLite"
            },
            {
                name: "reason",
                colSpan: 1,
                textAlign: "center",
                wrapTitle: true,
                title: "<spring:message code="training.request"/>:",
                type: "selectItem",
                valueMap: {
                    "1": "نیازسنجی",
                    "2": "درخواست واحد",
                    "3": "نیاز موردی",
                },
// textBoxStyle: "textItemLite"
            },
            {
                name: "organizerId", editorType: "TrComboAutoRefresh", title: "<spring:message code="executer"/>:",
// width:"250",
                colSpan: 3,
                pickListWidth: 500,
                autoFetchData: false,
                optionDataSource: RestDataSource_Institute_JspClass,
// addUnknownValues:false,
                displayField: "titleFa", valueField: "id",
// pickListPlacement: "fillScreen",
// pickListWidth:300,
                textAlign: "center",
                filterFields: ["titleFa", "mobile", "manager.firstNameFa", "manager.lastNameFa"],
// pickListPlacement: "fillScreen",
// pickListWidth:300,
                required: true,
                pickListFields: [
                    {name: "titleFa", filterOperator: "iContains"},
                    {name: "manager.firstNameFa", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", filterOperator: "iContains"}
                ],
                changed: function (form, item, value) {
                    if (form.getValue("instituteId") == null) {
                        form.setValue("instituteId", value);
                    }
                }
            },
            {
                ID: "classTypeStatus",
                name: "classStatus",
                colSpan: 1,
                rowSpan: 1,
                title: "<spring:message code="class.status"/>:",
                wrapTitle: true,
                type: "radioGroup",
                vertical: false,
                fillHorizontalSpace: true,
                defaultValue: "1",
// endRow:true,
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                },
                change: function (form, item, value, oldValue) {


                    if (classMethod.localeCompare("PUT") === 0 && value === "3")
                        checkEndingClass(oldValue);
                    else if (classMethod.localeCompare("POST") === 0 && value === "3")
                        return false;

                }
            },

            {
                name: "group",
                title: "<spring:message code="group"/>:",
                // required: true,
                colSpan: 1,
                readOnlyHover: "به منظور تولید اتوماتیک گروه باید حتماً اطلاعات فیلدهای دوره و ترم تکمیل شده باشند.",
                canEdit: false,
                // textAlign: "center",
                // type: "staticText",
                // textBoxStyle: "textItemLite"
            },
            {
                name: "instituteId",
                editorType: "TrComboAutoRefresh",
                title: "<spring:message code="training.place"/>:",
// width:"250",
                colSpan: 4,
                autoFetchData: false,
                optionDataSource: RestDataSource_Institute_JspClass,
// addUnknownValues:false,
                displayField: "titleFa",
                valueField: "id",
// pickListPlacement: "fillScreen",
// pickListWidth:300,
                textAlign: "center",
                filterFields: ["titleFa", "mobile", "manager.firstNameFa", "manager.lastNameFa"],
// pickListPlacement: "fillScreen",
// pickListWidth:300,
                required: true,
                showHintInField: true,
                hint: "موسسه",
                pickListWidth: 500,
                pickListFields: [
                    {name: "titleFa", filterOperator: "iContains"},
                    {name: "manager.firstNameFa", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", filterOperator: "iContains"}
                ],
                changed: function (form, item) {
                    form.clearValue("trainingPlaceIds")
                }
            },
            {
                name: "trainingPlaceIds", editorType: "SelectItem", title: "<spring:message code="training.place"/>:",
                required: true,
                showHintInField: true,
                hint: "مکان",
                autoFetchData: false,
                multiple: true,
                pickListWidth: 250,
                colSpan: 1,
                showTitle: false,
                optionDataSource: RestDataSource_TrainingPlace_JspClass,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa", "capacity"],
                textMatchStyle: "substring",
                textAlign: "center",
                pickListFields: [
                    {name: "titleFa"},
                    {name: "capacity"}
                ],
                click: function (form, item) {
                    if (form.getValue("instituteId")) {
                        RestDataSource_TrainingPlace_JspClass.fetchDataURL = instituteUrl + form.getValue("instituteId") + "/training-places";
                        item.fetchData();
                    } else {
                        RestDataSource_TrainingPlace_JspClass.fetchDataURL = instituteUrl + "0/training-places";
                        item.fetchData();
                        isc.MyOkDialog.create({
                            message: "ابتدا برگزار کننده را انتخاب کنید",
                        });
                    }
// VM_JspClass.getField("course.id").getSelectedRecord().category.id;
// return {category:category};
                }
            },
            {
                name: "scoringMethod",
                colSpan: 1,
                required: true,
                title: "روش نمره دهی",
                textAlign: "center",
                valueMap: {
                    "1": "ارزشی",
                    "2": "نمره از صد",
                    "3": "نمره از بیست",
                    "4": "بدون نمره",
                },

                changed: function () {
                    let record = ListGrid_Class_JspClass.getSelectedRecord();
                    isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/getScoreState/" + record.id, "GET", null, "callback:GetScoreState(rpcResponse,'" + record.id + "' )"));
                },
                change: function (form, item, value) {
                    if (value == "1") {
                        form.getItem("acceptancelimit").validators = [{}];
                        form.getItem("acceptancelimit").hide();
                        form.getItem("acceptancelimit").setValue();
                        form.getItem("acceptancelimit_a").show();
                        form.getItem("acceptancelimit_a").enable();
                        form.getItem("acceptancelimit_a").setRequired(true);
                        form.getItem("acceptancelimit_a").setDisabled(false);
                    } else if (value == "2") {
                        form.getItem("acceptancelimit").validators = [{
                            type: "integerRange", min: 0, max: 100,
                            errorMessage: "لطفا یک عدد بین 0 تا 100 وارد کنید",
                        }, {
                            type: "required", errorMessage: "نمره را وارد کنید",
                        }]
                        form.getItem("acceptancelimit").show();
                        form.getItem("acceptancelimit").enable();
                        form.getItem("acceptancelimit").setRequired(true);
                        form.getItem("acceptancelimit_a").hide();
                        form.getItem("acceptancelimit_a").setValue();
                        form.getItem("acceptancelimit_a").setRequired(false);
                        form.getItem("acceptancelimit").setDisabled(false);
                    } else if (value == "3") {
                        form.getItem("acceptancelimit").validators = [{
                            type: "regexp",
                            errorMessage: "<spring:message code="msg.validate.score"/>",
                            expression: /^((([0-9]|1[0-9])([.][0-9][0-9]?)?)[20]?)$/,
                        }, {type: "required"}];
                        form.getItem("acceptancelimit").show();
                        form.getItem("acceptancelimit").enable();
                        form.getItem("acceptancelimit").setRequired(true);
                        form.getItem("acceptancelimit_a").hide();
                        form.getItem("acceptancelimit_a").setValue();
                        form.getItem("acceptancelimit_a").setRequired(false);
                        form.getItem("acceptancelimit").setDisabled(false);

                    } else if (value == "4") {
                        form.getItem("acceptancelimit").show();
                        form.getItem("acceptancelimit").setValue();
                        form.getItem("acceptancelimit").setRequired(false);
                        form.getItem("acceptancelimit").setDisabled(true);
                        form.getItem("acceptancelimit_a").hide();
                        form.getItem("acceptancelimit_a").setValue();
                        form.getItem("acceptancelimit_a").setRequired(false);
                    }
                },
            },
            {
                name: "acceptancelimit",
                title: "حد نمره قبولی",
                required: true,
            },

            {
                name: "acceptancelimit_a",
                colSpan: 2,
                required: true,
                hidden: true,
                textAlign: "center",
                title: "حد نمره قبولی",
                valueMap: {
                    "1001": "ضعیف",
                    "1002": "متوسط",
                    "1003": "خوب",
                    "1004": "خيلي خوب",
                }
            },
            {
                name: "startEvaluation",
                title: "<spring:message code="start.evaluation"/>",
                textAlign: "center",
                hint: "&nbsp;ماه",
                valueMap: {
                    "1": "1",
                    "2": "2",
                    "3": "3",
                    "4": "4",
                    "5": "5",
                    "6": "6",
                    "7": "7",
                    "8": "8",
                    "9": "9",
                    "10": "10",
                    "11": "11",
                    "12": "12"
                }
            },
            {
                name: "preCourseTest",
                type: "boolean",
                title: "پیش آزمون",
                hidden: true,
            }
        ],
    });
    var DynamicForm1_Class_JspClass = isc.DynamicForm.create({
// width: "700",
// validateOnChange:true,
        height: "100%",
// validateOnExit:true,
        isGroup: true,
        titleAlign: "left",
        wrapItemTitles: true,
        groupTitle: "<spring:message code="class.meeting.time"/>",
        groupBorderCSS: "1px solid lightBlue",
        borderRadius: "6px",
// numCols: 14,
        numCols: 6,
        colWidths: ["6%", "6%", "6%", "6%", "6%", "6%"],
// colWidths:["5%","5%","5%","5%","5%","5%","5%","7%","7%","7%","7%","7%","7%","7%"],
        padding: 10,
// align: "center",
        valuesManager: "VM_JspClass",
        /* margin: 50,

        canTabToIcons: false,*/
        fields: [
            {
                name: "termId",
// titleColSpan: 1,
                title: "<spring:message code='term'/>",
                textAlign: "center",
                required: true,
                editorType: "ComboBoxItem",
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Term_JspClass,
// autoFetchData: true,
                cachePickListResults: true,
                useClientFiltering: true,
                filterFields: ["code"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                colSpan: 2,
// endRow:true,
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='term.code'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        filterOperator: "iContains"
                    }
                ],
                click: function (form, item) {
                    item.fetchData();
                },
                changed: function () {
                    evalGroup();
                }
            },
            {
                name: "autoValid",
                type: "checkbox",
                defaultValue: true,
                title: "<spring:message code='auto.session.made'/>",
                endRow: true,
// titleOrientation:"top",
                labelAsTitle: true,
                colSpan: 2
            },
            {
                name: "startDate",
                titleColSpan: 1,
// type:"staticText",
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspClass",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        if (!(form.getValue("termId"))) {
                            dialogTeacher = isc.MyOkDialog.create({
                                message: "ابتدا ترم را انتخاب کنید",
                            });
                            dialogTeacher.addProperties({
                                buttonClick: function () {
                                    this.close();
                                    form.getItem("termId").selectValue();
// DynamicForm_course_MainTab.getItem("titleFa").selectValue();
                                }
                            });
                        } else {
                            closeCalendarWindow();
                            displayDatePicker('startDate_jspClass', this, 'ymd', '/');
                        }
                    }
                }],
                textAlign: "center",
                colSpan: 2,
// validators:[{
// type: "custom",
// condition: function (item, validator, value) {
// if(DynamicForm1_Class_JspClass.getValue("startDate") != null && DynamicForm1_Class_JspClass.getValue("termId") != null && DynamicForm1_Class_JspClass.getValue("endDate") !=null) {
// let termStart = DynamicForm1_Class_JspClass.getItem("termId").getSelectedRecord().startDate;
// let termEnd = DynamicForm1_Class_JspClass.getItem("termId").getSelectedRecord().endDate;
// let endDate = DynamicForm1_Class_JspClass.getValue("endDate");
// let startDate = DynamicForm1_Class_JspClass.getValue("startDate");
// if (!checkDate(startDate) && !checkDate(endDate)) {
// return false
// } else if (startDate < termStart && startDate > termEnd) {
// // DynamicForm1_Class_JspClass.addFieldErrors("startDate", "تاریخ انتخاب شده باید بعد از تاریخ شروع ترم باشد", true);
// return false;
// } else if (endDate < startDate) {
// // DynamicForm1_Class_JspClass.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
// return false;
// } else {
// // DynamicForm1_Class_JspClass.clearFieldErrors("startDate", true);
// return true;
// }
// }
// return true;
// },
// }],
                click: function (form) {
                    if (!(form.getValue("termId"))) {
                        dialogTeacher = isc.MyOkDialog.create({
                            message: "ابتدا ترم را انتخاب کنید",
                        });
                        dialogTeacher.addProperties({
                            buttonClick: function () {
                                this.close();
                                form.getItem("termId").selectValue();
// DynamicForm_course_MainTab.getItem("titleFa").selectValue();
                            }
                        });
                    }
                },
                changed: function (form, item, value) {
                    var termStart = form.getItem("termId").getSelectedRecord().startDate;
                    var termEnd = form.getItem("termId").getSelectedRecord().endDate;
                    var dateCheck;
                    var endDate = form.getValue("endDate");
                    dateCheck = checkDate(value);
                    startDateCheck = dateCheck;
                    if (dateCheck === false) {
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (value < termStart) {
                        form.addFieldErrors("startDate", "تاریخ انتخاب شده باید بعد از تاریخ شروع ترم باشد", true);
                    } else if (endDate < value) {
                        form.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else if (termEnd < value) {
                        form.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان ترم باشد", true)
                    } else {
                        form.clearFieldErrors("startDate", true);
                    }
                }
            },
            {
                name: "teachingBrand",
                title: "نحوه آموزش:",
                type: "radioGroup",
// vertical:false,
                rowSpan: 2,
                colSpan: 1,
                fillHorizontalSpace: true,
                defaultValue: 1,
                endRow: true,
                valueMap: {
                    1: "تمام وقت",
                    2: "نیمه وقت",
                    3: "پاره وقت"
                }
// textBoxStyle:"textItemLite"
            },
            {
                name: "endDate",
                titleColSpan: 1,
                title: "<spring:message code='end.date'/>",
                ID: "endDate_jspClass",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        if (!(form.getValue("startDate"))) {
                            dialogTeacher = isc.MyOkDialog.create({
                                message: "ابتدا تاریخ شروع را انتخاب کنید",
                            });
                            dialogTeacher.addProperties({
                                buttonClick: function () {
                                    this.close();
                                    form.getItem("startDate").selectValue();
                                }
                            });
                        } else {
                            closeCalendarWindow();
                            displayDatePicker('endDate_jspClass', this, 'ymd', '/');
                        }
                    }
                }],
                textAlign: "center",
                colSpan: 2,
// validators:[{
// type: "custom",
// condition: function (item, validator, value) {
// let termStart = DynamicForm1_Class_JspClass.getItem("termId").getSelectedRecord().startDate;
// let startDate = form.getValue("startDate");
// if(!checkDate(value)){
// return false
// } else if (value < termStart) {
// // DynamicForm1_Class_JspClass.addFieldErrors("startDate", "تاریخ انتخاب شده باید بعد از تاریخ شروع ترم باشد", true);
// return false;
// } else if (value < startDate) {
// // DynamicForm1_Class_JspClass.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
// return false;
// } else {
// // DynamicForm1_Class_JspClass.clearFieldErrors("startDate", true);
// return true;
// }
// },
// }],
                click: function (form) {
                    if (!(form.getValue("startDate"))) {
                        dialogTeacher = isc.MyOkDialog.create({
                            message: "ابتدا تاریخ شروع را انتخاب کنید",
                        });
                        dialogTeacher.addProperties({
                            buttonClick: function () {
                                this.close();
                                form.getItem("startDate").selectValue();
                            }
                        });
                    }
                },
                changed: function (form, item, value) {
                    let termStart = form.getItem("termId").getSelectedRecord().startDate;
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let startDate = form.getValue("startDate");
                    if (dateCheck === false) {
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheck = false;
                    } else if (value < termStart) {
                        form.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع ترم باشد", true);
                    } else if (value < startDate) {
                        form.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                    } else {
                        form.clearFieldErrors("endDate", true);
                    }
                }
            },
            {
                type: "BlurbItem",
                value: "ساعت جلسات:",
// rowSpan:3
            },
            {
                name: "first",
                type: "checkbox",
                title: "8-10",
                titleOrientation: "top",
                labelAsTitle: true,
                defaultValue: true
            },
            {
                name: "second",
                type: "checkbox",
                title: "10-12",
                titleOrientation: "top",
                labelAsTitle: true,
                defaultValue: true
            },
            {
                name: "third",
                type: "checkbox",
                title: "14-16",
                titleOrientation: "top",
                labelAsTitle: true,
                defaultValue: true
            },
            {
                name: "fourth",
                type: "checkbox",
                title: "12-14",
                titleOrientation: "top",
                labelAsTitle: true,
                disabled: true
            },
            {
                name: "fifth",
                type: "checkbox",
                title: "16-18",
                titleOrientation: "top",
                labelAsTitle: true,
                disabled: true
            },

            {
                type: "BlurbItem",
                value: "روزهای هفته:",
            },
            {
                name: "saturday",
                type: "checkbox",
                title: "شنبه",
                titleOrientation: "top",
                labelAsTitle: true,
                defaultValue: true
            },
            {
                name: "sunday",
                type: "checkbox",
                title: "یکشنبه",
                titleOrientation: "top",
                labelAsTitle: true,
                defaultValue: true
            },
            {
                name: "monday",
                type: "checkbox",
                title: "دوشنبه",
                titleOrientation: "top",
                labelAsTitle: true,
                defaultValue: true
            },
            {
                name: "tuesday",
                type: "checkbox",
                title: "سه&#8202شنبه",
                titleOrientation: "top",
                labelAsTitle: true,
                endRow: true,
                defaultValue: true
            },
            {
                name: "wednesday",
                type: "checkbox",
                title: "چهارشنبه",
                titleOrientation: "top",
                labelAsTitle: true,
                defaultValue: true
            },
            {name: "thursday", type: "checkbox", title: "پنجشنبه", titleOrientation: "top", labelAsTitle: true},
            {name: "friday", type: "checkbox", title: "جمعه", titleOrientation: "top", labelAsTitle: true},
        ],
    });

    var IButton_Class_Exit_JspClass = isc.IButtonCancel.create({
        <%--icon: "<spring:url value="remove.png"/>",--%>
        align: "center",
        click: function () {
            Window_Class_JspClass.close();
        }
    });

    var IButton_Class_Save_JspClass = isc.IButtonSave.create({
        align: "center",
        click: function () {
            if (!checkValidDate(DynamicForm1_Class_JspClass.getItem("termId").getSelectedRecord().startDate, DynamicForm1_Class_JspClass.getItem("termId").getSelectedRecord().endDate, DynamicForm1_Class_JspClass.getValue("startDate"), DynamicForm1_Class_JspClass.getValue("endDate"))) {
                return;
            }
// if (startDateCheck === false || endDateCheck === false)
// return;
            autoValid = DynamicForm1_Class_JspClass.getValue("autoValid");
            if (DynamicForm1_Class_JspClass.getValue("autoValid")) {
                if (!(DynamicForm1_Class_JspClass.getValue("first") || DynamicForm1_Class_JspClass.getValue("second") || DynamicForm1_Class_JspClass.getValue("third"))) {
                    isc.MyOkDialog.create({
                        message: "به منظور تولید اتوماتیک جلسات حداقل یک ساعت جلسه، باید انتخاب شود.",
                    });
                    return;
                } else if (!(DynamicForm1_Class_JspClass.getValue("saturday") || DynamicForm1_Class_JspClass.getValue("sunday") || DynamicForm1_Class_JspClass.getValue("monday") ||
                    DynamicForm1_Class_JspClass.getValue("tuesday") || DynamicForm1_Class_JspClass.getValue("wednesday") || DynamicForm1_Class_JspClass.getValue("thursday") || DynamicForm1_Class_JspClass.getValue("friday"))) {
                    isc.MyOkDialog.create({
                        message: "به منظور تولید اتوماتیک جلسات باید حداقل یکی از روزهای هفته را انتخاب کنید.",
                    });
                    return;
                }
            }
            // if (VM_JspClass.hasErrors()) {
            //     return;
            // }
            VM_JspClass.validate();
            if (VM_JspClass.hasErrors()) {
                return;
            }
            var data = VM_JspClass.getValues();
            data.courseId = data.course.id;
            delete data.course;
            delete data.term;
            if (data.scoringMethod == "1") {

                data.acceptancelimit = data.acceptancelimit_a
            }
            var classSaveUrl = classUrl;
            if (classMethod.localeCompare("PUT") === 0) {
                var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                classSaveUrl += classRecord.id;
            }
            isc.RPCManager.sendRequest({
                actionURL: classSaveUrl,
                httpMethod: classMethod,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {


                        if (classMethod.localeCompare("PUT") === 0) {
                            sendEndingClassToWorkflow();
                            sendToWorkflowAfterUpdate(JSON.parse(resp.data));
                        }

                        ListGrid_Class_refresh();
                        var responseID = JSON.parse(resp.data).id;
                        var gridState = "[{id:" + responseID + "}]";
                        simpleDialog("انجام فرمان", "عملیات با موفقیت انجام شد.", 3000, "say");
                        setTimeout(function () {
                            ListGrid_Class_JspClass.setSelectedState(gridState);
                            ListGrid_Class_JspClass.scrollToRow(ListGrid_Class_JspClass.getRecordIndex(ListGrid_Class_JspClass.getSelectedRecord()), 0);
                        }, 3000);
                        Window_Class_JspClass.close();

                        //**********generate class sessions**********
                        if (!VM_JspClass.hasErrors() && classMethod.localeCompare("POST") === 0) {
                            if (autoValid) {
                                ClassID = JSON.parse(resp.data).id;
                                isc.RPCManager.sendRequest({
                                    actionURL: sessionServiceUrl + "generateSessions" + "/" + ClassID,
                                    httpMethod: "POST",
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    showPrompt: false,
                                    data: JSON.stringify(data),
                                    serverOutputAsString: false,
                                    callback: "GenerateClassSessionsCallback()"
                                });
                            }
                        }
                        //**********generate class sessions**********

                    } else {
                        simpleDialog("پیغام", "اجرای عملیات با مشکل مواجه شده است!", "3000", "error");
                    }

                }
            });

// isc.RPCManager.sendRequest(TrDSRequest(classSaveUrl, classMethod, JSON.stringify(data), "callback: class_action_result(rpcResponse)"));
        }
    });

    var HLayOut_ClassSaveOrExit_JspClass = isc.TrHLayoutButtons.create({
        members: [IButton_Class_Save_JspClass, IButton_Class_Exit_JspClass]
    });

    var VLayOut_FormClass_JspClass = isc.TrVLayout.create({
        margin: 10,
        members: [DynamicForm_Class_JspClass, DynamicForm1_Class_JspClass]
    });

    var Window_Class_JspClass = isc.Window.create({
        title: "<spring:message code='class'/>",
        // width: "90%",
        minWidth: 1024,
        // autoSize: false,
        // height: "87%",
        keepInParentRect: true,
        placement: "fillPanel",
        // align: "center",
        // border: "1px solid gray",
// show: function () {
// this.Super("show", arguments);
// for (i = 0; i < document.getElementsByClassName("textItemLiteRTL").length; i++) {
// document.getElementsByClassName("textItemLiteRTL")[i].style.borderRadius = "5px";
// }
// ;
// for (j = 0; j < document.getElementsByClassName("selectItemLiteControlRTL").length; j++) {
// document.getElementsByClassName("selectItemLiteControlRTL")[j].style.borderRadius = "5px";
// }
// ;
// for (c = 0; c < document.getElementsByClassName("formCellDisabledRTL").length; c++) {
// document.getElementsByClassName("formCellDisabledRTL")[c].style.borderRadius = "5px";
// }
// ;
// },
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            members: [VLayOut_FormClass_JspClass, HLayOut_ClassSaveOrExit_JspClass]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Add Student Section*/
    //--------------------------------------------------------------------------------------------------------------------//

    var DynamicForm_ClassStudentHeaderGridHeader_JspClass = isc.DynamicForm.create({
        titleWidth: 400,
        width: 700,
        align: "right",
        fields: [
            {name: "id", type: "hidden", title: ""},
            {
                name: "course.titleFa",
                type: "staticText",
                title: "<spring:message code='course.title'/>",
                wrapTitle: false,
                width: 250
            },
            {
                name: "group",
                type: "staticText",
                title: "<spring:message code='group'/>",
                wrapTitle: false,
                width: 250
            }
        ]
    });

    var ListGrid_All_Students_JspClass = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        dragTrackerMode: "none",
        dataSource: RestDataSource_Class_Student_JspClass,
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
        canDragSelect: false,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='row'/>",
            width: 50
        },
        fields: [
            {name: "id", hidden: true},
            {name: "lastNameFa", title: "<spring:message code='firstName'/>", align: "center"},
            {name: "studentID", title: "<spring:message code='student.ID'/>", align: "center"}
        ],
        recordDoubleClick: function (viewer, record) {
            var StudentID = record.id;
            var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            var ClassID = ClassRecord.id;
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "addStudent/" + StudentID + "/" + ClassID, "POST", null, "callback: class_add_student_result(rpcResponse)"));
        },
        dataPageSize: 50
    });

    var ListGrid_Current_Students_JspClass = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        canDragRecordsOut: false,
        dragTrackerMode: "none",
        canAcceptDroppedRecords: true,
        canReorderRecords: true,
        alternateRecordStyles: true,
        alternateFieldStyles: false,
        dataSource: RestDataSource_Class_CurrentStudent_JspClass,
        canDragSelect: true,
        autoFetchData: false,
        showRowNumbers: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        rowNumberFieldProperties: {
            autoFitWidthApproach: "both",
            canDragResize: true,
            autoFitWidth: false,
            headerTitle: "<spring:message code='row'/>",
            width: 50
        },
        canEdit: true,
        editEvent: "click",
        editByCell: true,
        rowEndEditAction: "done",
        listEndEditAction: "next",
        fields: [
            {name: "id", hidden: true},
            {
                name: "lastNameFa", title: "<spring:message
        code='firstName'/>", align: "center", width: "25%", canEdit: false
            },
            {
                name: "studentID",
                title: "<spring:message code='student.ID'/>",
                align: "center",
                width: "25%",
                canEdit: false
            },
            {name: "iconDelete", title: "<spring:message code='remove'/>", width: "15%", align: "center"}
        ],

        recordDrop: function (dropRecords) {
            var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
            var ClassID = ClassRecord.id;
            var StudentID = [];
            for (var i = 0; i < dropRecords.getLength(); i++) {
                StudentID.add(dropRecords[i].id);
            }
            var JSONObj = {"ids": StudentID};
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "addStudents/" + ClassID, "POST", JSON.stringify(JSONObj), "callback: class_add_students_result(rpcResponse)"));
        },

        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName === "iconDelete") {
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
                    prompt: "<spring:message code='remove'/>",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var ClassRecord = ListGrid_Class_JspClass.getSelectedRecord();
                        var ClassID = ClassRecord.id;
                        var StudentID = record.id;
                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "removeStudent/" + StudentID + "/" + ClassID, "DELETE", null, "callback: class_remove_student_result(rpcResponse)"));
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },
        dataPageSize: 50
    });

    var SectionStack_All_Student_JspClass = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "<spring:message code='unregistred.students'/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_All_Students_JspClass
                ]
            }
        ]
    });

    var SectionStack_Current_Student_JspClass = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "<spring:message code='registred.students'/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_Current_Students_JspClass
                ]
            }
        ]
    });

    var HStack_ClassStudent_JspClass = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_All_Student_JspClass,
            SectionStack_Current_Student_JspClass
        ]
    });

    var HLayOut_ClassStudentGridHeader_JspClass = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",
        members: [
            DynamicForm_ClassStudentHeaderGridHeader_JspClass
        ]
    });

    var VLayOut_ClassStudent_JspClass = isc.VLayout.create({
        width: "100%",
        height: 400,
        autoDraw: false,
        border: "0px solid red", layoutMargin: 5,
        members: [
            HLayOut_ClassStudentGridHeader_JspClass,
            HStack_ClassStudent_JspClass
        ]
    });

    var Window_AddStudents_JspClass = isc.Window.create({
        title: "<spring:message code='students.list'/>",
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
        },
        items: [
            VLayOut_ClassStudent_JspClass
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Refresh_JspClass = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Class_refresh();
        }
    });

    var ToolStripButton_Edit_JspClass = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_class_edit();
        }
    });

    var ToolStripButton_Add_JspClass = isc.ToolStripButtonAdd.create({
        click: function () {
            ListGrid_Class_add();
        }
    });

    var ToolStripButton_Remove_JspClass = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_class_remove();
        }
    });

    var ToolStripButton_Print_JspClass = isc.ToolStripButtonPrint.create({
//icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            ListGrid_class_print("pdf");
        }
    });

    var ToolStripButton_copy_of_class = isc.ToolStripButton.create({
        title: "<spring:message code='copy.of.class'/>",
        click: function () {
            ListGrid_class_edit(1);
            setTimeout(function () {
                evalGroup();
            }, 200);
            setTimeout(function () {
                classCode();
            }, 700);
        }
    });

    var ToolStrip_Actions_JspClass = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add_JspClass,
            ToolStripButton_Edit_JspClass,
            ToolStripButton_Remove_JspClass,
            ToolStripButton_Print_JspClass,
            ToolStripButton_copy_of_class,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_JspClass,
                ]
            })

        ]
    });

    var HLayout_Actions_Class_JspClass = isc.HLayout.create({
        width: "100%",
        height: "1%",
        members: [ToolStrip_Actions_JspClass]
    });

    var HLayout_Grid_Class_JspClass = isc.TrHLayout.create({
        showResizeBar: true,
        width: "100%",
        height: "60%",
        members: [ListGrid_Class_JspClass]
    });

    var TabSet_Class = isc.TabSet.create({
        ID: "tabSetClass",
        enabled: false,
        tabBarPosition: "top",
        tabs: [
            {
                ID: "classSessionsTab",
                title: "<spring:message code="sessions"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/sessions-tab"})
            },
            {
                ID: "classCheckListTab",
                name: "checkList",
                title: "<spring:message code="checkList"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/checkList-tab"})
            },
            {
                ID: "classStudentsTab",
                title: "<spring:message code="student.plural"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/student"})
            },
            {
                ID: "classAttachmentsTab",
                title: "<spring:message code="attachments"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/attachments-tab"})
            },
            {
                ID: "classAttendanceTab",
                title: "<spring:message code="attendance"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/attendance-tab"})
            },
            {
                ID: "classScoresTab",
                name: "scores",
                title: "<spring:message code="register.scores"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/scores-tab"})
            },
            {
                ID: "classAlarmsTab",
                title: "<spring:message code="alarms"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/alarms-tab"})
            },
            {
                ID: "classPreCourseTestQuestionsTab",
                title: "<spring:message code='class.preCourseTestQuestion'/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/pre-course-test-questions-tab"})
            }

        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
            if (isc.Page.isLoaded())
                refreshSelectedTab_class(tab);
        }
    });

    var HLayout_Tab_Class = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [TabSet_Class]
    });

    var VLayout_Body_Class_JspClass = isc.TrVLayout.create({
        members: [
            HLayout_Actions_Class_JspClass,
            HLayout_Grid_Class_JspClass,
            // HLayout_Tab_Class
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_class_remove() {
        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Class_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Class_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        classWait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + record.id, "DELETE", null, "callback: class_delete_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function ListGrid_class_edit(a = 0) {
        let record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            RestDataSource_Teacher_JspClass.fetchDataURL = teacherUrl + "fullName-list";
            RestDataSource_TrainingPlace_JspClass.fetchDataURL = instituteUrl + record.instituteId + "/training-places";
            VM_JspClass.clearErrors(true);
            VM_JspClass.clearValues();
            VM_JspClass.editRecord(record);
            if (a === 0) {
                saveButtonStatus();
                classMethod = "PUT";
                url = classUrl + record.id;
                Window_Class_JspClass.setTitle("<spring:message code="edit"/>" + " " + "<spring:message code="class"/>");
                Window_Class_JspClass.show();
                //=========================
                DynamicForm_Class_JspClass.getItem("scoringMethod").change(DynamicForm_Class_JspClass, DynamicForm_Class_JspClass.getItem("scoringMethod"), DynamicForm_Class_JspClass.getValue("scoringMethod"));
                if (ListGrid_Class_JspClass.getSelectedRecord().scoringMethod === "1") {

                    DynamicForm_Class_JspClass.setValue("acceptancelimit_a", ListGrid_Class_JspClass.getSelectedRecord().acceptancelimit);
                } else {
                    DynamicForm_Class_JspClass.setValue("acceptancelimit", ListGrid_Class_JspClass.getSelectedRecord().acceptancelimit);
                }
                //================
                DynamicForm1_Class_JspClass.setValue("autoValid", false);
                getDaysOfClass(ListGrid_Class_JspClass.getSelectedRecord().id);
                if (record.course.evaluation === "1") {
                    DynamicForm_Class_JspClass.setValue("preCourseTest", false);
                    DynamicForm_Class_JspClass.getItem("preCourseTest").hide();
                } else
                    DynamicForm_Class_JspClass.getItem("preCourseTest").show();
            } else {
                classMethod = "POST";
                url = classUrl;
                Window_Class_JspClass.setTitle("<spring:message code="create"/>" + " " + "<spring:message code="class"/>");
                Window_Class_JspClass.show();
                DynamicForm1_Class_JspClass.setValue("autoValid", true);
            }

// RestDataSource_Teacher_JspClass.fetchDataURL = teacherUrl + "fullName-list/" + VM_JspClass.getField("course.id").getSelectedRecord().category.id;
        }
    }

    function ListGrid_Class_refresh() {
        var gridState;
        if (ListGrid_Class_JspClass.getSelectedRecord()) {
            gridState = "[{id:" + ListGrid_Class_JspClass.getSelectedRecord().id + "}]";
        }
        ListGrid_Class_JspClass.invalidateCache();
        ListGrid_Class_JspClass.filterByEditor();
        setTimeout(function () {
            ListGrid_Class_JspClass.setSelectedState(gridState);
        }, 3000);
        refreshSelectedTab_class(tabSetClass.getSelectedTab());
    }

    function ListGrid_Class_add() {
        classMethod = "POST";
        url = classUrl;
        VM_JspClass.clearErrors();
        VM_JspClass.clearValues();
        Window_Class_JspClass.setTitle("<spring:message code="create"/>" + " " + "<spring:message code="class"/>");
        Window_Class_JspClass.show();
        DynamicForm_Class_JspClass.getItem("preCourseTest").hide();
    }

    function ListGrid_class_print(type) {
        var advancedCriteria = ListGrid_Class_JspClass.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "GET",
            action: "<spring:url value="/tclass/printWithCriteria/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"}
                ]
        });
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function classCode() {
        VM_JspClass.getItem("code").setValue(VM_JspClass.getItem("course.id").getSelectedRecord().code + "-" + VM_JspClass.getItem("termId").getSelectedRecord().code + "-" + VM_JspClass.getValue("group"));
    }

    function evalGroup() {
        tid = VM_JspClass.getValue("termId");
        cid = VM_JspClass.getValue("course.id");
        if (tid && cid) {
            isc.RPCManager.sendRequest({
                actionURL: classUrl + "end_group/" + cid + "/" + tid,
                httpMethod: "GET",
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        VM_JspClass.getItem("group").setValue(JSON.parse(resp.data));
                        classCode();
                    }
                }
            });

        }
    }

    function class_action_result(resp) {

        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

            var courseId = JSON.parse(resp.data).courseId;

            var VarParams = [{
                "processKey": "ClassWorkFlow",
                "cId": JSON.parse(resp.data).id,
                "code": JSON.parse(resp.data).code,
                "course": DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().code,
                "coursetitleFa": DynamicForm_Class_JspClass.getItem("course.titleFa").getValue(),
                "startDate": JSON.parse(resp.data).startDate,
                "endDate": JSON.parse(resp.data).endDate,
                // "classCreator": "classCreator",
                "classCreatorId": "${username}",
                "classCreator": userFullName,
                "REJECT": "",
                "REJECTVAL": "",
                "target": "/tclass/show-form",
                "targetTitleFa": "کلاس"
            }]
            if (classMethod.localeCompare("POST") === 0) {
                isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(VarParams), "callback:startProcess(rpcResponse)"));
            }

            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                var responseID = JSON.parse(resp.data).id;
                var gridState = "[{id:" + responseID + "}]";
                ListGrid_Class_JspClass.setSelectedState(gridState);
                OK.close();

            }, 1000);
            ListGrid_Class_refresh();
            Window_Class_JspClass.close();
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function startProcess(resp) {

        if (resp.httpResponseCode === 200)
            isc.say("<spring:message code="course.set.on.workflow.engine"/>");
        else {
            isc.say("کد خطا : " + resp.httpResponseCode);
        }
    }

    function class_delete_result(resp) {
        classWait.close();
        if (resp.httpResponseCode === 200) {
            ListGrid_Class_JspClass.invalidateCache();
            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
            refreshSelectedTab_class(tabSetClass.getSelectedTab());
        } else if (resp.httpResponseCode === 406 && resp.httpResponseText === "NotDeletable") {
            createDialog("info", "<spring:message code='global.grid.record.cannot.deleted'/>");
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function class_remove_student_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Current_Students_JspClass.invalidateCache();
            ListGrid_All_Students_JspClass.invalidateCache();
        } else {
            isc.say("<spring:message code='error'/>");
        }
    }

    function class_add_student_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Current_Students_JspClass.invalidateCache();
            ListGrid_All_Students_JspClass.invalidateCache();
        } else {
            isc.say("<spring:message code='error'/>");
        }
    }

    function class_add_students_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Current_Students_JspClass.invalidateCache();
            ListGrid_All_Students_JspClass.invalidateCache();
        } else {
            isc.say("<spring:message code='error'/>");
        }
    }

    var abc;

    function GetScoreState(resp, a) {
        abc = new Array()
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
        } else if (resp.httpResponseCode === 406) {

            //alert(JSON.pars(resp.httpResponseText))
            var Dialog_Remove_scoreState = createDialog("ask", +"کاربر گرامی برای این کلاس فراگیرانی با روش نمره دهی قبلی ثبت شده آیا می خواهید با تغییر روش نمره دهی نمرات ثبت شده برای فراگیران این کلاس حذف شوند؟",
                "<spring:message code="verify.delete"/>");
            Dialog_Remove_scoreState.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {

                    }
                }
            });
        }

    }

    function Add_Student() {
        var record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            ListGrid_All_Students_JspClass.invalidateCache();
            ListGrid_Current_Students_JspClass.invalidateCache();
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.invalidateCache();
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("course.titleFa", record.course.titleFa);
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("group", record.group);
            DynamicForm_ClassStudentHeaderGridHeader_JspClass.setValue("id", record.id);
            ListGrid_All_Students_JspClass.fetchData({"classID": record.id});
            ListGrid_Current_Students_JspClass.fetchData({"classID": record.id});
            Window_AddStudents_JspClass.show();
        }
    }

    function GenerateClassSessionsCallback() {
        refreshSelectedTab_class(tabSetClass.getSelectedTab());
    }

    function refreshSelectedTab_class(tab) {
        let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        tabSet_class_status(classRecord);
        if (!(classRecord == undefined || classRecord == null)) {
            switch (tab.ID) {
                case "classStudentsTab": {
                    if (typeof loadPage_student !== "undefined")
                        loadPage_student();
                    break;
                }
                case "classSessionsTab": {
                    if (typeof loadPage_session !== "undefined")
                        loadPage_session();
                    break;
                }
                case "classCheckListTab": {
                    if (typeof loadPage_checkList !== "undefined")
                        loadPage_checkList();
                    break;
                }
                case "classAttachmentsTab": {
                    let readOnly = ListGrid_Class_JspClass.getSelectedRecord().workflowEndingStatusCode === 2;
                    if (typeof loadPage_attachment !== "undefined")
                        loadPage_attachment("Tclass", ListGrid_Class_JspClass.getSelectedRecord().id, "<spring:message code="attachment"/>", {
                            1: "جزوه",
                            2: "لیست نمرات",
                            3: "لیست حضور و غیاب",
                            4: "نامه غیبت موجه"
                        }, readOnly);
                    break;
                }
                case "classScoresTab": {
                    if (typeof loadPage_Scores !== "undefined")
                        loadPage_Scores();
                    break;
                }
                case "classAttendanceTab": {
                    if (typeof loadPage_Attendance !== "undefined")
                        loadPage_Attendance();
                    break;
                }
                case "classAlarmsTab": {
                    if (typeof loadPage_alarm !== "undefined")
                        loadPage_alarm();
                    break;
                }
                case "classPreCourseTestQuestionsTab": {
                    if (typeof loadPage_preCourseTestQuestions !== "undefined")
                        loadPage_preCourseTestQuestions(ListGrid_Class_JspClass.getSelectedRecord().id);
                    break;
                }
            }
        }
    }

    function checkValidDate(termStart, termEnd, classStart, classEnd) {
        if (termStart != null && termEnd != null && classStart != null && classEnd != null) {
            if (!checkDate(classStart)) {
                createDialog("info", "فرمت تاریخ شروع صحیح نیست.", "<spring:message code='message'/>");
                return false;
            }
            if (!checkDate(classEnd)) {
                createDialog("info", "فرمت تاریخ پایان صحیح نیست.", "<spring:message code='message'/>");
                return false;
            }
            if (classEnd < classStart) {
                createDialog("info", "تاریخ پایان کلاس قبل از تاریخ شروع کلاس نمی تواند باشد.", "<spring:message code='message'/>");
                return false;
            }
            if (termStart > classStart) {
                createDialog("info", "تاریخ شروع کلاس قبل از تاریخ شروع ترم نمی تواند باشد.", "<spring:message code='message'/>");
                return false;
            }
            if (termEnd < classStart) {
                createDialog("info", "تاریخ شروع کلاس بعد از تاریخ پایان ترم نمی تواند باشد.", "<spring:message code='message'/>");
                return false;
            }
            return true;
        }
        return false;
    }

    function getDaysOfClass(classId) {
        isc.RPCManager.sendRequest({
            actionURL: attendanceUrl + "/session-date?classId=" + classId,
            httpMethod: "GET",
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            showPrompt: false,
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    let result = JSON.parse(resp.data).response.data;
                    DynamicForm_Class_JspClass.setValue("dDuration", result.length);
                }
            }
        });
    }

    function tabSet_class_status(classRecord) {
        if (ListGrid_Class_JspClass.getSelectedRecord() === null) {
            TabSet_Class.disable();
            return;
        }
        TabSet_Class.enable();
        if (classRecord.preCourseTest)
            TabSet_Class.enableTab("classPreCourseTestQuestionsTab");
        else
            TabSet_Class.disableTab("classPreCourseTestQuestionsTab");
    }

    //*****check class is ready to end or no*****
    function checkEndingClass(oldValue) {
        let record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record !== null)

            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "checkEndingClass/" + record.id, "GET", null, function (resp) {

                if (resp.data !== "") {
                    TabSet_Class.selectTab("classAlarmsTab");
                    isc.Dialog.create({
                        message: resp.data,
                        icon: "[SKIN]ask.png",
                        title: "<spring:message code="message"/>",
                        buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });

                    classTypeStatus.setValue(oldValue);
                }

            }));
    }


    // <<---------------------------------------- Send To Workflow ----------------------------------------
    function sendEndingClassToWorkflow() {

        let sRecord = VM_JspClass.getValues();


        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "getWorkflowEndingStatusCode/" + sRecord.id, "GET", null, function (resp) {

            let workflowStatusCode = resp.data;

            if (classMethod.localeCompare("PUT") === 0 && sRecord.classStatus === "3" && (workflowStatusCode === "" || workflowStatusCode === "-3")) {
                let varParams = [{
                    "processKey": "endingClassWorkflow",
                    "cId": parseInt(sRecord.id),
                    "classCode": sRecord.code,
                    "titleClass": sRecord.titleClass,
                    "teacher": sRecord.teacher,
                    "term": sRecord.term.titleFa,
                    "classCreatorId": "${username}",
                    "classCreator": userFullName,
                    "REJECTVAL": "",
                    "REJECT": "",
                    "target": "/tclass/show-form",
                    "targetTitleFa": "کلاس",
                    "workflowStatus": "درخواست پایان کلاس",
                    "workflowStatusCode": "0"
                }];

                isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), startProcess_callback));
            }

        }));

    }

    function startProcess_callback(resp) {

        if (resp.httpResponseCode == 200) {
            isc.say("<spring:message code='course.set.on.workflow.engine'/>");
            ListGrid_Class_refresh()
        } else {
            isc.say("<spring:message code='workflow.bpmn.not.uploaded'/>");
        }
    }

    var class_workflowParameters = null;

    function selectWorkflowRecord() {

        if (workflowRecordId !== null) {

            class_workflowParameters = workflowParameters;

            let gridState = "[{id:" + workflowRecordId + "}]";

            ListGrid_Class_JspClass.setSelectedState(gridState);

            ListGrid_Class_JspClass.scrollToRow(ListGrid_Class_JspClass.getRecordIndex(ListGrid_Class_JspClass.getSelectedRecord()), 0);

            workflowRecordId = null;
            workflowParameters = null;

            ListGrid_class_edit();
            taskConfirmationWindow.maximize();
        }

    }

    function sendToWorkflowAfterUpdate(selectedRecord) {

        var sRecord = selectedRecord;

        if (sRecord !== null && sRecord.id !== null && class_workflowParameters !== null) {

            if (sRecord.workflowEndingStatusCode === -1 || sRecord.workflowEndingStatusCode === -2) {

                class_workflowParameters.workflowdata["REJECT"] = "N";
                class_workflowParameters.workflowdata["REJECTVAL"] = " ";
                class_workflowParameters.workflowdata["classCode"] = sRecord.code;
                class_workflowParameters.workflowdata["titleClass"] = sRecord.titleClass;
                class_workflowParameters.workflowdata["teacher"] = sRecord.teacher;
                class_workflowParameters.workflowdata["term"] = sRecord.term.titleFa;
                class_workflowParameters.workflowdata["classCreatorId"] = "${username}";
                class_workflowParameters.workflowdata["classCreator"] = userFullName;
                class_workflowParameters.workflowdata["workflowStatus"] = "اصلاح پایان کلاس";
                class_workflowParameters.workflowdata["workflowEndingStatusCode"] = "20";

                var ndat = class_workflowParameters.workflowdata;

                isc.RPCManager.sendRequest({
                    actionURL: workflowUrl + "/doUserTask",
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    httpMethod: "POST",
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    showPrompt: false,
                    data: JSON.stringify(ndat),
                    params: {"taskId": class_workflowParameters.taskId, "usr": class_workflowParameters.usr},
                    serverOutputAsString: false,
                    callback: function (RpcResponse_o) {
                        if (RpcResponse_o.data === 'success') {

                            ListGrid_Class_refresh();

                            let responseID = sRecord.id;

                            let gridState = "[{id:" + responseID + "}]";

                            ListGrid_Class_JspClass.setSelectedState(gridState);

                            ListGrid_Class_JspClass.scrollToRow(ListGrid_Class_JspClass.getRecordIndex(ListGrid_Class_JspClass.getSelectedRecord()), 0);

                            isc.say("پایان کلاس ویرایش و به گردش کار ارسال شد");
                            taskConfirmationWindow.hide();
                            taskConfirmationWindow.maximize();
                            ListGrid_UserTaskList.invalidateCache();
                        }
                    }
                });

            }
        }


    }

    // ---------------------------------------- Send To Workflow ---------------------------------------->>


    //*****set save button status*****
    function saveButtonStatus() {

        if ("${username}" === "ahmadi_z") {

            IButton_Class_Save_JspClass.enable();
            IButton_Class_Save_JspClass.setOpacity(100);

            return;
        }

        let sRecord = VM_JspClass.getValues();

        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "getWorkflowEndingStatusCode/" + sRecord.id, "GET", null, function (resp) {

            let workflowStatusCode = resp.data;

            if (sRecord.classStatus === "3") {
                if (workflowStatusCode === "-1" || workflowStatusCode === "-2" || workflowStatusCode === "-3" || workflowStatusCode === "") {
                    IButton_Class_Save_JspClass.enable();
                    IButton_Class_Save_JspClass.setOpacity(100);
                } else {
                    IButton_Class_Save_JspClass.disable();
                    IButton_Class_Save_JspClass.setOpacity(30);
                }
            } else {
                IButton_Class_Save_JspClass.enable();
                IButton_Class_Save_JspClass.setOpacity(100);
            }

        }));

    }