<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var startDate1Check_NCR = true;
    var startDate2Check_NCR = true;
    var startDateCheck_Order_NCR = true;
    var endDate1Check_NCR = true;
    var endDate2Check_NCR = true;
    var endDateCheck_Order_NCR = true;
    var titr_NCR = isc.HTMLFlow.create({
        align: "center",
        border: "1px solid black",
        width: "25%"
    });
    var criteriaInfo_NCR = isc.HTMLFlow.create({
        align: "center"
    });
    var data_values_NCR;

    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='tclassCode']").attr("disabled","disabled");
        },0)}
    );

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    var RestDataSource_ListResult_NCR  = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "tclassCode"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "tclassDuration"},
            {name: "cancelReasonId"},
            {name: "reHoldingStatus"},
            {name: "alternativeClassCode"},
            {name: "postPoneDate"}
        ],
        fetchDataURL: viewClassDetailUrl + "/iscList"
    });
    var RestDataSource_Category_NCR = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });
    var RestDataSource_Term_NCR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });
    var RestDataSource_Year_NCR = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });
    var RestDataSource_Institute_NCR = isc.TrDS.create({
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
    var RestDataSource_Class_NCR = isc.TrDS.create({
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });
    var RestDataSource_CancelReason_NCR = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>"},
                {name: "code", title: "<spring:message code="code"/>"}
            ],
        autoFetchData: false,
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/RCC"
    });
    
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_Result_NCR = isc.TrLG.create({
        height: "100%",
        dataSource: RestDataSource_ListResult_NCR,
        fields: [
            {name: "tclassCode", title: "کد کلاس",  width: "12%"},
            {name: "courseCode", title:  "کد دوره",width: "8%"},
            {name: "courseTitleFa", title: "عنوان دوره"},
            {name: "tclassDuration", title: "مدت کلاس", width: "8%"},
            {name: "cancelReasonId", title: "علت لغو کلاس",
                type: "SelectItem",
                filterOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: RestDataSource_CancelReason_NCR,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ]},
            {name: "reHoldingStatus", title: "برگزاری مجدد" ,
                valueMap: {
                    true: "بلی",
                    false: "خیر"
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },
                filterOnKeypress: true,
                filterOperator: "equals",width: "8%"},
            {name: "alternativeClassCode", title: "کد کلاس مجدد", width: "12%"},
            {name: "postPoneDate", title: "تاریخ برگزاری مجدد", width: "12%"}
        ],
        cellHeight: 43,
        filterOperator: "iContains",
        filterOnKeypress: false,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        sortField: 5,
        sortDirection: "descending",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });
    
    var Window_Result_NCR = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش عدم انطباق",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    titr_NCR,
                    criteriaInfo_NCR,
                    ListGrid_Result_NCR
                ]
            })
        ]
    });
    
    //--------------------------------------------------- Criteria Form ------------------------------------------------
    var DynamicForm_CriteriaForm_NCR = isc.DynamicForm.create({
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
                        Window_SelectClasses_NCR.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "tclassYear",
                title: "سال کاری",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_NCR,
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
                                        var item = DynamicForm_CriteriaForm_NCR.getField("tclassYear"),
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
                                        var item = DynamicForm_CriteriaForm_NCR.getField("tclassYear");
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
                        RestDataSource_Term_NCR.fetchDataURL = termUrl + "listByYear/" + value[0];
                        DynamicForm_CriteriaForm_NCR.getField("termId").optionDataSource = RestDataSource_Term_NCR;
                        DynamicForm_CriteriaForm_NCR.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_NCR.getField("termId").enable();
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
                                        var item = DynamicForm_CriteriaForm_NCR.getField("termId"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].titleFa;
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
                                        var item = DynamicForm_CriteriaForm_NCR.getField("termId");
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
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_NCR,
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
                    isCriteriaCategoriesChanged_NCR = true;
                    var subCategoryField = DynamicForm_CriteriaForm_NCR.getField("courseSubCategory");
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
                name: "tclassOrganizerId",
                title: "برگزار کننده",
                editorType: "TrComboAutoRefresh",
                optionDataSource: RestDataSource_Institute_NCR,
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
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "startDate1",
                ID: "startDate1_NCR",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_NCR', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_NCR = true;
                        startDate1Check_NCR = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_NCR = false;
                        startDateCheck_Order_NCR = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_NCR = false;
                        startDate1Check_NCR = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_NCR = true;
                        startDateCheck_Order_NCR = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_NCR",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_NCR', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_NCR = true;
                        startDate2Check_NCR = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_NCR = false;
                        startDateCheck_Order_NCR = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_NCR = true;
                        startDateCheck_Order_NCR = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_NCR = true;
                        startDateCheck_Order_NCR = true;
                    }
                }
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },
            {
                name: "endDate1",
                ID: "endDate1_NCR",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_NCR', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_NCR = true;
                        endDate1Check_NCR = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_NCR = false;
                        endDateCheck_Order_NCR = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_NCR = false;
                        endDate1Check_NCR = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_NCR = true;
                        endDateCheck_Order_NCR = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_NCR",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_NCR', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_NCR = true;
                        endDate2Check_NCR = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_NCR = false;
                        endDateCheck_Order_NCR = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_NCR = true;
                        endDateCheck_Order_NCR = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_NCR = true;
                        endDateCheck_Order_NCR = true;
                    }
                }
            },
        ]
    });
    IButton_Confirm_NCR = isc.IButtonSave.create({
        top: 260,
        title: "گزارش گیری",
        width: 300,
        click: function () {
            DynamicForm_CriteriaForm_NCR.validate();
            if (DynamicForm_CriteriaForm_NCR.hasErrors())
                return;
            if (!DynamicForm_CriteriaForm_NCR.validate() ||
                startDateCheck_Order_NCR == false ||
                startDate2Check_NCR == false ||
                startDate1Check_NCR == false ||
                endDateCheck_Order_NCR == false ||
                endDate2Check_NCR == false ||
                endDate1Check_NCR == false) {

                if (startDateCheck_Order_NCR == false) {
                    DynamicForm_CriteriaForm_NCR.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_NCR.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (startDateCheck_Order_NCR == false) {
                    DynamicForm_CriteriaForm_NCR.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_NCR.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (startDate2Check_NCR == false) {
                    DynamicForm_CriteriaForm_NCR.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_NCR.addFieldErrors("startDate2", "<spring:message
        code='msg.correct.date'/>", true);
                }
                if (startDate1Check_NCR == false) {
                    DynamicForm_CriteriaForm_NCR.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_NCR.addFieldErrors("startDate1", "<spring:message
        code='msg.correct.date'/>", true);
                }

                if (endDateCheck_Order_NCR == false) {
                    DynamicForm_CriteriaForm_NCR.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_NCR.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (endDateCheck_Order_NCR == false) {
                    DynamicForm_CriteriaForm_NCR.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_NCR.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (endDate2Check_NCR == false) {
                    DynamicForm_CriteriaForm_NCR.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_NCR.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                }
                if (endDate1Check_NCR == false) {
                    DynamicForm_CriteriaForm_NCR.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_NCR.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                }
                return;
            }
            Reporting();

            ListGrid_Result_NCR.invalidateCache();
            ListGrid_Result_NCR.fetchData(data_values_NCR);
            Window_Result_NCR.show();
        }
    });

    //---------------------------------------------------- Class Selection Form ----------------------------------------
    var initialLayoutStyle_NCR = "vertical";
    var DynamicForm_SelectClasses_NCR = isc.DynamicForm.create({
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
                layoutStyle: initialLayoutStyle_NCR,
                optionDataSource: RestDataSource_Class_NCR
            }
        ]
    });
    DynamicForm_SelectClasses_NCR.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_NCR.getField("class.code").comboBox.pickListFields = [
            {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
            {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
            {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_NCR.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];
    IButton_ConfirmClassesSelections_NCR = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClasses_NCR.getItem("class.code").getValue();
            if (DynamicForm_SelectClasses_NCR.getField("class.code").getValue() != undefined && DynamicForm_SelectClasses_NCR.getField("class.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_NCR.getField("class.code").getValue().join(",");
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

            DynamicForm_CriteriaForm_NCR.getField("tclassCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_NCR.close();
        }
    });
    var Window_SelectClasses_NCR = isc.Window.create({
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
                    DynamicForm_SelectClasses_NCR,
                    IButton_ConfirmClassesSelections_NCR
                ]
            })
        ]
    });
    
    //----------------------------------- functions --------------------------------------------------------------------
    function Reporting(){
        data_values_NCR = null;
        data_values_NCR = DynamicForm_CriteriaForm_NCR.getValuesAsAdvancedCriteria();
        var removedObjects = [];
        if(data_values_NCR != null){
            for (var i = 0; i < data_values_NCR.criteria.size(); i++) {
                if (data_values_NCR.criteria[i].fieldName == "tclassCode") {
                    var codesString = data_values_NCR.criteria[i].value;
                    var codesArray;
                    codesArray = codesString.split(",");
                    for (var j = 0; j < codesArray.length; j++) {
                        if (codesArray[j] == "" || codesArray[j] == " ") {
                            codesArray.remove(codesArray[j]);
                        }
                    }
                    data_values_NCR.criteria[i].operator = "equals";
                    data_values_NCR.criteria[i].value = codesArray;
                }
                else if (data_values_NCR.criteria[i].fieldName == "startDate1") {
                    data_values_NCR.criteria[i].fieldName = "tclassStartDate";
                    data_values_NCR.criteria[i].operator = "greaterThan";
                }
                else if (data_values_NCR.criteria[i].fieldName == "startDate2") {
                    data_values_NCR.criteria[i].fieldName = "tclassStartDate";
                    data_values_NCR.criteria[i].operator = "lessThan";
                }
                else if (data_values_NCR.criteria[i].fieldName == "endDate1") {
                    data_values_NCR.criteria[i].fieldName = "tclassEndDate";
                    data_values_NCR.criteria[i].operator = "greaterThan";
                }
                else if (data_values_NCR.criteria[i].fieldName == "endDate2") {
                    data_values_NCR.criteria[i].fieldName = "tclassEndDate";
                    data_values_NCR.criteria[i].operator = "lessThan";
                }
                else if(data_values_NCR.criteria[i].fieldName == "tclassOrganizerId")
                    data_values_NCR.criteria[i].operator = "equals";
                else if(data_values_NCR.criteria[i].fieldName == "termId")
                    data_values_NCR.criteria[i].operator = "equals";
                else if(data_values_NCR.criteria[i].fieldName == "courseCategory"){
                    data_values_NCR.criteria[i].operator = "inSet";
                }
            }

            let ccriteria = new Object();
            ccriteria.fieldName = "tclassStatus";
            ccriteria.operator = "iContains";
            ccriteria.value = "4";
            data_values_NCR.criteria.add(ccriteria);
        }
        else{
            data_values_NCR = new Object();
            data_values_NCR.fieldName = "tclassStatus";
            data_values_NCR.operator = "iContains";
            data_values_NCR.value = "4";
        }


        titr_NCR.contents = "";
        criteriaInfo_NCR.contents = "";

        if (DynamicForm_CriteriaForm_NCR.getField("tclassCode").getValue() != undefined) {
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + "کد کلاس: " + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_NCR.getField("tclassCode").getDisplayValue() + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";
        }
        if (DynamicForm_CriteriaForm_NCR.getField("tclassYear").getValue() != undefined) {
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + "سال کاری: " + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_NCR.getField("tclassYear").getDisplayValue() + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";
        }
        if (DynamicForm_CriteriaForm_NCR.getField("termId").getValue() != undefined) {
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + "ترم کاری: " + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_NCR.getField("termId").getDisplayValue() + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";
        }
        if (DynamicForm_CriteriaForm_NCR.getField("courseCategory").getValue() != undefined) {
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + "گروه های کاری: " + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_NCR.getField("courseCategory").getDisplayValue() + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";
        }
        if (DynamicForm_CriteriaForm_NCR.getField("tclassOrganizerId").getValue() != undefined) {
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + "برگزار کننده: " + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_NCR.getField("tclassOrganizerId").getDisplayValue() + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";
        }
        if (DynamicForm_CriteriaForm_NCR.getField("startDate1").getValue() != undefined) {
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ شروع کلاس: از " + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_NCR.getField("startDate1").getDisplayValue() + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";
        }
        if (DynamicForm_CriteriaForm_NCR.getField("startDate2").getValue() != undefined) {
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ شروع کلاس: تا " + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_NCR.getField("startDate2").getDisplayValue() + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";
        }
        if (DynamicForm_CriteriaForm_NCR.getField("endDate1").getValue() != undefined) {
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ پایان کلاس: از " + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_NCR.getField("endDate1").getDisplayValue() + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";
        }
        if (DynamicForm_CriteriaForm_NCR.getField("endDate2").getValue() != undefined) {
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ پایان کلاس: تا " + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_NCR.getField("endDate2").getDisplayValue() + "</span>";
            criteriaInfo_NCR.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";
        }
        
        titr_NCR.contents = "<span style='color:#050505; font-size:13px;'>" + "گزارش عدم انطباق با توجه به محدودیت های اعمال شده:" + "</span>";

        titr_NCR.redraw();
        criteriaInfo_NCR.redraw();
    }

    //----------------------------------- layOut -----------------------------------------------------------------------
    let Window_CriteriaForm_NCR = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_NCR]
    });
    var HLayOut_CriteriaForm_NCR = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_NCR
        ]
    });
    var HLayOut_Confirm_NCR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Confirm_NCR,
            // IButton_Print_NCR
        ]
    });
    var VLayout_Body_NCR = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_NCR,
            HLayOut_Confirm_NCR
        ]
    });
    
    //----------------------------------------------------End-----------------------------------------------------------
    Window_Result_NCR.hide();