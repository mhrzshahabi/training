<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>



 // <script>
 <%--    &lt;%&ndash;%>
 <%--        final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);--%>
 <%--    %>--%>

    var courseGoal = ListGrid_Class_JspClass.getSelectedRecord().course.id;

    TeacherDS_questionnaire = isc.TrDS.create({
        fields: [
            {
                name: "evaluationQuestion.question",
                title: "<spring:message code="question"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "weight", title: "<spring:message code="weight"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "order", title: "<spring:message code="order"/>", filterOperator: "iContains"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
    });

 TotalGoalDS_questionnaire = isc.TrDS.create({
     fields: [
         {name: "id", primaryKey: true},
         {name: "titleFa", filterOperator: "iContains", autoFitWidth: true},
         {name: "titleEn", filterOperator: "iContains", autoFitWidth: true},
         {name: "version", title: "version", canEdit: false, hidden: true}

     ],
 });

 EquipmentDS_questionnaire = isc.TrDS.create({
     fields: [
         {
             name: "evaluationQuestion.question",
             title: "<spring:message code="question"/>",
             filterOperator: "iContains",
             autoFitWidth: true
         },
         {name: "weight", title: "<spring:message code="weight"/>", filterOperator: "iContains", autoFitWidth: true},
         {name: "order", title: "<spring:message code="order"/>", filterOperator: "iContains"},
         {name: "version", title: "version", canEdit: false, hidden: true}

     ],
 });

 CourseSkillDS_questionnaire = isc.TrDS.create({
     fields: [

         {name: "id", primaryKey: true},
         {name: "code" , filterOperator: "iContains", autoFitWidth: true},
         {name: "titleFa", filterOperator: "iContains", autoFitWidth: true},
         {name: "version", title: "version", canEdit: false, hidden: true}

     ],
     fetchDataURL: ""
 });

 var TeacherLG_questionnaire = isc.ListGrid.create({
     dataSource: TeacherDS_questionnaire,
     fields: [
            {name: "evaluationQuestion.question", align: "center" , title: "<spring:message code="question"/>"},
            {name: "weight", hidden: true},
            {name: "order", hidden: true},
            {name: "veryGood", title: "خیلی خوب", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "good", title: " خوب", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "medium", title: "متوسط", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "weak", title: "ضعیف", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "veryWeak", title: "خیلی ضعیف", align: "center", type: "boolean", canEdit: true, width: "10%"},
        ],
        selectionType: "single",
        sortField: 3,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
    });

    var ListGrid_CourseGoal_Evaluation = isc.ListGrid.create({
        width: "100%",
        dataSource: TotalGoalDS_questionnaire,
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "اهداف دوره", align: "center"},
            {name: "titleEn", title: "نام لاتین هدف", align: "center", hidden: true},
            {name: "veryGood", title: "خیلی خوب", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "good", title: " خوب", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "medium", title: "متوسط", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "weak", title: "ضعیف", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "veryWeak", title: "خیلی ضعیف", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        selectionType: "single",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",
    });

 var EquipmentLG_questionnaire = isc.ListGrid.create({
        dataSource: EquipmentDS_questionnaire,
        fields: [

            {name: "evaluationQuestion.question", align: "center"},
            {name: "weight", hidden: true},
            {name: "order", hidden: true},
            {name: "veryGood", title: "خیلی خوب", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "good", title: " خوب", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "medium", title: "متوسط", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "weak", title: "ضعیف", align: "center", type: "boolean", canEdit: true, width: "10%"},
            {name: "veryWeak", title: "خیلی ضعیف", align: "center", type: "boolean", canEdit: true, width: "10%"},
        ],
        selectionType: "single",
        sortField: 3,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن",

    });

 var ListGrid_CourseSkill_Evaluation = isc.ListGrid.create({
     width: "100%",
     dataSource: CourseSkillDS_questionnaire,
     fields: [
         {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
         {name: "titleFa", title: "اهداف کلی دوره", align: "center"},
         {name: "code", title: "کد هدف", align: "center", hidden: true},
         {name: "veryGood", title: "خیلی خوب", align: "center", type: "checkbox", canEdit: true, width: "10%"},
         {name: "good", title: " خوب", align: "center", type: "checkbox", canEdit: true, width: "10%"},
         {name: "medium", title: "متوسط", align: "center", type: "checkbox", canEdit: true, width: "10%"},
         {name: "weak", title: "ضعیف", align: "center", type: "checkbox", canEdit: true, width: "10%"},
         {name: "veryWeak", title: "خیلی ضعیف", align: "center", type: "checkbox", canEdit: true, width: "10%"},
         {name: "version", title: "version", canEdit: false, hidden: true}
     ],
     selectionType: "single",
     sortField: 1,
     sortDirection: "descending",
     dataPageSize: 50,
     autoFetchData: false,
     showFilterEditor: true,
     filterOnKeypress: true,
     sortFieldAscendingText: "مرتب سازی صعودی ",
     sortFieldDescendingText: "مرتب سازی نزولی",
     configureSortText: "تنظیم مرتب سازی",
     autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
     autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
     filterUsingText: "فیلتر کردن",
     groupByText: "گروه بندی",
     freezeFieldText: "ثابت نگه داشتن",

 });

    var EvaluationReactionHeaderForm = isc.DynamicForm.create({
        titleWidth: 120,
        width: "100%",
        numCols: 6,
        // align: "right",
        titleAlign: "left",
        fields: [
            {
                name: "courseCode",
                type: "staticText",
                title: "<spring:message code='course.code'/>",
                wrapTitle: false,
            },
            {
                name: "courseName",
                type: "staticText",
                title: "<spring:message code='course_fa_name'/>",
                wrapTitle: false,
            },
            {
                name: "classCode",
                type: "staticText",
                title: "<spring:message code='class.code'/>",
                wrapTitle: false,
            },
            {
                name: "classStart",
                type: "staticText",
                title: "<spring:message code='start.date'/>",
                wrapTitle: false,
            },
            {
                name: "classEnd",
                type: "staticText",
                title: "<spring:message code='end.date'/>",
                wrapTitle: false,
            },
            {
                name: "lastChance",
                type: "staticText",
                title: "<spring:message code='course.lastChance'/>",
                wrapTitle: false,
            },
            {
                name: "nationalCode",
                type: "staticText",
                title: "<spring:message code='national.code'/>",
                wrapTitle: false,
            },
            {
                name: "empNo",
                type: "staticText",
                title: "<spring:message code='personnel.no.6.digits'/>",
                wrapTitle: false,
            },
            {
                name: "firstName",
                type: "staticText",
                title: "<spring:message code='firstName'/>",
                wrapTitle: false,
            },
            {
                name: "lastName",
                type: "staticText",
                title: "<spring:message code='lastName'/>",
                wrapTitle: false,
            },
            {
                name: "affairs",
                type: "staticText",
                title: "<spring:message code='affairs'/>",
                wrapTitle: false,
            },
            {
                name: "unit",
                type: "staticText",
                title: "<spring:message code='unit'/>",
                wrapTitle: false,
            },
        ]
    });

    var EvaluationReactionHeaderHLayout = isc.HLayout.create({
        width: "100%",
        height: 120,
        border: "1px solid black",
        layoutMargin: 5,
        members: [
            EvaluationReactionHeaderForm
        ]
    });

    var EvaluationReactionVLayout = isc.VLayout.create({
        width: "100%",
        autoDraw: false,
        border: "0px solid black",
        layoutMargin: 5,
        members: [
            EvaluationReactionHeaderHLayout,
            ListGrid_CourseGoal_Evaluation,
            TeacherLG_questionnaire,
            EquipmentLG_questionnaire,
            ListGrid_CourseSkill_Evaluation
        ]
    });

    function setEvaluationReactionStudentHeaderForm(studentRecord) {

        EvaluationReactionHeaderForm.setValue("nationalCode", studentRecord.student.nationalCode);
        EvaluationReactionHeaderForm.setValue("empNo", studentRecord.student.personnelNo2);
        EvaluationReactionHeaderForm.setValue("firstName", studentRecord.student.firstName);
        EvaluationReactionHeaderForm.setValue("lastName", studentRecord.student.lastName);
        EvaluationReactionHeaderForm.setValue("affairs", studentRecord.student.ccpAffairs);
        EvaluationReactionHeaderForm.setValue("unit", studentRecord.student.ccpUnit);
    };

    function setEvaluationReactionClassHeaderForm(classRecord) {

        EvaluationReactionHeaderForm.setValue("courseCode", classRecord.course.code);
        EvaluationReactionHeaderForm.setValue("courseName", classRecord.course.titleFa);
        EvaluationReactionHeaderForm.setValue("classCode", classRecord.code);
        EvaluationReactionHeaderForm.setValue("classStart", classRecord.startDate);
        EvaluationReactionHeaderForm.setValue("classEnd", classRecord.endDate);
        EvaluationReactionHeaderForm.setValue("lastChance", "");
    };

   function loadPage_reaction() {

         var studentRecord = StudentsLG_student.getSelectedRecord();
         var classRecord = ListGrid_Class_JspClass.getSelectedRecord();

         setEvaluationReactionStudentHeaderForm(studentRecord);
         setEvaluationReactionClassHeaderForm(classRecord);

         TotalGoalDS_questionnaire.fetchDataURL = courseUrl + ListGrid_Class_JspClass.getSelectedRecord().course.id + "/goal";
         ListGrid_CourseGoal_Evaluation.fetchData();

         TeacherDS_questionnaire.fetchDataURL = questionnaireQuestionUrl + "/teacherQuestionnaire";
         TeacherLG_questionnaire.fetchData();

         EquipmentDS_questionnaire.fetchDataURL = questionnaireQuestionUrl + "/equipmentQuestionnaire";
         EquipmentLG_questionnaire.fetchData();

       CourseSkillDS_questionnaire.fetchDataURL = questionnaireQuestionUrl  + "/skillQuestionnaire/" + ListGrid_Class_JspClass.getSelectedRecord().course.id;
       ListGrid_CourseSkill_Evaluation.fetchData();
   };

    // </script>

    ////////////////////////////////////////////////////////////////////////////////////////