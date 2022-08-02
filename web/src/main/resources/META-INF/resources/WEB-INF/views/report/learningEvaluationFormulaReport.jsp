<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let isCriteriaCategoriesChanged_REFR_learning = false;
    let reportCriteria_REFR_learning = null;
    let minScoreER_learning = null;
    let minQusER_learning = null;
    let stdToContent_learning = null;
    let stdToTeacher_learning = null;
    let stdToFacility_learning = null;
    let teachToClass_learning = null;
    let recordsEvalData_learning = [];
    let excelData_learning = [];

    let startDate1Check_REFR_Learning = true;
    let startDate2Check_REFR_Learning = true;
    let startDateCheck_Order_REFR_Learning = true;
    let endDate1Check_REFR_Learning = true;
    let endDate2Check_REFR_Learning = true;
    let endDateCheck_Order_REFR_Learning = true;

    //----------------------------------------------------Default Rest--------------------------------------------------
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FER", "GET", null, function (resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

            let result = (JSON.parse(resp.data)).response.data;
            minScoreER_learning = Number(result.filter(q => q.code === "minScoreER").first().value);
            minQusER_learning = Number(result.filter(q => q.code === "minQusER").first().value);
            stdToContent_learning = Number(result.filter(q => q.code === "z3").first().value);
            stdToTeacher_learning = Number(result.filter(q => q.code === "z4").first().value);
            stdToFacility_learning = Number(result.filter(q => q.code === "z6").first().value);
            teachToClass_learning = Number(result.filter(q => q.code === "z5").first().value);

            // minScoreLabel_learning .setContents(getFormulaMessage("حدقبولی نمره واکنشی: ", "3", "#5dd851", "b") + getFormulaMessage("" + minScoreER_learning, "3", "#5dd851", "b"));
            // minQusLabel_learning .setContents(getFormulaMessage("حداقل تعداد پرسشنامه های تکمیل شده: % ", "3", "#0380fc", "b") + getFormulaMessage("" + minQusER_learning, "3", "#0380fc", "b"));
        }
    }));

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    let RestDataSource_Category_REFR_learning = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });
    let RestDataSource_SubCategory_REFR_learning = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"},],
        fetchDataURL: subCategoryUrl + "iscList"
    });
    let RestDataSource_Class_REFR_learning = isc.TrDS.create({
        ID: "RestDataSource_Class_REFR_learning",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });
    let RestDataSource_Term_REFR_learning = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });
    let RestDataSource_Year_REFR_learning = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });
    let RestDataSource_Teacher_REFR_learning = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.firstNameFa", filterOperator: "iContains"},
            {name: "personality.lastNameFa", filterOperator: "iContains"},
            {name: "personality.nationalCode", filterOperator: "iContains"},
            {name: "fullNameFa"}
        ],
        fetchDataURL: teacherUrl + "fullName"
    });
    let RestDataSource_Institute_REFR_learning = isc.TrDS.create({
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
    ToolStripButton_Excel_REFR_learning = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutputLearning();
        }
    });
    ToolStripButton_Refresh_REFR_learning = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_REFR_learning.invalidateCache();
        }
    });
    ToolStrip_Actions_REFR_learning = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_REFR_learning,
                        ToolStripButton_Excel_REFR_learning
                    ]
                })
            ]
    });

    let IButton_ConfirmClassesSelections_REFR_Learning = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let form = DynamicForm_SelectClasses_REFR_Learning;
            let criteriaDisplayValues = "";
            let selectorDisplayValues = form.getItem("class.code").getValue();

            if (form.getField("class.code").getValue() != undefined && form.getField("class.code").getValue() != "") {
                criteriaDisplayValues = form.getField("class.code").getValue().join(",");
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

            DynamicForm_CriteriaForm_REFR_learning.getField("tclassCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_REFR_Learning.close();
        }
    });
    let initialLayoutStyle_REFR = "vertical";
    let DynamicForm_SelectClasses_REFR_Learning = isc.DynamicForm.create({
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
                layoutStyle: initialLayoutStyle_REFR,
                optionDataSource: RestDataSource_Class_REFR_learning
            }
        ]
    });
    DynamicForm_SelectClasses_REFR_Learning.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_REFR_Learning.getField("class.code").comboBox.pickListFields = [
        {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
        {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
        {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_REFR_Learning.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];
    let Window_SelectClasses_REFR_Learning = isc.Window.create({
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
                    DynamicForm_SelectClasses_REFR_Learning,
                    IButton_ConfirmClassesSelections_REFR_Learning
                ]
            })
        ]
    });

    let organSegmentFilter_REFR_Learning = init_OrganSegmentFilterDF(true, true, true, false, false, null, "complexTitle","assistant","affairs", "section", "unit");
    let DynamicForm_CriteriaForm_REFR_learning = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["7%", "43%", "7%", "43%"],
        fields: [
            {
                name: "tclassCode",
                title: "کد کلاس",
                hint: "کد کلاس را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectClasses_REFR_Learning.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "startDate1",
                ID: "startDate1_REFR",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                required: false,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_REFR', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_REFR_Learning = true;
                        startDate1Check_REFR_Learning = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_REFR_Learning = false;
                        startDateCheck_Order_REFR_Learning = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_REFR_Learning = false;
                        startDate1Check_REFR_Learning = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_REFR_Learning = true;
                        startDateCheck_Order_REFR_Learning = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_REFR",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                required: false,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_REFR', this, 'ymd', '/','right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_REFR_Learning = true;
                        startDate2Check_REFR_Learning = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_REFR_Learning = false;
                        startDateCheck_Order_REFR_Learning = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_REFR_Learning = true;
                        startDateCheck_Order_REFR_Learning = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_REFR_Learning = true;
                        startDateCheck_Order_REFR_Learning = true;
                    }
                }
            },
            {
                name: "endDate1",
                ID: "endDate1_REFR",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                required: false,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_REFR', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_REFR_Learning = true;
                        endDate1Check_REFR_Learning = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_REFR_Learning = false;
                        endDateCheck_Order_REFR_Learning = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_REFR_Learning = false;
                        endDate1Check_REFR_Learning = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_REFR_Learning = true;
                        endDateCheck_Order_REFR_Learning = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_REFR",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                required: false,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_REFR', this, 'ymd', '/','right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_REFR_Learning = true;
                        endDate2Check_REFR_Learning = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_REFR_Learning = false;
                        endDateCheck_Order_REFR_Learning = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_REFR_Learning = true;
                        endDateCheck_Order_REFR_Learning = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_REFR_Learning = true;
                        endDateCheck_Order_REFR_Learning = true;
                    }
                }
            },
            {
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_REFR_learning,
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
                    isCriteriaCategoriesChanged_REFR_learning = true;
                    let subCategoryField = DynamicForm_CriteriaForm_REFR_learning.getField("courseSubCategory");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    let subCategories = subCategoryField.getSelectedRecords();
                    let categoryIds = this.getValue();
                    let SubCats = [];
                    for (let i = 0; i < subCategories.length; i++) {
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
                optionDataSource: RestDataSource_SubCategory_REFR_learning,
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
                    if (isCriteriaCategoriesChanged_REFR_learning) {
                        isCriteriaCategoriesChanged_REFR_learning = false;
                        let ids = DynamicForm_CriteriaForm_REFR_learning.getField("courseCategory").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_REFR_learning.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_REFR_learning.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
                    // 
                }
            },
            {
                name: "tclassYear",
                title: "سال کاری",
                type: "SelectItem",
                required: true,
                optionDataSource: RestDataSource_Year_REFR_learning,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                changed: function (form, item, value) {

                    form.getField("termId").clearValue();
                    if (value !== null && value !== undefined) {
                        RestDataSource_Term_REFR_learning.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_CriteriaForm_REFR_learning.getField("termId").optionDataSource = RestDataSource_Term_REFR_learning;
                        DynamicForm_CriteriaForm_REFR_learning.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_REFR_learning.getField("termId").enable();
                    } else {
                        form.getField("termId").disabled = true;
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
                                        let item = DynamicForm_CriteriaForm_REFR_learning.getField("termId"),
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
                                        let item = DynamicForm_CriteriaForm_REFR_learning.getField("termId");
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
                name: "teacherId",
                title: "مدرس",
                type: "ComboBoxItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Teacher_REFR_learning,
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
                optionDataSource: RestDataSource_Institute_REFR_learning,
                displayField: "titleFa",
                filterOperator: "equals",
                valueField: "titleFa",
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
                name: "tclassTeachingType",
                colSpan: 1,
                rowSpan: 3,
                title: "<spring:message code='teaching.type'/>:",
                type: "radioGroup",
                vertical: false,
                fillHorizontalSpace: true,
                defaultValue: "همه",
                valueMap: [
                    "حضوری",
                    "غیر حضوری",
                    "مجازی",
                    "عملی و کارگاهی",
                    "آموزش حین کار(OJT)",
                    "همه"
                ]
            },
            // {
            //     name: "exportType",
            //     title: "نوع خروجی:",
            //     multiple: false,
            //     type: "SelectItem",
            //     defaultValue: "PDF",
            //     valueMap: {
            //         "PDF": "PDF", "EXCEL": "EXCEL"
            //     },
            //     valueField: "id",
            //     displayField: "title",
            //     changed: function (form, item, value) {
            //         if (value !== null && value !== undefined) {
            //             if (value === "PDF") {
            //                 IButton_PDF_Report_REFR.enable();
            //                 IButton_Excel_Report_REFR.disable();
            //                 IButton_Excel_Report_REFR_2.disable();
            //             }
            //             if (value === "EXCEL") {
            //                 IButton_PDF_Report_REFR.disable();
            //                 IButton_Excel_Report_REFR.enable();
            //                 IButton_Excel_Report_REFR_2.enable();
            //             }
            //         }
            //     }
            // },
        ]
    });

    let IButton_Excel_Report_REFR = isc.IButtonSave.create({
        top: 260,
        baseStyle: 'MSG-btn-orange',
        icon: "<spring:url value="excel.png"/>",
        title: "درخواست گزارش اکسل(براساس فراگیر)",
        width: 300,
        enabled: true,
        click: async function () {
            let isPassed = await checkFormValidation();
            if (!isPassed) {
                return;
            }
            makeExcelReportBasedOnStudentOrCourse("formula");
        }
    });
    let IButton_Excel_Report_REFR_2 = isc.IButtonSave.create({
        top: 260,
        baseStyle: 'MSG-btn-orange',
        icon: "<spring:url value="excel.png"/>",
        title: "درخواست گزارش اکسل(براساس دوره)",
        width: 300,
        enabled: true,
        click: async function () {
            let isPassed = await checkFormValidation();
            if (!isPassed) {
                return;
            }
            // makeExcelReportBasedOnCourse();
            makeExcelReportBasedOnStudentOrCourse("formula2")
        }
    });
    let IButton_Clear_REFR_learning = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            organSegmentFilter_REFR_Learning.clearValues();
            organSegmentFilter_REFR_Learning.clearErrors();
            DynamicForm_CriteriaForm_REFR_learning.clearValues();
            DynamicForm_CriteriaForm_REFR_learning.clearErrors();
            // IButton_Excel_Report_REFR.disable();
            // IButton_Excel_Report_REFR_2.disable();
            // IButton_PDF_Report_REFR.enable();
        }
    });
    let IButton_PDF_Report_REFR = isc.ToolStripButtonPrint.create({
        title: "مقایسه ارزیابی واکنشی-یادگیری (ارسال به PDF)",
        click: async function () {
            let isPassed = await checkFormValidation();
            if (!isPassed) {
                return;
            }
        }
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    let VLayOut_CriteriaForm_REFR_learning = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            organSegmentFilter_REFR_Learning,
            DynamicForm_CriteriaForm_REFR_learning,
        ]
    });
    let HLayOut_Confirm_REFR_learning = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            // IButton_Report_REFR,
            IButton_Clear_REFR_learning,
            IButton_Excel_Report_REFR,
            IButton_Excel_Report_REFR_2,
            // IButton_PDF_Report_REFR
        ]
    });

    let VLayout_Body_REFR_learning = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            VLayOut_CriteriaForm_REFR_learning,
            HLayOut_Confirm_REFR_learning,
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function makeExcelOutputLearning() {

        if (ListGrid_REFR_learning.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else {
            let fields = [
                {name: "rowNum"},
                {name: "classCode"},
                {name: "complex"},
                {name: "teacherNationalCode"},
                {name: "teacherName"},
                {name: "teacherFamily"},
                {name: "isPersonnel"},
                {name: "classStartDate"},
                {name: "classEndDate"},
                {name: "courseTitleFa"},
                {name: "categoryTitleFa"},
                {name: "subCategoryTitleFa"},
                {name: "studentsGradeToTeacher"},
                {name: "teacherGradeToClass"},
                {name: "trainingGradeToTeacher"},
                {name: "answeredStudentsNum"},
                {name: "allStudentsNum"},
                {name: "reactionEvaluationGrade"},
                {name: "evaluatedPercent"},
                {name: "evaluationStatus"}
            ];
            ExportToFile.exportToExcelFromClient(fields, excelData_learning, "", "گزارش ارزیابی واکنشی", null);
        }
    }

    async function checkFormValidation() {
        DynamicForm_CriteriaForm_REFR_learning.validate();
        if (DynamicForm_CriteriaForm_REFR_learning.hasErrors())
            return false;

        if (!DynamicForm_CriteriaForm_REFR_learning.validate() ||
            startDateCheck_Order_REFR_Learning === false ||
            startDate2Check_REFR_Learning === false ||
            startDate1Check_REFR_Learning === false ||
            endDateCheck_Order_REFR_Learning === false ||
            endDate2Check_REFR_Learning === false ||
            endDate1Check_REFR_Learning === false) {

            if (startDateCheck_Order_REFR_Learning === false) {
                DynamicForm_CriteriaForm_REFR_learning.clearFieldErrors("startDate2", true);
                DynamicForm_CriteriaForm_REFR_learning.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
            }
            if (startDateCheck_Order_REFR_Learning === false) {
                DynamicForm_CriteriaForm_REFR_learning.clearFieldErrors("startDate1", true);
                DynamicForm_CriteriaForm_REFR_learning.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
            }
            if (startDate2Check_REFR_Learning === false) {
                DynamicForm_CriteriaForm_REFR_learning.clearFieldErrors("startDate2", true);
                DynamicForm_CriteriaForm_REFR_learning.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
            }
            if (startDate1Check_REFR_Learning === false) {
                DynamicForm_CriteriaForm_REFR_learning.clearFieldErrors("startDate1", true);
                DynamicForm_CriteriaForm_REFR_learning.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
            }

            if (endDateCheck_Order_REFR_Learning === false) {
                DynamicForm_CriteriaForm_REFR_learning.clearFieldErrors("endDate2", true);
                DynamicForm_CriteriaForm_REFR_learning.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
            }
            if (endDateCheck_Order_REFR_Learning === false) {
                DynamicForm_CriteriaForm_REFR_learning.clearFieldErrors("endDate1", true);
                DynamicForm_CriteriaForm_REFR_learning.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
            }
            if (endDate2Check_REFR_Learning === false) {
                DynamicForm_CriteriaForm_REFR_learning.clearFieldErrors("endDate2", true);
                DynamicForm_CriteriaForm_REFR_learning.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
            }
            if (endDate1Check_REFR_Learning === false) {
                DynamicForm_CriteriaForm_REFR_learning.clearFieldErrors("endDate1", true);
                DynamicForm_CriteriaForm_REFR_learning.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
            }
        }
        return true;
    }

    function makeExcelReportBasedOnStudentOrCourse(endpoint) {
        reportCriteria_REFR_learning = null;
        let data_values = DynamicForm_CriteriaForm_REFR_learning.getValuesAsAdvancedCriteria();

        for (let i = 0; i < data_values.criteria.size(); i++) {
            if (data_values.criteria[i].fieldName === "courseCategory") {
                data_values.criteria[i].fieldName = "categoryId";
                data_values.criteria[i].operator = "inSet";
            } else if (data_values.criteria[i].fieldName === "courseSubCategory") {
                data_values.criteria[i].fieldName = "subCategoryId";
                data_values.criteria[i].operator = "inSet";
            } else if (data_values.criteria[i].fieldName === "startDate") {
                data_values.criteria[i].fieldName = "classStartDate";
                data_values.criteria[i].operator = "greaterOrEqual";
            } else if (data_values.criteria[i].fieldName === "endDate") {
                data_values.criteria[i].fieldName = "classEndDate";
                data_values.criteria[i].operator = "lessOrEqual";
            } else if (data_values.criteria[i].fieldName === "tclassYear") {
                data_values.criteria[i].operator = "equals";
            } else if (data_values.criteria[i].fieldName === "termId") {
                data_values.criteria[i].operator = "inSet";
            } else if (data_values.criteria[i].fieldName === "teacherId") {
                data_values.criteria[i].operator = "equals";
            } else if (data_values.criteria[i].fieldName === "tclassOrganizerId") {
                data_values.criteria[i].operator = "equals";
            } else if (data_values.criteria[i].fieldName === "tclassTeachingType") {
                data_values.criteria[i].operator = "equals";
            }
        }
        if (organSegmentFilter_REFR_Learning.getCriteria() !== undefined) {
            reportCriteria_REFR_learning = organSegmentFilter_REFR_Learning.getCriteria();
            for (let i = 0; i < reportCriteria_REFR_learning.criteria.size(); i++) {

                if (reportCriteria_REFR_learning.criteria[i].fieldName === "complexTitle") {

                    reportCriteria_REFR_learning.criteria[i].fieldName = "plannerComplex";
                    reportCriteria_REFR_learning.criteria[i].operator = "inSet";
                    data_values.criteria.add(reportCriteria_REFR_learning.criteria[i]);

                } else if (reportCriteria_REFR_learning.criteria[i].fieldName === "assistant") {

                    reportCriteria_REFR_learning.criteria[i].fieldName = "plannerAssistant";
                    reportCriteria_REFR_learning.criteria[i].operator = "inSet";
                    data_values.criteria.add(reportCriteria_REFR_learning.criteria[i]);

                } else if (reportCriteria_REFR_learning.criteria[i].fieldName === "affairs") {

                    reportCriteria_REFR_learning.criteria[i].fieldName = "plannerAffairs";
                    reportCriteria_REFR_learning.criteria[i].operator = "inSet";
                    data_values.criteria.add(reportCriteria_REFR_learning.criteria[i]);

                } else if (reportCriteria_REFR_learning.criteria[i].fieldName === "section") {

                    reportCriteria_REFR_learning.criteria[i].fieldName = "plannerSection";
                    reportCriteria_REFR_learning.criteria[i].operator = "inSet";
                    data_values.criteria.add(reportCriteria_REFR_learning.criteria[i]);

                } else if (reportCriteria_REFR_learning.criteria[i].fieldName === "unit") {

                    reportCriteria_REFR_learning.criteria[i].fieldName = "plannerUnit";
                    reportCriteria_REFR_learning.criteria[i].operator = "inSet";
                    data_values.criteria.add(reportCriteria_REFR_learning.criteria[i]);
                }
            }
        }

        // excelData_learning = [];
        // excelData_learning.add({
        //             class_code: "کد کلاس",
        //             class_status: "وضعیت کلاس",
        //             complex: "مجتمع کلاس",
        //             teacher_national_code: "کد ملی استاد",
        //             teacher: " استاد",
        //             is_personnel: "نوع استاد",
        //             class_start_date: "تاریخ شروع",
        //             class_end_date: "تاریخ پایان",
        //             course_code: "کد دوره",
        //             course_titlefa: "نام دوره",
        //             category_titlefa: "گروه",
        //             sub_category_titlefa: "زیرگروه",
        //             student: "فراگیر",
        //             student_per_number: " شماره پرسنلی فراگیر",
        //             student_post_title: " پست فراگیر",
        //             student_post_code: "کد پست فراگیر",
        //             student_hoze: "حوزه فراگیر",
        //             student_omor: "امور فراگیر",
        //             total_std: "تعداد کل فراگیران کلاس",
        //             training_grade_to_teacher: "نمره ارزیابی آموزش به استاد",
        //             teacher_grade_to_class: "نمره ارزیابی استاد به کلاس",
        //             reactione_evaluation_grade: "نمره ارزیابی واکنشی  کلاس",
        //             final_teacher: "نمره ارزیابی نهایی  مدرس",
        //
        //         });

        let downloadForm = isc.DynamicForm.create({
            method: "POST",
            // action: "/training/export/excel/formula/learning",
            action: "/training/export/excel/" + endpoint +"/learning",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "criteria", type: "hidden"},
                ]
        });
        downloadForm.setValue("criteria", JSON.stringify(data_values));
        downloadForm.show();
        downloadForm.submitForm();
    }

    //
    // function makeExcelReportBasedOnCourse() {
    //     reportCriteria_REFR_learning = null;
    //     let data_values = DynamicForm_CriteriaForm_REFR_learning.getValuesAsAdvancedCriteria();
    //
    //     for (let i = 0; i < data_values.criteria.size(); i++) {
    //         if (data_values.criteria[i].fieldName === "courseCategory") {
    //             data_values.criteria[i].fieldName = "categoryTitleFa";
    //             data_values.criteria[i].operator = "inSet";
    //         } else if (data_values.criteria[i].fieldName === "courseSubCategory") {
    //             data_values.criteria[i].fieldName = "subCategoryId";
    //             data_values.criteria[i].operator = "inSet";
    //         } else if (data_values.criteria[i].fieldName === "startDate") {
    //             data_values.criteria[i].fieldName = "classStartDate";
    //             data_values.criteria[i].operator = "greaterOrEqual";
    //         } else if (data_values.criteria[i].fieldName === "endDate") {
    //             data_values.criteria[i].fieldName = "classEndDate";
    //             data_values.criteria[i].operator = "lessOrEqual";
    //         }
    //     }
    //
    //     excelData_learning = [];
    //     excelData_learning.add({
    //         class_code: "کد کلاس",
    //         class_status: "وضعیت کلاس",
    //         complex: "مجتمع کلاس",
    //         teacher_national_code: "کد ملی استاد",
    //         teacher: " استاد",
    //         is_personnel: "نوع استاد",
    //         class_start_date: "تاریخ شروع",
    //         class_end_date: "تاریخ پایان",
    //         course_code: "کد دوره",
    //         course_titlefa: "نام دوره",
    //         category_titlefa: "گروه",
    //         sub_category_titlefa: "زیرگروه",
    //         student: "فراگیر",
    //         student_per_number: " شماره پرسنلی فراگیر",
    //         student_post_title: " پست فراگیر",
    //         student_post_code: "کد پست فراگیر",
    //         student_hoze: "حوزه فراگیر",
    //         student_omor: "امور فراگیر",
    //         total_std: "تعداد کل فراگیران کلاس",
    //         training_grade_to_teacher: "نمره ارزیابی آموزش به استاد",
    //         teacher_grade_to_class: "نمره ارزیابی استاد به کلاس",
    //         reactione_evaluation_grade: "نمره ارزیابی واکنشی  کلاس",
    //         final_teacher: "نمره ارزیابی نهایی  مدرس",
    //
    //     });
    //
    //     let downloadForm = isc.DynamicForm.create({
    //         method: "POST",
    //         action: "/training/export/excel/formula2/learning",
    //         target: "_Blank",
    //         canSubmit: true,
    //         fields:
    //             [
    //                 {name: "criteria", type: "hidden"},
    //             ]
    //     });
    //     downloadForm.setValue("criteria", JSON.stringify(data_values));
    //     downloadForm.show();
    //     downloadForm.submitForm();
    //
    //
    // }
    //

    // </script>