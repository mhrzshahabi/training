<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>

var x;
var update;

     var RestDataSource_course_evaluation = isc.TrDS.create({
        ID: "courseDS",
        fields: [
        {name: "id", type: "Integer", primaryKey: true,hidden:true},
        {name: "code", title: "کد"},
        {name: "titleFa", title: "عنوان"},
        {name: "evaluation", title: "سطح ارزیابی"}

                ],

       autoFetchData: false,
     });

//=========================================ListGrid=========================
    var ListGrid_CourseEvaluation = isc.TrLG.create({
        filterOperator: "iContains",
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        dataSource: RestDataSource_course_evaluation,
       // contextMenu: Menu_ListGrid_CheckList,
        fields: [
             {name: "code", title: "کد"},
        {name: "titleFa", title: "عنوان"},
        {name: "evaluation", valueMap: {
                    "1":"واکنش",
                    "2":"یادگیری",
                    "3":"رفتاری",
                    "4":"نتایج",
                }, title: "سطح ارزیابی"}

        ],
        recordDoubleClick: function () {

        },
        recordClick: function () {

        },
        selectionUpdated: function () {

        },

    });
    //======================================DynamicForm=============================
      var DynamicForm_CourseEvaluation = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        numCols: 6,
        padding: 20,
        colWidths: ["1%", "30%", "20%", "8%"],
        items: [
            {
                name: "evaluation",
                title: "سطوح ارزيابي",
                type: "select",
               defaultValue: "1",
               valueMap: {
                    "1":"واکنش",
                    "2":"یادگیری",
                    "3":"رفتاری",
                    "4":"نتایج",
                },
                change:function(form, item, value, oldValue) {
                if(value === "3")
                 DynamicForm_CourseEvaluation.getItem("behavioral_level").setDisabled(false);
                 else
                   DynamicForm_CourseEvaluation.getItem("behavioral_level").setDisabled(true);
                }

            },

            {
                type: "button",
                title: "ثبت",
                fontsize:2,
                width: 160,
                height:"30",
                showDownIcon: true,
                startRow: false,
                endRow: false,
                click: function () {
                 var record = ListGrid_Course.getSelectedRecord();
                record["evaluation"]=DynamicForm_CourseEvaluation.getItem("evaluation").getValue();
                isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "evaluation/" + record.id, "PUT", JSON.stringify(record), "callback:show_CheckListItem_is_Delete(rpcResponse)"));
                }
            },
             {
                name: "behavioral_level",
                title: "سطح رفتاری",
                type: "radioGroup",
                vertical:false,
                fillHorizontalSpace: true,
                defaultValue: "1",
                valueMap: {
                    "1": "مشاهده",
                    "2": "مصاحبه",
                    "3": "کار پروژه ای",
                    }

            },
            // {
            //  //   type: "SpacerItem",
            // },
        ]
    })
//======================================================================
    var HLayout_Body_Top_CourseEvaluation = isc.HLayout.create({
        width: "100%",
        height: "30%",

        members: [DynamicForm_CourseEvaluation],
    });

    var HLayout_Body_Down_CourseEvaluation=isc.HLayout.create({
     width: "100%",
     height: "70%",
     members: [ListGrid_CourseEvaluation],
    });

     var All_Body_CourseEvaluation = isc.VLayout.create({
        width: "100%",
        showEdges: true,
        members: [HLayout_Body_Top_CourseEvaluation,HLayout_Body_Down_CourseEvaluation]
    });
//========================================================================

     function loadPage_course_evaluation() {

         var record = ListGrid_Course.getSelectedRecord();

        if(ListGrid_Course.getSelectedRecord().hasGoal)
       {
         createDialog("info","این دوره دارای هدف نمی باشد","پیغام")
         DynamicForm_CourseEvaluation.disable()


        }
        else

        DynamicForm_CourseEvaluation.enable()
        RestDataSource_course_evaluation.fetchDataURL=courseUrl +"getEvaluation/"+ record.id
        DynamicForm_CourseEvaluation.getItem("behavioral_level").setDisabled(true)
        ListGrid_CourseEvaluation.fetchData();
        ListGrid_CourseEvaluation.invalidateCache();
        }


        DynamicForm_CourseEvaluation.disable()

