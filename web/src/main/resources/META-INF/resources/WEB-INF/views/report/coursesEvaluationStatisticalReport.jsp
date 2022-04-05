<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    let complex = [];
    let assistance = [];
    let affairs = [];
    let section = [];
    let unit = [];

    let reportCriteria_CESR;
    let data_values_CESR = null;
    let isCriteriaCategoriesChanged_CESR = false;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//

    RestDataSource_CESR = isc.TrDS.create({
        fields: [
            {name: "totalClasses"},
            {name: "numberOfReaction"},
            {name: "numberOfLearning"},
            {name: "numberOfBehavioral"},
            {name: "numberOfResult"},
            {name: "numberOfEffective"},
            {name: "numberOfNonEffective"}
        ],
        fetchDataURL: needsAssessmentsPerformedUrl + "/iscList?_endRow=10000"
    });
    RestDataSource_Class_CESR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });
    RestDataSource_Category_CESR = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });
    RestDataSource_SubCategory_CESR = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });
    RestDataSource_Term_CESR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });
    RestDataSource_Year_CESR = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });
    RestDataSource_Teacher_CESR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.firstNameFa", filterOperator: "iContains"},
            {name: "personality.lastNameFa", filterOperator: "iContains"},
            {name: "personality.nationalCode", filterOperator: "iContains"},
            {name: "fullNameFa"}
        ],
        fetchDataURL: teacherUrl + "fullName"
    });

    //---------------------------------------------------- Main Window--------------------------------------------------------------//

    ToolStripButton_Excel_CESR = isc.ToolStripButtonExcel.create({
        click: function () {
            makeExcelOutput();
        }
    });
    ToolStripButton_Refresh_CESR = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_CESR.invalidateCache();
        }
    });
    ToolStrip_Actions_CESR = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_CESR,
                        ToolStripButton_Excel_CESR
                    ]
                })
            ]
    });

    organSegmentFilter_CESR = init_OrganSegmentFilterDF(true, true, true, null, "complexTitle","assistant","affairs", "section", "unit");

    DynamicForm_SelectClasses_CESR = isc.DynamicForm.create({
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
                layoutStyle: "vertical",
                optionDataSource: RestDataSource_Class_CESR
            }
        ]
    });
    DynamicForm_SelectClasses_CESR.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_CESR.getField("class.code").comboBox.pickListFields = [
        {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
        {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
        {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_CESR.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];
    IButton_ConfirmClassesSelections_CESR = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClasses_CESR.getItem("class.code").getValue();
            if (DynamicForm_SelectClasses_CESR.getField("class.code").getValue() !== undefined && DynamicForm_SelectClasses_CESR.getField("class.code").getValue() !== "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_CESR.getField("class.code").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar !== ";")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues !== undefined) {
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

            criteriaDisplayValues = criteriaDisplayValues === "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CESR.getField("tclassCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_CESR.close();
        }
    });
    Window_SelectClasses_CESR = isc.Window.create({
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
                    DynamicForm_SelectClasses_CESR,
                    IButton_ConfirmClassesSelections_CESR
                ]
            })
        ]
    });

    DynamicForm_CESR = isc.DynamicForm.create({
        align: "right",
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
                        Window_SelectClasses_CESR.show();
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
                ID: "startDate1_CESR",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_CESR', this, 'ymd', '/');
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
                ID: "startDate2_CESR",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_CESR', this, 'ymd', '/');
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
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_CESR,
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
                    isCriteriaCategoriesChanged_CESR = true;
                    var subCategoryField = DynamicForm_CESR.getField("courseSubCategory");
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
                optionDataSource: RestDataSource_SubCategory_CESR,
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
                    if (isCriteriaCategoriesChanged_CESR) {
                        isCriteriaCategoriesChanged_CESR = false;
                        var ids = DynamicForm_CESR.getField("courseCategory").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_CESR.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_CESR.implicitCriteria = {
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
                name: "tclassYear",
                title: "سال کاری",
                type: "SelectItem",
                required: true,
                optionDataSource: RestDataSource_Year_CESR,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                changed: function (form, item, value) {

                    form.getField("termId").clearValue();
                    if (value !== null && value !== undefined) {
                        RestDataSource_Term_CESR.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_CESR.getField("termId").optionDataSource = RestDataSource_Term_CESR;
                        DynamicForm_CESR.getField("termId").fetchData();
                        DynamicForm_CESR.getField("termId").enable();
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
                                        var item = DynamicForm_CESR.getField("termId"),
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
                                        var item = DynamicForm_CESR.getField("termId");
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
                optionDataSource: RestDataSource_Teacher_CESR,
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
            }
        ]
    });

    IButton_Show_CESR = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {

            DynamicForm_CESR.validate();
            if (DynamicForm_CESR.hasErrors())
                return;
            Reporting_CESR();

            // complex = [];
            // assistance = [];
            // affairs = [];
            // section = [];
            // unit = [];
            //
            // if (organSegmentFilter_CESR.getCriteria() !== undefined) {
            //
            //     reportCriteria_CESR = organSegmentFilter_CESR.getCriteria();
            //     DynamicForm_CESR.validate();
            //     if (DynamicForm_CESR.hasErrors())
            //         return;
            //
            //     for (let i = 0; i < reportCriteria_CESR.criteria.size(); i++) {
            //
            //         if (reportCriteria_CESR.criteria[i].fieldName === "complexTitle") {
            //             reportCriteria_CESR.criteria[i].fieldName = "mojtameTitle";
            //             reportCriteria_CESR.criteria[i].operator = "inSet";
            //             complex.add(reportCriteria_CESR.criteria[i].value);
            //         } else if (reportCriteria_CESR.criteria[i].fieldName === "assistant") {
            //             reportCriteria_CESR.criteria[i].fieldName = "assistance";
            //             reportCriteria_CESR.criteria[i].operator = "inSet";
            //             assistance.add(reportCriteria_CESR.criteria[i].value);
            //         } else if (reportCriteria_CESR.criteria[i].fieldName === "affairs") {
            //             reportCriteria_CESR.criteria[i].fieldName = "affairs";
            //             reportCriteria_CESR.criteria[i].operator = "inSet";
            //             affairs.add(reportCriteria_CESR.criteria[i].value);
            //         } else if (reportCriteria_CESR.criteria[i].fieldName === "section") {
            //             reportCriteria_CESR.criteria[i].fieldName = "section";
            //             reportCriteria_CESR.criteria[i].operator = "inSet";
            //             section.add(reportCriteria_CESR.criteria[i].value);
            //         } else if (reportCriteria_CESR.criteria[i].fieldName === "unit") {
            //             reportCriteria_CESR.criteria[i].fieldName = "unit";
            //             reportCriteria_CESR.criteria[i].operator = "inSet";
            //             unit.add(reportCriteria_CESR.criteria[i].value);
            //         }
            //     }
            //
            //     data_values = DynamicForm_CESR.getValuesAsAdvancedCriteria();
            //     ListGrid_CESR.invalidateCache();
            //     ListGrid_CESR.fetchData(reportCriteria_CESR);
            //
            // } else {
            //
            //     reportCriteria_CESR = {
            //         "operator": "and",
            //         "_constructor": "AdvancedCriteria",
            //         "criteria": []
            //     };
            //     data_values = DynamicForm_CESR.getValuesAsAdvancedCriteria();
            //     ListGrid_CESR.invalidateCache();
            //     ListGrid_CESR.fetchData(reportCriteria_CESR);
            // }

        }
    });
    IButton_Clear_CESR = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicForm_CESR.clearValues();
            DynamicForm_CESR.clearErrors();
            organSegmentFilter_CESR.clearValues();
            ListGrid_CESR.setData([]);
        }
    });
    HLayOut_Confirm_CESR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Show_CESR,
            IButton_Clear_CESR
        ]
    });

    ListGrid_CESR = isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: false,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_CESR,
        fields: [
            {name: "totalClasses", title: "تعداد کل کلاسها"},
            {name: "numberOfReaction", title: "تعداد کلاس واکنشی"},
            {name: "numberOfLearning", title: "تعداد کلاس یادگیری"},
            {name: "numberOfBehavioral", title: "تعداد کلاس رفتاری"},
            {name: "numberOfResult", title: "تعداد کلاس نتایج"},
            {name: "numberOfEffective", title: "تعداد کلاس اثربخش"},
            {name: "numberOfNonEffective", title: "تعداد کلاس غیر اثربخش"}
        ]
    });

    VLayout_Body_CESR = isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_CESR,
            organSegmentFilter_CESR,
            DynamicForm_CESR,
            HLayOut_Confirm_CESR,
            ListGrid_CESR
        ]
    });

    //---------------------------------------------------- Functions --------------------------------------------------------------//

    function gregorianDate(date) {
        let dates = date.split("/");
        return JalaliDate.jalaliToGregorian(dates[0],dates[1],dates[2]).join("-");
    }

    function Reporting_CESR() {

        data_values_CESR = null;
        data_values_CESR = DynamicForm_CESR.getValuesAsAdvancedCriteria();
        // let removedObjects = [];
        for (let i = 0; i < data_values_CESR.criteria.size(); i++) {

            if (data_values_CESR.criteria[i].fieldName === "tclassCode") {
                let codesString = data_values_CESR.criteria[i].value;
                let codesArray;
                codesArray = codesString.split(",");
                for (let j = 0; j < codesArray.length; j++) {
                    if (codesArray[j] === "" || codesArray[j] === " ") {
                        codesArray.remove(codesArray[j]);
                    }
                }
                data_values_CESR.criteria[i].operator = "equals";
                data_values_CESR.criteria[i].value = codesArray;
            }
            else if (data_values_CESR.criteria[i].fieldName === "startDate1") {
                data_values_CESR.criteria[i].fieldName = "tclassStartDate";
                data_values_CESR.criteria[i].operator = "greaterThan";
            }
            else if (data_values_CESR.criteria[i].fieldName === "startDate2") {
                data_values_CESR.criteria[i].fieldName = "tclassStartDate";
                data_values_CESR.criteria[i].operator = "lessThan";
            }
            else if(data_values_CESR.criteria[i].fieldName === "courseCategory") {
                data_values_CESR.criteria[i].operator = "inSet";
            }
            else if(data_values_CESR.criteria[i].fieldName === "courseSubCategory"){
                data_values_CESR.criteria[i].operator = "inSet";
            }
            // else if(data_values_CESR.criteria[i].fieldName === "tclassTeachingType" && data_values_CESR.criteria[i].value === "همه"){
            //     removedObjects.add(data_values_CESR.criteria[i]);
            // }
        }
        // data_values_CESR.criteria.removeList(removedObjects);

        if (organSegmentFilter_CESR.getCriteria() !== undefined) {

            reportCriteria_CESR = organSegmentFilter_CESR.getCriteria();
            for (let i = 0; i < reportCriteria_CESR.criteria.size(); i++) {

                if (reportCriteria_CESR.criteria[i].fieldName === "complexTitle") {

                    reportCriteria_CESR.criteria[i].fieldName = "plannerComplex";
                    reportCriteria_CESR.criteria[i].operator = "inSet";
                    data_values_CESR.criteria.add(reportCriteria_CESR.criteria[i]);

                } else if (reportCriteria_CESR.criteria[i].fieldName === "assistant") {

                    reportCriteria_CESR.criteria[i].fieldName = "plannerAssistant";
                    reportCriteria_CESR.criteria[i].operator = "inSet";
                    data_values_CESR.criteria.add(reportCriteria_CESR.criteria[i]);

                } else if (reportCriteria_CESR.criteria[i].fieldName === "affairs") {

                    reportCriteria_CESR.criteria[i].fieldName = "plannerAffairs";
                    reportCriteria_CESR.criteria[i].operator = "inSet";
                    data_values_CESR.criteria.add(reportCriteria_CESR.criteria[i]);

                } else if (reportCriteria_CESR.criteria[i].fieldName === "section") {

                    reportCriteria_CESR.criteria[i].fieldName = "plannerSection";
                    reportCriteria_CESR.criteria[i].operator = "inSet";
                    data_values_CESR.criteria.add(reportCriteria_CESR.criteria[i]);

                } else if (reportCriteria_CESR.criteria[i].fieldName === "unit") {

                    reportCriteria_CESR.criteria[i].fieldName = "plannerUnit";
                    reportCriteria_CESR.criteria[i].operator = "inSet";
                    data_values_CESR.criteria.add(reportCriteria_CESR.criteria[i]);
                }
            }
        }
        ListGrid_CESR.invalidateCache();
        ListGrid_CESR.fetchData(data_values_CESR);
    }

    function makeExcelOutput() {

        if (ListGrid_CESR.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_CESR, needsAssessmentsPerformedUrl + "/iscList?_endRow=10000", 0, null, '',"گزارش نیازسنجی های انجام شده"  , reportCriteria_CESR, null);
    }

    //</script>
