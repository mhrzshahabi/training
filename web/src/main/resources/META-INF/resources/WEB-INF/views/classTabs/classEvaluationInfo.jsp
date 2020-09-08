<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>

//<script>
    var Wait_JspClassEvaluationInfo = null;

    var DynamicForm_JspClassEvaluationInfo = isc.DynamicForm.create({
        titleAlign: "right",
        titleWidth: 200,
        styleName: "evaluation-form",
        numCols: 2,
        margin: 5,
        fields: [
            {
                type: "button",
                title: "ارسال به Excel",
                width: 160,
                height: "30",
                startRow: false,
                endRow: true,
                click: function () {
                    let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                    if (!(classRecord === undefined || classRecord == null)) {

                        let fields = [{name:'title',title:'عنوان'},{name:'value',title:''}]
                        let allRows = [{title:DynamicForm_JspClassEvaluationInfo.getItem('teacherGradeToClass').getTitle(),value:DynamicForm_JspClassEvaluationInfo.getItem('teacherGradeToClass').getValue()},
                                        {title:DynamicForm_JspClassEvaluationInfo.getItem('trainingGradeToTeacher').getTitle(),value:DynamicForm_JspClassEvaluationInfo.getItem('trainingGradeToTeacher').getValue()},
                                        {title:DynamicForm_JspClassEvaluationInfo.getItem('studentsGradeToClass').getTitle(),value:DynamicForm_JspClassEvaluationInfo.getItem('studentsGradeToClass').getValue()},
                                        {title:DynamicForm_JspClassEvaluationInfo.getItem('teacherTotalGrade').getTitle(),value:DynamicForm_JspClassEvaluationInfo.getItem('teacherTotalGrade').getValue()},];

                        ExportToFile.exportToExcelFromClient(fields,allRows,ExportToFile.generateTitle(ListGrid_Class_JspClass),"کلاس - مشاهده وضعيت ارزيابي کلاس");
                    }
                }
            },
            {name: "teacherGradeToClass", title: "نمره ارزیابی مدرس به کلاس", canEdit: false, type: "StaticTextItem"},
            {name: "trainingGradeToTeacher", title: "نمره ارزیابی مسئول آموزش به مدرس", canEdit: false, type: "StaticTextItem"},
            {name: "studentsGradeToClass", title: "نمره ارزیابی واکنشی کلاس", canEdit: false, type: "StaticTextItem"},
            {name: "teacherTotalGrade", title: "نمره ارزیابی نهایی مدرس", canEdit: false, type: "StaticTextItem"}
        ]
    });

    DynamicForm_JspClassEvaluationInfo.getItem('teacherGradeToClass').titleStyle = 'evaluation-code-title';
    DynamicForm_JspClassEvaluationInfo.getItem('trainingGradeToTeacher').titleStyle = 'evaluation-code-title';
    DynamicForm_JspClassEvaluationInfo.getItem('studentsGradeToClass').titleStyle = 'evaluation-code-title';
    DynamicForm_JspClassEvaluationInfo.getItem('teacherTotalGrade').titleStyle = 'evaluation-code-title';

    var VLayout_Body_JspClassEvaluationInfo = isc.TrVLayout.create({
        width: "100%",
        height: "100%",
        overflow: "scroll",
        members: [
            DynamicForm_JspClassEvaluationInfo
        ]
    });

    function loadPage_classEvaluationInfo(classId, studentCount, evaluation) {
        Wait_JspClassEvaluationInfo = createDialog("wait");
        if (studentCount == 0 || studentCount == undefined || evaluation == null || evaluation == undefined) {
            let msg1 = "تعداد فراگیران این کلاس صفر است یا کلاس فاقد نوع ارزیابی می باشد";
            let val1 = getFormulaMessage(msg1 , "2", "red", "b");
            DynamicForm_JspClassEvaluationInfo.setValue("teacherGradeToClass", val1);
            DynamicForm_JspClassEvaluationInfo.setValue("trainingGradeToTeacher", val1);
            DynamicForm_JspClassEvaluationInfo.setValue("studentsGradeToClass", val1);
            DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", val1);
            Wait_JspClassEvaluationInfo.close();
        } else {
            let msg2 = "برای این آیتم هیچ نمره ای وجود ندارد";
            let val2 = getFormulaMessage(msg2 , "2", "red", "b");
            isc.RPCManager.sendRequest(TrDSRequest(
                classUrl + "reactionEvaluationResult/" + classId,
                "GET",
                null,
                (resp) => {
                    let result = JSON.parse(resp.httpResponseText);

                    if(result.teacherGradeToClass == undefined)
                        DynamicForm_JspClassEvaluationInfo.setValue("teacherGradeToClass", val2);
                    else
                        DynamicForm_JspClassEvaluationInfo.setValue("teacherGradeToClass", getFormulaMessage(result.teacherGradeToClass , "2", "black", "b"));
                    if(result.trainingGradeToTeacher == undefined)
                        DynamicForm_JspClassEvaluationInfo.setValue("trainingGradeToTeacher", val2);
                    else
                        DynamicForm_JspClassEvaluationInfo.setValue("trainingGradeToTeacher", getFormulaMessage(result.trainingGradeToTeacher , "2", "black", "b"));
                    if(result.fergrade == undefined)
                        DynamicForm_JspClassEvaluationInfo.setValue("studentsGradeToClass", val2);
                    else
                        DynamicForm_JspClassEvaluationInfo.setValue("studentsGradeToClass", getFormulaMessage(result.fergrade , "2", "black", "b"));

                    if(result.trainingGradeToTeacher == undefined && result.studentsGradeToTeacher == undefined)
                            DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", val2);
                    else if(result.trainingGradeToTeacher == undefined){
                            let val3 = "0 " + " * " + result.z1 + "% + " + result.studentsGradeToTeacher + " * " + result.z2 + "% = " + result.fetgrade;
                            DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", getFormulaMessage(val3 , "2", "black", "b"));
                        }
                    else if(result.studentsGradeToTeacher == undefined){
                            let val4 = result.trainingGradeToTeacher + " * " + result.z1 + "% + " + "0 " + " * " + result.z2 + "% = " + result.fetgrade;
                            DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", getFormulaMessage(val4 , "2", "black", "b"));
                        }
                    else{
                            let val4 = result.trainingGradeToTeacher + " * " + result.z1 + "% + " + result.studentsGradeToTeacher + " * " + result.z2 + "% = " + result.fetgrade;
                            DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", getFormulaMessage(val4 , "2", "black", "b"));
                    }
                    Wait_JspClassEvaluationInfo.close();
                    }
                    ));
                }
        };