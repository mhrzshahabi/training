<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>

//<script>
    var classIdForFinish = null;

    var DynamicForm_JspClassFinish = isc.DynamicForm.create({
        titleAlign: "right",
        titleWidth: 200,
        styleName: "evaluation-form",
        numCols: 2,
        margin: 5,
        fields: [
            {
                type: "button",
                title: "اختتام کلاس",
                width: 160,
                height: "30",
                startRow: false,
                endRow: true,
                click: function () {

                    Window_Class_Finish.show();
//          isc.RPCManager.sendRequest(TrDSRequest(hasAccessToSetEndClass+"61", "GET",null, function (resp) {
        //     if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
        //         if (resp.data === "false" )
        //             TabSet_Class.disableTab(TabSet_Class.tabs[11]);
        //         else
        //             TabSet_Class.enableTab(TabSet_Class.tabs[11]);
        //
        //     } else {
        //         TabSet_Class.disableTab(TabSet_Class.tabs[11]);
        //     }
        // }));
                }
            },
            {
                type: "button",
                title: "حذف اختتام",
                width: 160,
                height: "30",
                startRow: false,
                endRow: true,
                click: function () {

                }
            },
        ]
    });

    let DynamicForm_Finish_Reason = isc.DynamicForm.create({
        width: 600,
        height: 120,
        padding: 6,
        titleAlign: "right",
        fields: [
            {
                name: "reason",
                width: "100%",
                height: 100,
                title: "دلیل اختتام",
                editorType: 'textArea'
            }
        ]
    });

    let Window_Class_Finish = isc.Window.create({
        width: 600,
        height: 120,
        numCols: 2,
        title: "ثبت اختتام",
        items: [
            DynamicForm_Finish_Reason,
            isc.MyHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({
                title: "<spring:message code="save"/>",
                click: function () {

                    // func for finishing class
                    Window_Class_Finish.close();
                    // disable button (اختتام کلاس)
                }}),
                isc.IButtonCancel.create({
                    title: "<spring:message code="cancel"/>",
                        click: function () {
                        Window_Class_Finish.close();
                    }
            })]
        })]
    });

    var VLayout_Body_JspClassFinish = isc.TrVLayout.create({
        width: "100%",
        height: "100%",
        overflow: "scroll",
        members: [
            DynamicForm_JspClassFinish
        ]
    });

       function loadPage_classFinish(classId){
         classIdForFinish=classId;
        }

    // function loadPage_classEvaluationInfo(classId, studentCount, evaluation) {
    //
    //     // Wait_JspClassEvaluationInfo = createDialog("wait");
    //     if (studentCount == 0 || studentCount == undefined || evaluation == null || evaluation == undefined) {
    //         let msg1 = "تعداد فراگیران این کلاس صفر است یا کلاس فاقد نوع ارزیابی می باشد";
    //         let val1 = getFormulaMessage(msg1 , "2", "red", "b");
    //         DynamicForm_JspClassEvaluationInfo.setValue("teacherGradeToClass", val1);
    //         DynamicForm_JspClassEvaluationInfo.setValue("trainingGradeToTeacher", val1);
    //         DynamicForm_JspClassEvaluationInfo.setValue("studentsGradeToClass", val1);
    //         DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", val1);
    //         // Wait_JspClassEvaluationInfo.close();
    //     } else {
    //         let msg2 = "برای این آیتم هیچ نمره ای وجود ندارد";
    //         let val2 = getFormulaMessage(msg2 , "2", "red", "b");
    //         isc.RPCManager.sendRequest(TrDSRequest(
    //             classUrl + "reactionEvaluationResult/" + classId,
    //             "GET",
    //             null,
    //             (resp) => {
    //                 let result = JSON.parse(resp.httpResponseText);
    //
    //                 if(result.teacherGradeToClass == undefined)
    //                     DynamicForm_JspClassEvaluationInfo.setValue("teacherGradeToClass", val2);
    //                 else
    //                     DynamicForm_JspClassEvaluationInfo.setValue("teacherGradeToClass", getFormulaMessage(result.teacherGradeToClass , "2", "black", "b"));
    //                 if(result.trainingGradeToTeacher == undefined)
    //                     DynamicForm_JspClassEvaluationInfo.setValue("trainingGradeToTeacher", val2);
    //                 else
    //                     DynamicForm_JspClassEvaluationInfo.setValue("trainingGradeToTeacher", getFormulaMessage(result.trainingGradeToTeacher , "2", "black", "b"));
    //                 if(result.fergrade == undefined)
    //                     DynamicForm_JspClassEvaluationInfo.setValue("studentsGradeToClass", val2);
    //                 else
    //                     DynamicForm_JspClassEvaluationInfo.setValue("studentsGradeToClass", getFormulaMessage(result.fergrade , "2", "black", "b"));
    //
    //                 if(result.trainingGradeToTeacher == undefined && result.studentsGradeToTeacher == undefined)
    //                         DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", val2);
    //                 else if(result.trainingGradeToTeacher == undefined){
    //                         let val3 = "0 " + " * " + result.z1 + "% + " + result.studentsGradeToTeacher + " * " + result.z2 + "% = " + result.fetgrade;
    //                         DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", getFormulaMessage(val3 , "2", "black", "b"));
    //                     }
    //                 else if(result.studentsGradeToTeacher == undefined){
    //                         let val4 = result.trainingGradeToTeacher + " * " + result.z1 + "% + " + "0 " + " * " + result.z2 + "% = " + result.fetgrade;
    //                         DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", getFormulaMessage(val4 , "2", "black", "b"));
    //                     }
    //                 else{
    //                         let val4 = result.trainingGradeToTeacher + " * " + result.z1 + "% + " + result.studentsGradeToTeacher + " * " + result.z2 + "% = " + result.fetgrade;
    //                         DynamicForm_JspClassEvaluationInfo.setValue("teacherTotalGrade", getFormulaMessage(val4 , "2", "black", "b"));
    //                 }
    //                 // Wait_JspClassEvaluationInfo.close();
    //                 }
    //                 ));
    //             }
    //     };