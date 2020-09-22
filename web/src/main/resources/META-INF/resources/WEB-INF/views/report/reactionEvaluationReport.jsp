<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var isCriteriaCategoriesChanged_RER = false;
    var startDate1Check_RER = true;
    var startDate2Check_RER = true;
    var startDateCheck_Order_RER = true;
    var endDate1Check_RER = true;
    var endDate2Check_RER = true;
    var endDateCheck_Order_RER = true;

    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='tclassCode']").attr("disabled","disabled");
        },0)}
    );

    var data_values = null;

    var courseInfo_print = "";
    var classTimeInfo_print = "";
    var executionInfo_print = "";
    var evaluationInfo_print = "";

    var titr = isc.HTMLFlow.create({
        align: "center",
        border: "1px solid black",
        width: "25%"
    });
    var courseInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var classTimeInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var executionInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var reactionEvaluationInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var learningEvaluationInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var behavioralEvaluationInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var evaluationInfo = isc.HTMLFlow.create({
        align: "center"
    });
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    var RestDataSource_Category_RER = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_SubCategory_RER = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Class_RER = isc.TrDS.create({
        ID: "RestDataSource_Class_RER",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    var RestDataSource_Term_RER = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_Year_RER = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });

    var RestDataSource_Teacher_RER = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.firstNameFa", filterOperator: "iContains"},
            {name: "personality.lastNameFa", filterOperator: "iContains"},
            {name: "personality.nationalCode", filterOperator: "iContains"},
            {name: "fullNameFa"}
        ],
        fetchDataURL: teacherUrl + "fullName"
    });

    var RestDataSource_Institute_RER = isc.TrDS.create({
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
        allowAdvancedCriteria: true
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_RER = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "tclassCode",
                title: "کد کلاس",
                hint: "کد کلاس را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectClasses_RER.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },
            {
                name: "startDate1",
                ID: "startDate1_RER",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_RER', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_RER = true;
                        startDate1Check_RER = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_RER = false;
                        startDateCheck_Order_RER = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_RER = false;
                        startDate1Check_RER = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_RER = true;
                        startDateCheck_Order_RER = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_RER",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_RER', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_RER = true;
                        startDate2Check_RER = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_RER = false;
                        startDateCheck_Order_RER = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_RER = true;
                        startDateCheck_Order_RER = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_RER = true;
                        startDateCheck_Order_RER = true;
                    }
                }
            },
            {
                name: "temp4",
                title: "",
                canEdit: false
            },
            {
                name: "endDate1",
                ID: "endDate1_RER",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_RER', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_RER = true;
                        endDate1Check_RER = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_RER = false;
                        endDateCheck_Order_RER = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_RER = false;
                        endDate1Check_RER = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_RER = true;
                        endDateCheck_Order_RER = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_RER",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_RER', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_RER = true;
                        endDate2Check_RER = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_RER = false;
                        endDateCheck_Order_RER = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_RER = true;
                        endDateCheck_Order_RER = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_RER = true;
                        endDateCheck_Order_RER = true;
                    }
                }
            },
            {
                name: "temp5",
                title: "",
                canEdit: false
            },
            {
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_RER,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                changed: function () {
                    isCriteriaCategoriesChanged_RER = true;
                    var subCategoryField = DynamicForm_CriteriaForm_RER.getField("courseSubCategory");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    var categoryIds = this.getValue();
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
                name: "courseSubCategory",
                title: "زیرگروه کاری",
                type: "SelectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_RER,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                focus: function () {
                    if (isCriteriaCategoriesChanged_RER) {
                        isCriteriaCategoriesChanged_RER = false;
                        var ids = DynamicForm_CriteriaForm_RER.getField("courseCategory").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_RER.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_RER.implicitCriteria = {
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
                name: "temp6",
                title: "",
                canEdit: false
            },
            {
                name: "tclassYear",
                title: "سال کاری",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_RER,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
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
                                        var item = DynamicForm_CriteriaForm_RER.getField("tclassYear"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].year;
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
                                        var item = DynamicForm_CriteriaForm_RER.getField("tclassYear");
                                        item.setValue([]);
                                        item.pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                },
                changed: function (form, item, value) {
                    if (value != null && value != undefined && value.size() == 1) {
                        RestDataSource_Term_RER.fetchDataURL = termUrl + "listByYear/" + value[0];
                        DynamicForm_CriteriaForm_RER.getField("termId").optionDataSource = RestDataSource_Term_RER;
                        DynamicForm_CriteriaForm_RER.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_RER.getField("termId").enable();
                    } else {
                        form.getField("termId").disabled = true;
                        form.getField("termId").clearValue();
                    }
                }
            },
            {
                name: "termId",
                title: "ترم",
                type: "SelectItem",
                multiple: true,
                filterOperator: "equals",
                disabled: true,
                valueField: "id",
                displayField: "titleFa",
                filterLocally: true,
                pickListProperties: {
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
                                        var item = DynamicForm_CriteriaForm_RER.getField("termId"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].id;
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
                                        var item = DynamicForm_CriteriaForm_RER.getField("termId");
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
                name: "temp7",
                title: "",
                canEdit: false
            },
            {
                name: "teacherId",
                title: "مدرس",
                type: "ComboBoxItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Teacher_RER,
                valueField: "id",
                displayField: "fullNameFa",
                filterFields: ["personality.firstNameFa", "personality.lastNameFa", "personality.nationalCode"],
                pickListFields: [
                    {name: "personality.firstNameFa", title: "نام"},
                    {name: "personality.lastNameFa", title: "نام خانوادگی"},
                    {name: "personality.nationalCode", title: "کد ملی"}],
                pickListProperties: {
                    showFilterEditor: true
                }
            },
            {
                name: "tclassOrganizerId",
                title: "برگزار کننده",
                editorType: "TrComboAutoRefresh",
                optionDataSource: RestDataSource_Institute_RER,
                displayField: "titleFa",
                filterOperator: "equals",
                valueField: "id",
                textAlign: "center",
                filterFields: ["titleFa", "titleFa"],
                showHintInField: true,
                hint: "موسسه",
                pickListWidth: 500,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "titleFa", filterOperator: "iContains"},
                    {name: "manager.firstNameFa", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", filterOperator: "iContains"}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {
                name: "temp8",
                title: "",
                canEdit: false
            },
            {
                name: "teachingType",
                colSpan: 1,
                rowSpan: 3,
                title: "<spring:message code='teaching.type'/>:",
                type: "radioGroup",
                vertical: false,
                fillHorizontalSpace: true,
                defaultValue: "حضوری",
                valueMap: [
                    "حضوری",
                    "غیر حضوری",
                    "مجازی",
                    "عملی و کارگاهی",
                    "آموزش حین کار(OJT)"
                ]
            },
        ]
    });

    //---------------------------------------------------- Class Selection Form ----------------------------------------
    var initialLayoutStyle_RER = "vertical";
    var DynamicForm_SelectClasses_RER = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "class.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "code",
                comboBoxWidth: 500,
                valueField: "code",
                layoutStyle: initialLayoutStyle_RER,
                optionDataSource: RestDataSource_Class_RER
            }
        ]
    });
    DynamicForm_SelectClasses_RER.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_RER.getField("class.code").comboBox.pickListFields = [
        {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
        {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
        {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_RER.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];
    IButton_ConfirmClassesSelections_RER = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClasses_RER.getItem("class.code").getValue();
            if (DynamicForm_SelectClasses_RER.getField("class.code").getValue() != undefined && DynamicForm_SelectClasses_RER.getField("class.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_RER.getField("class.code").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues != undefined) {
                for (let i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }

            if (typeof criteriaDisplayValues != "undefined") {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(","), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(",");
            }

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_RER.getField("tclassCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_RER.close();
        }
    });
    var Window_SelectClasses_RER = isc.Window.create({
        placement: "center",
        title: "انتخاب کلاس ها",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectClasses_RER,
                    IButton_ConfirmClassesSelections_RER
                ]
            })
        ]
    });

    IButton_Confirm_RER = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {
            DynamicForm_CriteriaForm_RER.validate();
            if (DynamicForm_CriteriaForm_RER.hasErrors())
                return;
            if (!DynamicForm_CriteriaForm_RER.validate() ||
                startDateCheck_Order_RER == false ||
                startDate2Check_RER == false ||
                startDate1Check_RER == false ||
                endDateCheck_Order_RER == false ||
                endDate2Check_RER == false ||
                endDate1Check_RER == false) {

                if (startDateCheck_Order_RER == false) {
                    DynamicForm_CriteriaForm_RER.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_RER.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (startDateCheck_Order_RER == false) {
                    DynamicForm_CriteriaForm_RER.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_RER.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (startDate2Check_RER == false) {
                    DynamicForm_CriteriaForm_RER.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_RER.addFieldErrors("startDate2", "<spring:message
        code='msg.correct.date'/>", true);
                }
                if (startDate1Check_RER == false) {
                    DynamicForm_CriteriaForm_RER.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_RER.addFieldErrors("startDate1", "<spring:message
        code='msg.correct.date'/>", true);
                }

                if (endDateCheck_Order_RER == false) {
                    DynamicForm_CriteriaForm_RER.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_RER.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (endDateCheck_Order_RER == false) {
                    DynamicForm_CriteriaForm_RER.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_RER.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (endDate2Check_RER == false) {
                    DynamicForm_CriteriaForm_RER.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_RER.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                }
                if (endDate1Check_RER == false) {
                    DynamicForm_CriteriaForm_RER.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_RER.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                }
                return;
            }
            Reporting();
            trPrintWithCriteria("<spring:url value="/evaluationAnalysis/printReactionEvaluationReport"/>",null,JSON.stringify(data_values));
        }
    });
    //----------------------------------- functions --------------------------------------------------------------------
    function Reporting(){
        data_values = null;
        data_values = DynamicForm_CriteriaForm_RER.getValuesAsAdvancedCriteria();
        var removedObjects = [];
        for (var i = 0; i < data_values.criteria.size(); i++) {

            if (data_values.criteria[i].fieldName == "tclassCode") {
                var codesString = data_values.criteria[i].value;
                var codesArray;
                codesArray = codesString.split(",");
                for (var j = 0; j < codesArray.length; j++) {
                    if (codesArray[j] == "" || codesArray[j] == " ") {
                        codesArray.remove(codesArray[j]);
                    }
                }
                data_values.criteria[i].operator = "equals";
                data_values.criteria[i].value = codesArray;
            }
            else if (data_values.criteria[i].fieldName == "startDate1") {
                data_values.criteria[i].fieldName = "tclassStartDate";
                data_values.criteria[i].operator = "greaterThan";
            }
            else if (data_values.criteria[i].fieldName == "startDate2") {
                data_values.criteria[i].fieldName = "tclassStartDate";
                data_values.criteria[i].operator = "lessThan";
            }
            else if (data_values.criteria[i].fieldName == "endDate1") {
                data_values.criteria[i].fieldName = "tclassEndDate";
                data_values.criteria[i].operator = "greaterThan";
            }
            else if (data_values.criteria[i].fieldName == "endDate2") {
                data_values.criteria[i].fieldName = "tclassEndDate";
                data_values.criteria[i].operator = "lessThan";
            }
            else if(data_values.criteria[i].fieldName == "tclassOrganizerId")
                data_values.criteria[i].operator = "equals";
            else if(data_values.criteria[i].fieldName == "courseCategory"){
                data_values.criteria[i].operator = "inSet";
            }
            else if(data_values.criteria[i].fieldName == "courseSubCategory"){
                data_values.criteria[i].operator = "inSet";
            }
        }
        data_values.criteria.removeList(removedObjects);

        titr.contents = "";
        courseInfo.contents = "";
        classTimeInfo.contents = "";
        executionInfo.contents = "";
        reactionEvaluationInfo.contents = "";
        learningEvaluationInfo.contents = "";
        behavioralEvaluationInfo.contents = "";
        evaluationInfo.contents = "";

        courseInfo_print = "";
        classTimeInfo_print = "";
        executionInfo_print = "";
        evaluationInfo_print = "";

        if (DynamicForm_CriteriaForm_RER.getField("tclassCode").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "کد دوره: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("tclassCode").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=  "کد کلاس: " ;
            courseInfo_print += DynamicForm_CriteriaForm_RER.getField("tclassCode").getDisplayValue();
            courseInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_RER.getField("courseCategory").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "گروه های کاری: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("courseCategory").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print  += "گروه های کاری: " ;
            courseInfo_print  += DynamicForm_CriteriaForm_RER.getField("courseCategory").getDisplayValue() ;
            courseInfo_print  +=   ", " ;
        }
        if (DynamicForm_CriteriaForm_RER.getField("courseSubCategory").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیرگروه های کاری: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("courseSubCategory").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=   "زیرگروه های کاری: " ;
            courseInfo_print  += DynamicForm_CriteriaForm_RER.getField("courseSubCategory").getDisplayValue() ;
            courseInfo_print  += ", " ;
        }

        if (DynamicForm_CriteriaForm_RER.getField("startDate1").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ شروع کلاس: از " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("startDate1").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print += "تاریخ شروع کلاس: از " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_RER.getField("startDate1").getDisplayValue();
            classTimeInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_RER.getField("startDate2").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ شروع کلاس: تا " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("startDate2").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print +=   "تاریخ شروع کلاس: تا ";
            classTimeInfo_print += DynamicForm_CriteriaForm_RER.getField("startDate2");
            classTimeInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_RER.getField("endDate1").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ پایان کلاس: از " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("endDate1").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print +=  "تاریخ پایان کلاس: از " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_RER.getField("endDate1") ;
            classTimeInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_RER.getField("endDate2").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ پایان کلاس: تا " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("endDate2").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print += "تاریخ پایان کلاس: تا " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_RER.getField("endDate2").getDisplayValue();
            classTimeInfo_print += ", " ;
        }
        if (DynamicForm_CriteriaForm_RER.getField("tclassYear").getValue() != null &&
            DynamicForm_CriteriaForm_RER.getField("tclassYear").getValue() != undefined &&
            DynamicForm_CriteriaForm_RER.getField("tclassYear").getValue().size() != 0) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "سال کاری: " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("tclassYear").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print +=  "سال کاری: " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_RER.getField("tclassYear").getValue();
            classTimeInfo_print += ", ";
        }
        if (DynamicForm_CriteriaForm_RER.getField("termId").getValue() != null &&
            DynamicForm_CriteriaForm_RER.getField("termId").getValue() != undefined &&
            DynamicForm_CriteriaForm_RER.getField("termId").getValue().size() != 0) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "ترم کاری: " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("termId").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print  +=  "ترم کاری: " ;
            classTimeInfo_print  += DynamicForm_CriteriaForm_RER.getField("termId").getDisplayValue();
            classTimeInfo_print  +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_RER.getField("teacherId").getValue() != undefined) {
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مدرس: " + "</span>";
            executionInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("teacherId").getDisplayValue() + "</span>";
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            executionInfo_print +="مدرس: " ;
            executionInfo_print += DynamicForm_CriteriaForm_RER.getField("teacherId").getDisplayValue();
            executionInfo_print += ", " ;
        }
        if (DynamicForm_CriteriaForm_RER.getField("tclassOrganizerId").getValue() != undefined) {
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "برگزار کننده: " + "</span>";
            executionInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_RER.getField("tclassOrganizerId").getDisplayValue() + "</span>";
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            executionInfo_print +=  "برگزار کننده: " ;
            executionInfo_print += DynamicForm_CriteriaForm_RER.getField("tclassOrganizerId").getDisplayValue() ;
            executionInfo_print +=  ", " ;
        }

        titr.contents = "<span style='color:#050505; font-size:13px;'>" + "گزارش کلاس های آموزشی با توجه به محدودیت های اعمال شده:" + "</span>";

        titr.redraw();
        courseInfo.redraw();
        classTimeInfo.redraw();
        executionInfo.redraw();
        reactionEvaluationInfo.redraw();
        learningEvaluationInfo.redraw();
        behavioralEvaluationInfo.redraw();
        evaluationInfo.redraw();
    }

    let Window_CriteriaForm_RER = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_RER]
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_RER = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_RER
        ]
    });
    var HLayOut_Confirm_RER = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Confirm_RER
        ]
    });

    var VLayout_Body_RER = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_RER,
            HLayOut_Confirm_RER
        ]
    });