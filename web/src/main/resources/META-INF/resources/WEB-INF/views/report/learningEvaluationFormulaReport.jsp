<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    var isCriteriaCategoriesChanged_REFR_learning = false;
    let reportCriteria_REFR_learning = null;
    let minScoreER_learning = null;
    let minQusER_learning = null;
    let stdToContent_learning = null;
    let stdToTeacher_learning = null;
    let stdToFacility_learning = null;
    let teachToClass_learning = null;
    let recordsEvalData_learning = [];
    let excelData_learning = [];


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
        fields: [{name: "id"}, {name: "titleFa"}, {name: "category.titleFa"}],
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

    <%--RestDataSource_REFR_learning = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        { name: "id", title: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "classId", title: "classId", filterOperator: "iContains"},--%>
    <%--        {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains"},--%>
    <%--        {name: "complex", title: "<spring:message code="complex"/>", filterOperator: "iContains"},--%>
    <%--        {name: "teacherNationalCode", title: "<spring:message code="teacher.national"/>", filterOperator: "iContains"},--%>
    <%--        {name: "teacherName", title: "<spring:message code="teacher.name"/>", filterOperator: "iContains"},--%>
    <%--        {name: "teacherFamily", title: "<spring:message code="teacher.last.name"/>", filterOperator: "iContains"},--%>
    <%--        {name: "isPersonnel", title: "<spring:message code="teacher.type"/>", filterOperator: "iContains"},--%>
    <%--        {name: "classStatus", title: "<spring:message code="class.status"/>", filterOperator: "iContains",--%>
    <%--            valueMap: {--%>

    <%--                1: "برنامه ریزی",--%>
    <%--                2: "در حال اجرا",--%>
    <%--                3: "پایان یافته",--%>
    <%--                4: "لغو شده",--%>
    <%--                5: "اختتام"--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {name: "classStartDate", title: "<spring:message code="start.date"/>", filterOperator: "iContains"},--%>
    <%--        {name: "classEndDate", title: "<spring:message code="end.date"/>", filterOperator: "iContains"},--%>
    <%--        {name: "courseId", title: "courseId", filterOperator: "iContains"},--%>
    <%--        {name: "courseCode", title: "<spring:message code="course.code"/>", filterOperator: "iContains"},--%>
    <%--        {name: "courseTitleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},--%>
    <%--        {name: "categoryTitleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},--%>
    <%--        {name: "subCategoryTitleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},--%>
    <%--        {name: "studentsGradeToTeacher", title: "<spring:message code="reaction.formula.students.grade.to.teacher"/>"},--%>
    <%--        {name: "studentsGradeToGoals", title: "<spring:message code="reaction.formula.students.grade.to.goals"/>"},--%>
    <%--        {name: "studentsGradeToFacility", title: "<spring:message code="reaction.formula.students.grade.to.facility"/>"},--%>
    <%--        {name: "teacherGradeToClass", title: "<spring:message code="reaction.formula.teacher.grade.to.class"/>"},--%>
    <%--        {name: "trainingGradeToTeacher", title: "<spring:message code="reaction.formula.training.grade.to.teacher"/>"},--%>
    <%--        {name: "evaluatedPercent", title: "<spring:message code="reaction.formula.evaluated.percent"/>"},--%>
    <%--        {name: "answeredStudentsNum", title: "<spring:message code="reaction.formula.answered.students.num"/>"},--%>
    <%--        {name: "allStudentsNum", title: "<spring:message code="reaction.formula.all.students.num"/>"}--%>
    <%--    ],--%>
    <%--    fetchDataURL: viewReactionEvaluationFormulaReportUrl + "/iscList",--%>
    <%--    transformResponse: function (dsResponse, dsRequest, data) {--%>
    <%--        let records = dsResponse.data;--%>
    <%--        excelData_learning = [];--%>
    <%--        excelData_learning.add({--%>
    <%--            rowNum: "ردیف",--%>
    <%--            classCode: "کد کلاس",--%>
    <%--            complex:"مجتمع کلاس",--%>
    <%--            teacherNationalCode: "کد ملی استاد",--%>
    <%--            teacherName: "نام استاد",--%>
    <%--            teacherFamily: "نام خانوادگی استاد",--%>
    <%--            isPersonnel: "نوع استاد",--%>
    <%--            classStartDate: "تاریخ شروع",--%>
    <%--            classEndDate: "تاریخ پایان",--%>
    <%--            courseTitleFa: "نام دوره",--%>
    <%--            categoryTitleFa: "گروه",--%>
    <%--            subCategoryTitleFa: "زیرگروه",--%>
    <%--            studentsGradeToTeacher: "<spring:message code="reaction.formula.students.grade.to.teacher"/>",--%>
    <%--            teacherGradeToClass: "<spring:message code="reaction.formula.teacher.grade.to.class"/>",--%>
    <%--            trainingGradeToTeacher: "<spring:message code="reaction.formula.training.grade.to.teacher"/>",--%>
    <%--            answeredStudentsNum: "<spring:message code="reaction.formula.answered.students.num"/>",--%>
    <%--            allStudentsNum: "<spring:message code="reaction.formula.all.students.num"/>",--%>
    <%--            reactionEvaluationGrade: "<spring:message code="reaction.formula.reaction.evaluation.grade"/>",--%>
    <%--            evaluatedPercent: "<spring:message code="reaction.formula.evaluated.percent"/>",--%>
    <%--            evaluationStatus: "<spring:message code="reaction.formula.evaluation.status"/>"--%>
    <%--        });--%>
    <%--        if(records) {--%>
    <%--            for (var j = 0; j < records.length; j++) {--%>

    <%--                if (records[j].studentsGradeToFacility != null && records[j].studentsGradeToGoals != null && records[j].studentsGradeToTeacher != null--%>
    <%--                    && records[j].teacherGradeToClass != null) {--%>
    <%--                    let stdGradeFac = NumberUtil.format(records[j].studentsGradeToFacility, "0.00");--%>
    <%--                    let stdGradeCon = NumberUtil.format(records[j].studentsGradeToGoals, "0.00");--%>
    <%--                    let stdGradeTea = NumberUtil.format(records[j].studentsGradeToTeacher, "0.00");--%>
    <%--                    let TeaGradeCla = NumberUtil.format(records[j].teacherGradeToClass, "0.00");--%>
    <%--                    let reactionGrade = (stdGradeFac * stdToFacility_learning)/100 + (stdGradeCon * stdToContent_learning)/100 + (stdGradeTea * stdToTeacher_learning)/100 + (TeaGradeCla * teachToClass_learning)/100;--%>
    <%--                    recordsEvalData_learning.add({--%>
    <%--                        classId: records[j].classId,--%>
    <%--                        reactionScore: reactionGrade--%>
    <%--                    });--%>
    <%--                    excelData_learning.add({--%>
    <%--                        rowNum: j+1,--%>
    <%--                        classCode: records[j].classCode,--%>
    <%--                        complex: records[j].complex,--%>
    <%--                        teacherNationalCode: records[j].teacherNationalCode,--%>
    <%--                        teacherName:records[j].teacherName,--%>
    <%--                        teacherFamily: records[j].teacherFamily,--%>
    <%--                        isPersonnel: records[j].isPersonnel,--%>
    <%--                        classStartDate: records[j].classStartDate,--%>
    <%--                        classEndDate: records[j].classEndDate,--%>
    <%--                        courseTitleFa: records[j].courseTitleFa,--%>
    <%--                        categoryTitleFa: records[j].categoryTitleFa,--%>
    <%--                        subCategoryTitleFa: records[j].subCategoryTitleFa,--%>
    <%--                        studentsGradeToTeacher: records[j].studentsGradeToTeacher,--%>
    <%--                        teacherGradeToClass: records[j].teacherGradeToClass,--%>
    <%--                        trainingGradeToTeacher: records[j].trainingGradeToTeacher,--%>
    <%--                        answeredStudentsNum: records[j].answeredStudentsNum,--%>
    <%--                        allStudentsNum: records[j].allStudentsNum,--%>
    <%--                        reactionEvaluationGrade: reactionGrade,--%>
    <%--                        evaluatedPercent: records[j].evaluatedPercent === "NaN" ? 0 : records[j].evaluatedPercent,--%>
    <%--                        evaluationStatus: records[j].evaluatedPercent >= minQusER_learning && reactionGrade != null && reactionGrade >= minScoreER_learning ? "ارزیابی نهایی شده" : "ارزیابی ناقص"--%>
    <%--                    });--%>
    <%--                } else {--%>
    <%--                    recordsEvalData_learning.add({--%>
    <%--                        classId: records[j].classId,--%>
    <%--                        reactionScore: null--%>
    <%--                    });--%>
    <%--                    excelData_learning.add({--%>
    <%--                        rowNum: j+1,--%>
    <%--                        classCode: records[j].classCode,--%>
    <%--                        complex: records[j].complex,--%>
    <%--                        teacherNationalCode: records[j].teacherNationalCode,--%>
    <%--                        teacherName:records[j].teacherName,--%>
    <%--                        teacherFamily: records[j].teacherFamily,--%>
    <%--                        isPersonnel: records[j].isPersonnel,--%>
    <%--                        classStartDate: records[j].classStartDate,--%>
    <%--                        classEndDate: records[j].classEndDate,--%>
    <%--                        courseTitleFa: records[j].courseTitleFa,--%>
    <%--                        categoryTitleFa: records[j].categoryTitleFa,--%>
    <%--                        subCategoryTitleFa: records[j].subCategoryTitleFa,--%>
    <%--                        studentsGradeToTeacher: records[j].studentsGradeToTeacher,--%>
    <%--                        teacherGradeToClass: records[j].teacherGradeToClass,--%>
    <%--                        trainingGradeToTeacher: records[j].trainingGradeToTeacher,--%>
    <%--                        answeredStudentsNum: records[j].answeredStudentsNum,--%>
    <%--                        allStudentsNum: records[j].allStudentsNum,--%>
    <%--                        reactionEvaluationGrade: "ارزیابی نشده",--%>
    <%--                        evaluatedPercent: records[j].evaluatedPercent === "NaN" ? 0 : records[j].evaluatedPercent,--%>
    <%--                        evaluationStatus: "ارزیابی ناقص"--%>
    <%--                    });--%>
    <%--                }--%>
    <%--            }--%>
    <%--        }--%>
    <%--        return this.Super("transformResponse", arguments);--%>
    <%--    }--%>
    <%--});--%>

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

    <%--DynamicForm_CriteriaForm_REFR_learning = isc.DynamicForm.create({--%>
    <%--    align: "right",--%>
    <%--    titleWidth: 0,--%>
    <%--    titleAlign: "center",--%>
    <%--    showInlineErrors: true,--%>
    <%--    showErrorText: false,--%>
    <%--    numCols: 6,--%>
    <%--    colWidths: ["10%", "25%", "25%", "10%", "25%", "25%"],--%>
    <%--    fields: [--%>
    <%--        {--%>
    <%--            name: "startDate",--%>
    <%--            title: "بازه کلاس: شروع از",--%>
    <%--            ID: "startDate_jspCER_learning",--%>
    <%--            colSpan: 1,--%>
    <%--            titleColSpan: 1,--%>
    <%--            required: true,--%>
    <%--            hint: "--/--/----",--%>
    <%--            keyPressFilter: "[0-9/]",--%>
    <%--            showHintInField: true,--%>
    <%--            icons: [{--%>
    <%--                src: "<spring:url value="calendar.png"/>",--%>
    <%--                click: function (form) {--%>
    <%--                    closeCalendarWindow();--%>
    <%--                    displayDatePicker('startDate_jspCER_learning', this, 'ymd', '/');--%>
    <%--                }--%>
    <%--            }],--%>
    <%--            textAlign: "center",--%>
    <%--            changed: function (form, item, value) {--%>
    <%--                var dateCheck;--%>
    <%--                dateCheck = checkDate(value);--%>
    <%--                if (dateCheck === false) {--%>
    <%--                    form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);--%>
    <%--                } else {--%>
    <%--                    form.clearFieldErrors("startDate", true);--%>
    <%--                }--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {--%>
    <%--            colSpan: 1,--%>
    <%--            name: "temp1",--%>
    <%--            canEdit: false,--%>
    <%--            showTitle: false--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "endDate",--%>
    <%--            title: "بازه کلاس: پایان تا",--%>
    <%--            ID: "endDate_jspCER_learning",--%>
    <%--            colSpan: 1,--%>
    <%--            titleColSpan: 1,--%>
    <%--            type: 'text',--%>
    <%--            required: true,--%>
    <%--            hint: "--/--/----",--%>
    <%--            keyPressFilter: "[0-9/]",--%>
    <%--            showHintInField: true,--%>
    <%--            icons: [{--%>
    <%--                src: "<spring:url value="calendar.png"/>",--%>
    <%--                click: function (form) {--%>
    <%--                    closeCalendarWindow();--%>
    <%--                    displayDatePicker('endDate_jspCER_learning', this, 'ymd', '/');--%>
    <%--                }--%>
    <%--            }],--%>
    <%--            textAlign: "center",--%>
    <%--            changed: function (form, item, value) {--%>
    <%--                let dateCheck;--%>
    <%--                dateCheck = checkDate(value);--%>
    <%--                if (dateCheck === false) {--%>
    <%--                    form.clearFieldErrors("endDate", true);--%>
    <%--                    form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);--%>
    <%--                } else {--%>
    <%--                    form.clearFieldErrors("endDate", true);--%>
    <%--                }--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {--%>
    <%--            colSpan: 1,--%>
    <%--            name: "temp2",--%>
    <%--            canEdit: false,--%>
    <%--            showTitle: false--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "courseCategory",--%>
    <%--            title: "گروه کاری",--%>
    <%--            type: "SelectItem",--%>
    <%--            textAlign: "center",--%>
    <%--            colSpan: 2,--%>
    <%--            titleColSpan: 1,--%>
    <%--            optionDataSource: RestDataSource_Category_REFR_learning,--%>
    <%--            valueField: "titleFa",--%>
    <%--            displayField: "titleFa",--%>
    <%--            filterFields: ["titleFa"],--%>
    <%--            multiple: true,--%>
    <%--            filterLocally: true,--%>
    <%--            pickListProperties: {--%>
    <%--                showFilterEditor: true,--%>
    <%--                filterOperator: "iContains"--%>
    <%--            },--%>
    <%--            pickListFields: [--%>
    <%--                {--%>
    <%--                    name: "id",--%>
    <%--                    hidden: true,--%>
    <%--                    align: "center"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "titleFa",--%>
    <%--                    title: "عنوان گروه",--%>
    <%--                    align: "center"--%>
    <%--                }--%>
    <%--            ],--%>
    <%--            changed: function () {--%>

    <%--                isCriteriaCategoriesChanged_REFR_learning = true;--%>
    <%--                var subCategoryField = DynamicForm_CriteriaForm_REFR_learning.getField("courseSubCategory");--%>
    <%--                subCategoryField.clearValue();--%>
    <%--                if (this.getSelectedRecords() == null) {--%>
    <%--                    subCategoryField.clearValue();--%>
    <%--                    subCategoryField.disable();--%>
    <%--                    return;--%>
    <%--                }--%>
    <%--                subCategoryField.enable();--%>
    <%--                if (subCategoryField.getValue() === undefined)--%>
    <%--                    return;--%>
    <%--                var subCategories = subCategoryField.getSelectedRecords();--%>
    <%--                var categoryNames = this.getValue();--%>
    <%--                var SubCats = [];--%>
    <%--                for (var i = 0; i < subCategories.length; i++) {--%>
    <%--                    if (categoryNames.contains(subCategories[i].category.titleFa))--%>
    <%--                        SubCats.add(subCategories[i].titleFa);--%>
    <%--                }--%>
    <%--                subCategoryField.setValue(SubCats);--%>
    <%--                subCategoryField.focus(this.form, subCategoryField);--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "courseSubCategory",--%>
    <%--            title: "زیرگروه کاری",--%>
    <%--            type: "SelectItem",--%>
    <%--            textAlign: "center",--%>
    <%--            colSpan: 2,--%>
    <%--            titleColSpan: 1,--%>
    <%--            autoFetchData: false,--%>
    <%--            disabled: true,--%>
    <%--            optionDataSource: RestDataSource_SubCategory_REFR_learning,--%>
    <%--            valueField: "id",--%>
    <%--            displayField: "titleFa",--%>
    <%--            filterFields: ["titleFa"],--%>
    <%--            multiple: true,--%>
    <%--            filterLocally: true,--%>
    <%--            pickListProperties: {--%>
    <%--                canSelectAll: true,--%>
    <%--                showFilterEditor: true,--%>
    <%--                filterOperator: "iContains"--%>
    <%--            },--%>
    <%--            pickListFields: [--%>
    <%--                {--%>
    <%--                    name: "id",--%>
    <%--                    hidden: true,--%>
    <%--                    align: "center"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "category.titleFa",--%>
    <%--                    title: "عنوان گروه",--%>
    <%--                    align: "center",--%>
    <%--                    sortNormalizer: function (record) {--%>
    <%--                        return record.category.titleFa;--%>
    <%--                    }--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "titleFa",--%>
    <%--                    title: "عنوان زیرگروه",--%>
    <%--                    align: "center"--%>
    <%--                }--%>
    <%--            ],--%>
    <%--            focus: function () {--%>

    <%--                if (isCriteriaCategoriesChanged_REFR_learning) {--%>
    <%--                    isCriteriaCategoriesChanged_REFR_learning = false;--%>
    <%--                    var names = DynamicForm_CriteriaForm_REFR_learning.getField("courseCategory").getValue();--%>
    <%--                    if (names === []) {--%>
    <%--                        RestDataSource_SubCategory_REFR_learning.implicitCriteria = null;--%>
    <%--                    } else {--%>
    <%--                        RestDataSource_SubCategory_REFR_learning.implicitCriteria = {--%>
    <%--                            _constructor: "AdvancedCriteria",--%>
    <%--                            operator: "and",--%>
    <%--                            criteria: [{fieldName: "category.titleFa", operator: "inSet", value: names}]--%>
    <%--                        };--%>
    <%--                    }--%>
    <%--                    this.fetchData();--%>
    <%--                }--%>
    <%--            }--%>
    <%--        }--%>
    <%--    ]--%>
    <%--});--%>
    
    let IButton_ConfirmClassesSelections_REFR_Learning = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClasses_REFR_Learning.getItem("class.code").getValue();
            if (DynamicForm_SelectClasses_REFR_Learning.getField("class.code").getValue() != undefined && DynamicForm_SelectClasses_REFR_Learning.getField("class.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_REFR_Learning.getField("class.code").getValue().join(",");
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
    let initialLayoutStyle_RER = "vertical";
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
                layoutStyle: initialLayoutStyle_RER,
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

    let organSegmentFilter_RER = init_OrganSegmentFilterDF(true,true, true , null, "complexTitle","assistant","affairs", "section", "unit");
    let DynamicForm_CriteriaForm_REFR_learning = isc.DynamicForm.create({
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
                        RestDataSource_Term_RER.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_CriteriaForm_RER.getField("termId").optionDataSource = RestDataSource_Term_RER;
                        DynamicForm_CriteriaForm_RER.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_RER.getField("termId").enable();
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
            }
        ]
    });

    IButton_Report_REFR_learning = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {

            reportCriteria_REFR_learning = null;
            let form = DynamicForm_CriteriaForm_REFR_learning;

            if(form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info","بازه کلاس مشخص نشده است");
                return;
            }

            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }

            data_values = DynamicForm_CriteriaForm_REFR_learning.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {

                if (data_values.criteria[i].fieldName === "courseCategory") {
                    data_values.criteria[i].fieldName = "categoryTitleFa";
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
                }
            }

            excelData_learning = [];
            excelData_learning.add({
                rowNum: "ردیف",
                classCode: "کد کلاس",
                complex: "مجتمع کلاس",
                teacherNationalCode: "کد ملی استاد",
                teacherName: "نام استاد",
                teacherFamily: "نام خانوادگی استاد",
                isPersonnel: "نوع استاد",
                classStartDate: "تاریخ شروع",
                classEndDate: "تاریخ پایان",
                courseTitleFa: "نام دوره",
                categoryTitleFa: "گروه",
                subCategoryTitleFa: "زیرگروه",
                studentsGradeToTeacher: "<spring:message code="reaction.formula.students.grade.to.teacher"/>",
                trainingGradeToTeacher: "<spring:message code="reaction.formula.training.grade.to.teacher"/>",
                teacherGradeToClass: "<spring:message code="reaction.formula.teacher.grade.to.class"/>",
                answeredStudentsNum: "<spring:message code="reaction.formula.answered.students.num"/>",
                allStudentsNum: "<spring:message code="reaction.formula.all.students.num"/>",
                reactionEvaluationGrade: "<spring:message code="reaction.formula.reaction.evaluation.grade"/>",
                evaluatedPercent: "<spring:message code="reaction.formula.evaluated.percent"/>",
                evaluationStatus: "<spring:message code="reaction.formula.evaluation.status"/>"
            });
            reportCriteria_REFR_learning = data_values;
            ListGrid_REFR_learning.invalidateCache();
            ListGrid_REFR_learning.fetchData(reportCriteria_REFR_learning);
        }
    });
    IButton_Excel_Report = isc.IButtonSave.create({
        top: 260,
        baseStyle: 'MSG-btn-orange',
        icon: "<spring:url value="excel.png"/>",
        title: "درخواست گزارش اکسل(براساس فراگیر)",
        width: 300,
        click: function () {

            reportCriteria_REFR_learning = null;
            let form = DynamicForm_CriteriaForm_REFR_learning;

            if(form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info","بازه کلاس مشخص نشده است");
                return;
            }

            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }
            data_values = DynamicForm_CriteriaForm_REFR_learning.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {

                if (data_values.criteria[i].fieldName === "courseCategory") {
                    data_values.criteria[i].fieldName = "categoryTitleFa";
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
                }
            }

            excelData_learning = [];

            let downloadForm = isc.DynamicForm.create({
                method: "POST",
                action: "/training/export/excel/formula/learning",
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
    });
    IButton_Excel_Report_2 = isc.IButtonSave.create({
        top: 260,
        baseStyle: 'MSG-btn-orange',
        icon: "<spring:url value="excel.png"/>",
        title: "درخواست گزارش اکسل(براساس دوره)",
        width: 300,
        click: function () {

            reportCriteria_REFR_learning = null;
            let form = DynamicForm_CriteriaForm_REFR_learning;

            if(form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info","بازه کلاس مشخص نشده است");
                return;
            }

            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }
            data_values = DynamicForm_CriteriaForm_REFR_learning.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {

                if (data_values.criteria[i].fieldName === "courseCategory") {
                    data_values.criteria[i].fieldName = "categoryTitleFa";
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
                }
            }

            excelData_learning = [];
            excelData_learning.add({
                class_code: "کد کلاس",
                class_status: "وضعیت کلاس",
                complex: "مجتمع کلاس",
                teacher_national_code: "کد ملی استاد",
                teacher: " استاد",
                is_personnel: "نوع استاد",
                class_start_date: "تاریخ شروع",
                class_end_date: "تاریخ پایان",
                course_code: "کد دوره",
                course_titlefa: "نام دوره",
                category_titlefa: "گروه",
                sub_category_titlefa: "زیرگروه",
                student: "فراگیر",
                student_per_number: " شماره پرسنلی فراگیر",
                student_post_title: " پست فراگیر",
                student_post_code: "کد پست فراگیر",
                student_hoze: "حوزه فراگیر",
                student_omor: "امور فراگیر",
                total_std: "تعداد کل فراگیران کلاس",
                training_grade_to_teacher: "نمره ارزیابی آموزش به استاد",
                teacher_grade_to_class: "نمره ارزیابی استاد به کلاس",
                reactione_evaluation_grade: "نمره ارزیابی واکنشی  کلاس",
                final_teacher: "نمره ارزیابی نهایی  مدرس",

            });

            let downloadForm = isc.DynamicForm.create({
                method: "POST",
                action: "/training/export/excel/formula2/learning",
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
    });
    IButton_Clear_REFR_learning = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            ListGrid_REFR_learning.setData([]);
            DynamicForm_CriteriaForm_REFR_learning.clearValues();
            DynamicForm_CriteriaForm_REFR_learning.clearErrors();
            ListGrid_REFR_learning.setFilterEditorCriteria(null);
            IButton_Excel_Report.setDisabled(false);
            IButton_Excel_Report_2.setDisabled(false);


        }
    });
    // HLayout_Acceptance_REFR_learning = isc.HLayout.create({
    //     width: "100%",
    //     align: "center",
    //     members: [
    //         isc.Label.create({
    //             ID: "minScoreLabel_learning ",
    //             dynamicContents: true,
    //             align: "center",
    //             padding: 5
    //         }),
    //         isc.Label.create({
    //             ID: "minQusLabel_learning",
    //             dynamicContents: true,
    //             align: "center",
    //             padding: 5
    //         })
    //     ]
    // });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var VLayOut_CriteriaForm_REFR_learning = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            organSegmentFilter_RER,
            DynamicForm_CriteriaForm_REFR_learning,
            // HLayout_Acceptance_REFR_learning
        ]
    });
    var HLayOut_Confirm_REFR_learning = isc.TrHLayoutButtons.create({
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
            IButton_Excel_Report,
            IButton_Excel_Report_2
        ]
    });
    <%--var ListGrid_REFR_learning = isc.TrLG.create({--%>
    <%--    height: "70%",--%>
    <%--    filterOnKeypress: false,--%>
    <%--    showFilterEditor: true,--%>
    <%--    dataPageSize: 1000,--%>
    <%--    gridComponents: ["filterEditor", "header", "body"],--%>
    <%--    dataSource: RestDataSource_REFR_learning,--%>
    <%--    fields: [--%>
    <%--        {name: "classCode"},--%>
    <%--        {name: "complex"},--%>
    <%--        {name: "teacherNationalCode"},--%>
    <%--        {name: "teacherName"},--%>
    <%--        {name: "teacherFamily"},--%>
    <%--        {name: "isPersonnel"},--%>
    <%--        {name: "classStatus"},--%>
    <%--        {name: "classStartDate"},--%>
    <%--        {name: "classEndDate"},--%>
    <%--        {name: "courseTitleFa"},--%>
    <%--        {name: "categoryTitleFa"},--%>
    <%--        {name: "subCategoryTitleFa"},--%>
    <%--        {name: "studentsGradeToTeacher", canFilter: false},--%>
    <%--        {name: "studentsGradeToGoals", hidden: true},--%>
    <%--        {name: "studentsGradeToFacility", hidden: true},--%>
    <%--        {name: "teacherGradeToClass"},--%>
    <%--        {name: "trainingGradeToTeacher", canFilter: false},--%>
    <%--        {name: "answeredStudentsNum", canFilter: false},--%>
    <%--        {name: "allStudentsNum", canFilter: false},--%>
    <%--        {--%>
    <%--            name: "reactionEvaluationGrade",--%>
    <%--            title: "<spring:message code="reaction.formula.reaction.evaluation.grade"/>",--%>
    <%--            canSort: false,--%>
    <%--            canFilter: false,--%>
    <%--            formatCellValue: function (value, record) {--%>
    <%--                let reactionGrade = recordsEvalData_learning.filter(q => q.classId === record.classId);--%>
    <%--                if (reactionGrade.length) {--%>
    <%--                    if (reactionGrade.first().reactionScore)--%>
    <%--                        return NumberUtil.format(reactionGrade.first().reactionScore, "0.00");--%>
    <%--                    else--%>
    <%--                        return "ارزیابی نشده";--%>
    <%--                } else--%>
    <%--                    return "";--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "evaluatedPercent",--%>
    <%--            canSort: false,--%>
    <%--            canFilter: false,--%>
    <%--            formatCellValue: function (value, record) {--%>
    <%--                if(value !== "NaN")--%>
    <%--                    return NumberUtil.format(value, "0.00");--%>
    <%--                else--%>
    <%--                    return 0;--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "evaluationStatus",--%>
    <%--            title: "<spring:message code="reaction.formula.evaluation.status"/>",--%>
    <%--            canSort: false,--%>
    <%--            canFilter: false,--%>
    <%--            formatCellValue: function (value, record) {--%>

    <%--                let reactionGrade = recordsEvalData_learning.filter(q => q.classId === record.classId);--%>
    <%--                if (reactionGrade.length) {--%>
    <%--                    if(record.evaluatedPercent >= minQusER_learning && reactionGrade.first().reactionScore != null && reactionGrade.first().reactionScore >= minScoreER_learning)--%>
    <%--                        return "ارزیابی نهایی شده";--%>
    <%--                    else--%>
    <%--                        return "ارزیابی ناقص";--%>
    <%--                } else--%>
    <%--                    return "";--%>
    <%--            }--%>
    <%--        }--%>
    <%--    ]--%>
    <%--});--%>
    var VLayout_Body_REFR_learning = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            // ToolStrip_Actions_REFR,
            VLayOut_CriteriaForm_REFR_learning,
            HLayOut_Confirm_REFR_learning,
            // ListGrid_REFR
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

    // </script>