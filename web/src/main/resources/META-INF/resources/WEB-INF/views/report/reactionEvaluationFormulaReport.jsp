<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    var isCriteriaCategoriesChanged_REFR = false;
    let reportCriteria_REFR = null;
    let minScoreER = null;
    let minQusER = null;
    let stdToContent = null;
    let stdToTeacher = null;
    let stdToFacility = null;
    let teachToClass = null;
    let recordsEvalData = [];
    let excelData = [];


    //----------------------------------------------------Default Rest--------------------------------------------------
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FER", "GET", null, function (resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

            let result = (JSON.parse(resp.data)).response.data;
            minScoreER = Number(result.filter(q => q.code === "minScoreER").first().value);
            minQusER = Number(result.filter(q => q.code === "minQusER").first().value);
            stdToContent = Number(result.filter(q => q.code === "z3").first().value);
            stdToTeacher = Number(result.filter(q => q.code === "z4").first().value);
            stdToFacility = Number(result.filter(q => q.code === "z6").first().value);
            teachToClass = Number(result.filter(q => q.code === "z5").first().value);

            minScoreLabel.setContents(getFormulaMessage("حدقبولی نمره واکنشی: ", "3", "#5dd851", "b") + getFormulaMessage("" + minScoreER, "3", "#5dd851", "b"));
            minQusLabel.setContents(getFormulaMessage("حداقل تعداد پرسشنامه های تکمیل شده: % ", "3", "#0380fc", "b") + getFormulaMessage("" + minQusER, "3", "#0380fc", "b"));
        }
    }));

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Category_REFR = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });
    RestDataSource_SubCategory_REFR = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });
    RestDataSource_Class_REFR = isc.TrDS.create({
        ID: "RestDataSource_Class_REFR",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });
    RestDataSource_REFR = isc.TrDS.create({
        fields: [
            { name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "classId", title: "classId", filterOperator: "iContains"},
            {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains"},
            {name: "classStatus", title: "<spring:message code="class.status"/>", filterOperator: "iContains",
                valueMap: {

                    1: "برنامه ریزی",
                    2: "در حال اجرا",
                    3: "پایان یافته",
                    4: "لغو شده",
                    5: "اختتام"
                }
            },
            {name: "classStartDate", title: "<spring:message code="start.date"/>", filterOperator: "iContains"},
            {name: "classEndDate", title: "<spring:message code="end.date"/>", filterOperator: "iContains"},
            {name: "courseId", title: "courseId", filterOperator: "iContains"},
            {name: "courseCode", title: "<spring:message code="course.code"/>", filterOperator: "iContains"},
            {name: "courseTitleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "categoryTitleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "subCategoryTitleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},
            {name: "studentsGradeToTeacher", title: "<spring:message code="reaction.formula.students.grade.to.teacher"/>"},
            {name: "studentsGradeToGoals", title: "<spring:message code="reaction.formula.students.grade.to.goals"/>"},
            {name: "studentsGradeToFacility", title: "<spring:message code="reaction.formula.students.grade.to.facility"/>"},
            {name: "teacherGradeToClass", title: "<spring:message code="reaction.formula.teacher.grade.to.class"/>"},
            {name: "trainingGradeToTeacher", title: "<spring:message code="reaction.formula.training.grade.to.teacher"/>"},
            {name: "evaluatedPercent", title: "<spring:message code="reaction.formula.evaluated.percent"/>"},
            {name: "answeredStudentsNum", title: "<spring:message code="reaction.formula.answered.students.num"/>"},
            {name: "allStudentsNum", title: "<spring:message code="reaction.formula.all.students.num"/>"}
        ],
        fetchDataURL: viewReactionEvaluationFormulaReportUrl + "/iscList",
        transformResponse: function (dsResponse, dsRequest, data) {
            let records = dsResponse.data;
            excelData = [];
            excelData.add({
                rowNum: "ردیف",
                classCode: "کد کلاس",
                classStartDate: "تاریخ شروع",
                classEndDate: "تاریخ پایان",
                courseTitleFa: "نام دوره",
                categoryTitleFa: "گروه",
                subCategoryTitleFa: "زیرگروه",
                studentsGradeToTeacher: "<spring:message code="reaction.formula.students.grade.to.teacher"/>",
                trainingGradeToTeacher: "<spring:message code="reaction.formula.training.grade.to.teacher"/>",
                answeredStudentsNum: "<spring:message code="reaction.formula.answered.students.num"/>",
                allStudentsNum: "<spring:message code="reaction.formula.all.students.num"/>",
                reactionEvaluationGrade: "<spring:message code="reaction.formula.reaction.evaluation.grade"/>",
                evaluatedPercent: "<spring:message code="reaction.formula.evaluated.percent"/>",
                evaluationStatus: "<spring:message code="reaction.formula.evaluation.status"/>"
            });
            if(records) {
                for (var j = 0; j < records.length; j++) {

                    if (records[j].studentsGradeToFacility != null && records[j].studentsGradeToGoals != null && records[j].studentsGradeToTeacher != null
                        && records[j].teacherGradeToClass != null) {
                        let stdGradeFac = NumberUtil.format(records[j].studentsGradeToFacility, "0.00");
                        let stdGradeCon = NumberUtil.format(records[j].studentsGradeToGoals, "0.00");
                        let stdGradeTea = NumberUtil.format(records[j].studentsGradeToTeacher, "0.00");
                        let TeaGradeCla = NumberUtil.format(records[j].teacherGradeToClass, "0.00");
                        let reactionGrade = (stdGradeFac * stdToFacility)/100 + (stdGradeCon * stdToContent)/100 + (stdGradeTea * stdToTeacher)/100 + (TeaGradeCla * teachToClass)/100;
                        recordsEvalData.add({
                                classId: records[j].classId,
                                reactionScore: reactionGrade
                            });
                        excelData.add({
                            rowNum: j+1,
                            classCode: records[j].classCode,
                            classStartDate: records[j].classStartDate,
                            classEndDate: records[j].classEndDate,
                            courseTitleFa: records[j].courseTitleFa,
                            categoryTitleFa: records[j].categoryTitleFa,
                            subCategoryTitleFa: records[j].subCategoryTitleFa,
                            studentsGradeToTeacher: records[j].studentsGradeToTeacher,
                            trainingGradeToTeacher: records[j].trainingGradeToTeacher,
                            answeredStudentsNum: records[j].answeredStudentsNum,
                            allStudentsNum: records[j].allStudentsNum,
                            reactionEvaluationGrade: reactionGrade,
                            evaluatedPercent: records[j].evaluatedPercent === "NaN" ? 0 : records[j].evaluatedPercent,
                            evaluationStatus: records[j].evaluatedPercent >= minQusER && reactionGrade != null && reactionGrade >= minScoreER ? "ارزیابی نهایی شده" : "ارزیابی ناقص"
                        });
                    } else {
                        recordsEvalData.add({
                            classId: records[j].classId,
                            reactionScore: null
                        });
                        excelData.add({
                            rowNum: j+1,
                            classCode: records[j].classCode,
                            classStartDate: records[j].classStartDate,
                            classEndDate: records[j].classEndDate,
                            courseTitleFa: records[j].courseTitleFa,
                            categoryTitleFa: records[j].categoryTitleFa,
                            subCategoryTitleFa: records[j].subCategoryTitleFa,
                            studentsGradeToTeacher: records[j].studentsGradeToTeacher,
                            trainingGradeToTeacher: records[j].trainingGradeToTeacher,
                            answeredStudentsNum: records[j].answeredStudentsNum,
                            allStudentsNum: records[j].allStudentsNum,
                            reactionEvaluationGrade: "ارزیابی نشده",
                            evaluatedPercent: records[j].evaluatedPercent === "NaN" ? 0 : records[j].evaluatedPercent,
                            evaluationStatus: "ارزیابی ناقص"
                        });
                    }
                }
            }
            return this.Super("transformResponse", arguments);
        }
    });

    //----------------------------------------------------Criteria Form------------------------------------------------
    ToolStripButton_Excel_REFR = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });
    ToolStripButton_Refresh_REFR = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_REFR.invalidateCache();
        }
    });
    ToolStrip_Actions_REFR = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_REFR,
                        ToolStripButton_Excel_REFR
                    ]
                })
            ]
    });

    DynamicForm_CriteriaForm_REFR = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["10%", "25%", "25%", "10%", "25%", "25%"],
        fields: [
            {
                name: "startDate",
                title: "بازه کلاس: شروع از",
                ID: "startDate_jspCER",
                colSpan: 1,
                titleColSpan: 1,
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspCER', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    var dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("startDate", true);
                    }
                }
            },
            {
                colSpan: 1,
                name: "temp1",
                canEdit: false,
                showTitle: false
            },
            {
                name: "endDate",
                title: "بازه کلاس: پایان تا",
                ID: "endDate_jspCER",
                colSpan: 1,
                titleColSpan: 1,
                type: 'text',
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspCER', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    let dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("endDate", true);
                    }
                }
            },
            {
                colSpan: 1,
                name: "temp2",
                canEdit: false,
                showTitle: false
            },
            {
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                optionDataSource: RestDataSource_Category_REFR,
                valueField: "titleFa",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                changed: function () {

                    isCriteriaCategoriesChanged_REFR = true;
                    var subCategoryField = DynamicForm_CriteriaForm_REFR.getField("courseSubCategory");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    var categoryNames = this.getValue();
                    var SubCats = [];
                    for (var i = 0; i < subCategories.length; i++) {
                        if (categoryNames.contains(subCategories[i].category.titleFa))
                            SubCats.add(subCategories[i].titleFa);
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
                colSpan: 2,
                titleColSpan: 1,
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_REFR,
                valueField: "titleFa",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                focus: function () {

                    if (isCriteriaCategoriesChanged_REFR) {
                        isCriteriaCategoriesChanged_REFR = false;
                        var names = DynamicForm_CriteriaForm_REFR.getField("courseCategory").getValue();
                        if (names === []) {
                            RestDataSource_SubCategory_REFR.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_REFR.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "category.titleFa", operator: "inSet", value: names}]
                            };
                        }
                        this.fetchData();
                    }
                }
            }
        ]
    });

    IButton_Report_REFR = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {

            reportCriteria_REFR = null;
            let form = DynamicForm_CriteriaForm_REFR;

            if(form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info","بازه کلاس مشخص نشده است");
                return;
            }

            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }

            data_values = DynamicForm_CriteriaForm_REFR.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {

                if (data_values.criteria[i].fieldName === "courseCategory") {
                    data_values.criteria[i].fieldName = "categoryTitleFa";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "courseSubCategory") {
                    data_values.criteria[i].fieldName = "subCategoryTitleFa";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "startDate") {
                    data_values.criteria[i].fieldName = "classStartDate";
                    data_values.criteria[i].operator = "greaterOrEqual";
                } else if (data_values.criteria[i].fieldName === "endDate") {
                    data_values.criteria[i].fieldName = "classEndDate";
                    data_values.criteria[i].operator = "lessOrEqual";
                }
            }

            excelData = [];
            excelData.add({
                rowNum: "ردیف",
                classCode: "کد کلاس",
                classStartDate: "تاریخ شروع",
                classEndDate: "تاریخ پایان",
                courseTitleFa: "نام دوره",
                categoryTitleFa: "گروه",
                subCategoryTitleFa: "زیرگروه",
                studentsGradeToTeacher: "<spring:message code="reaction.formula.students.grade.to.teacher"/>",
                trainingGradeToTeacher: "<spring:message code="reaction.formula.training.grade.to.teacher"/>",
                answeredStudentsNum: "<spring:message code="reaction.formula.answered.students.num"/>",
                allStudentsNum: "<spring:message code="reaction.formula.all.students.num"/>",
                reactionEvaluationGrade: "<spring:message code="reaction.formula.reaction.evaluation.grade"/>",
                evaluatedPercent: "<spring:message code="reaction.formula.evaluated.percent"/>",
                evaluationStatus: "<spring:message code="reaction.formula.evaluation.status"/>"
            });
            reportCriteria_REFR = data_values;
            ListGrid_REFR.invalidateCache();
            ListGrid_REFR.fetchData(reportCriteria_REFR);
        }
    });
    IButton_Clear_REFR = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            ListGrid_REFR.setData([]);
            DynamicForm_CriteriaForm_REFR.clearValues();
            DynamicForm_CriteriaForm_REFR.clearErrors();
            ListGrid_REFR.setFilterEditorCriteria(null);
        }
    });
    HLayout_Acceptance_REFR = isc.HLayout.create({
        width: "100%",
        align: "center",
        members: [
            isc.Label.create({
                ID: "minScoreLabel",
                dynamicContents: true,
                align: "center",
                padding: 5
            }),
            isc.Label.create({
                ID: "minQusLabel",
                dynamicContents: true,
                align: "center",
                padding: 5
            })
        ]
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var VLayOut_CriteriaForm_REFR = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            DynamicForm_CriteriaForm_REFR,
            HLayout_Acceptance_REFR
        ]
    });
    var HLayOut_Confirm_REFR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Report_REFR,
            IButton_Clear_REFR
        ]
    });
    var ListGrid_REFR = isc.TrLG.create({
        height: "70%",
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_REFR,
        fields: [
            {name: "classCode"},
            {name: "classStatus"},
            {name: "classStartDate"},
            {name: "classEndDate"},
            {name: "courseTitleFa"},
            {name: "categoryTitleFa"},
            {name: "subCategoryTitleFa"},
            {name: "studentsGradeToTeacher", canFilter: false},
            {name: "studentsGradeToGoals", hidden: true},
            {name: "studentsGradeToFacility", hidden: true},
            {name: "teacherGradeToClass", hidden: true},
            {name: "trainingGradeToTeacher", canFilter: false},
            {name: "answeredStudentsNum", canFilter: false},
            {name: "allStudentsNum", canFilter: false},
            {
                name: "reactionEvaluationGrade",
                title: "<spring:message code="reaction.formula.reaction.evaluation.grade"/>",
                canSort: false,
                canFilter: false,
                formatCellValue: function (value, record) {
                    let reactionGrade = recordsEvalData.filter(q => q.classId === record.classId);
                    if (reactionGrade.length) {
                        if (reactionGrade.first().reactionScore)
                            return NumberUtil.format(reactionGrade.first().reactionScore, "0.00");
                        else
                            return "ارزیابی نشده";
                    } else
                        return "";
                }
            },
            {
                name: "evaluatedPercent",
                canSort: false,
                canFilter: false,
                formatCellValue: function (value, record) {
                    if(value !== "NaN")
                        return NumberUtil.format(value, "0.00");
                    else
                        return 0;
                }
            },
            {
                name: "evaluationStatus",
                title: "<spring:message code="reaction.formula.evaluation.status"/>",
                canSort: false,
                canFilter: false,
                formatCellValue: function (value, record) {

                    let reactionGrade = recordsEvalData.filter(q => q.classId === record.classId);
                    if (reactionGrade.length) {
                        if(record.evaluatedPercent >= minQusER && reactionGrade.first().reactionScore != null && reactionGrade.first().reactionScore >= minScoreER)
                            return "ارزیابی نهایی شده";
                        else
                            return "ارزیابی ناقص";
                    } else
                        return "";
                }
            }
        ]
    });
    var VLayout_Body_REFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ToolStrip_Actions_REFR,
            VLayOut_CriteriaForm_REFR,
            HLayOut_Confirm_REFR,
            ListGrid_REFR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function makeExcelOutput() {

        if (ListGrid_REFR.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else {
            let fields = [
                {name: "rowNum"},
                {name: "classCode"},
                {name: "classStartDate"},
                {name: "classEndDate"},
                {name: "courseTitleFa"},
                {name: "categoryTitleFa"},
                {name: "subCategoryTitleFa"},
                {name: "studentsGradeToTeacher"},
                {name: "trainingGradeToTeacher"},
                {name: "answeredStudentsNum"},
                {name: "allStudentsNum"},
                {name: "reactionEvaluationGrade"},
                {name: "evaluatedPercent"},
                {name: "evaluationStatus"}
            ];
            ExportToFile.exportToExcelFromClient(fields, excelData, "", "گزارش ارزیابی واکنشی", null);
        }
    }

    // </script>