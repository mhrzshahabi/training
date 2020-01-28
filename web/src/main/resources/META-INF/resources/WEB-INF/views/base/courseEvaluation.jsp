<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>

// <script>

    var RestDataSource_course_evaluation = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>"},
            {name: "titleFa", title: "<spring:message code="title"/>"},
            {
                name: "evaluation", valueMap: {
                    "1": "واکنش",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج",
                }, title: "سطح ارزیابی"
            },
            {
                name: "behavioralLevel", valueMap: {
                    "1": "مشاهده",
                    "2": "مصاحبه",
                    "3": "کار پروژه ای",
                }
            }

        ],

        autoFetchData: false,
    });
    //=========================================ListGrid=========================
    var ListGrid_CourseEvaluation = isc.TrLG.create({
        // filterOperator: "iContains",
        // allowAdvancedCriteria: true,
        // allowFilterExpressions: true,
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSource_course_evaluation,
        fields: [
            {name: "code", title: "<spring:message code="code"/>"},
            {name: "titleFa", title: "<spring:message code="title"/>"},
            {
                name: "evaluation", title: "<spring:message code="evaluation.level"/>",

                formatCellValue: function (value, record, field) {
                    if (value === "رفتاری") {
                        return value + " , " + record.behavioralLevel
                    } else {
                        return value;
                    }

                }
            }
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
                title: "<spring:message code="evaluation.level"/>",
                type: "select",
                defaultValue: "1",
                valueMap: {
                    "1": "واکنش",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج",
                },
                change: function (form, item, value, oldValue) {
                    if (value === "3")
                        DynamicForm_CourseEvaluation.getItem("behavioralLevel").setDisabled(false);
                    else
                        DynamicForm_CourseEvaluation.getItem("behavioralLevel").setDisabled(true);
                }

            },

            {
                type: "button",
                title: "<spring:message code="register"/>",
                fontsize: 2,
                width: 160,
                height: "30",
                showDownIcon: true,
                startRow: false,
                endRow: false,
                click: function () {
                    var record = ListGrid_Course.getSelectedRecord();
                    if (DynamicForm_CourseEvaluation.getItem("evaluation").getValue() === "3") {
                        record["behavioralLevel"] = DynamicForm_CourseEvaluation.getItem("behavioralLevel").getValue()
                    }
                    record["evaluation"] = DynamicForm_CourseEvaluation.getItem("evaluation").getValue();
                    isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "evaluation/" + record.id, "PUT", JSON.stringify(record), "callback:show_ListGrid_CourseEvaluation(rpcResponse)"));

                }
            },
            {
                name: "behavioralLevel",
                title: "<spring:message code="behavioral.Level"/>",
                type: "radioGroup",
                vertical: false,
                fillHorizontalSpace: true,
                defaultValue: "مشاهده",
                valueMap: {
                    "مشاهده": "مشاهده",
                    "مصاحبه": "مصاحبه",
                    "کار پروژه ای": "کار پروژه ای",
                }
            },
// {
// // type: "SpacerItem",
// },
        ]
    })
    //======================================================================
    var HLayout_Body_Top_CourseEvaluation = isc.HLayout.create({
        width: "100%",
        height: "30%",

        members: [DynamicForm_CourseEvaluation],
    });

    var HLayout_Body_Down_CourseEvaluation = isc.HLayout.create({
        width: "100%",
        height: "70%",
        members: [ListGrid_CourseEvaluation],
    });

    var All_Body_CourseEvaluation = isc.VLayout.create({
        width: "100%",
        showEdges: true,
        members: [HLayout_Body_Top_CourseEvaluation, HLayout_Body_Down_CourseEvaluation]
    });

    //========================================================================

    function show_ListGrid_CourseEvaluation(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_CourseEvaluation.fetchData();
            ListGrid_CourseEvaluation.invalidateCache();
        } else {
            simpleDialog("<spring:message code="warning"/>", "<spring:message
        code="msg.error.connecting.to.server"/>", 3000, "error");
        }

    };

    function loadPage_course_evaluation() {

        var record = ListGrid_Course.getSelectedRecord();
      if ( record == undefined || record == null) {
                    ListGrid_CourseEvaluation.setData([]);
                     DynamicForm_CourseEvaluation.disable()
         }
        else
           {
                  if (
                            ListGrid_Course.getSelectedRecord().hasGoal) {
                            ListGrid_CourseEvaluation.setData([]);
                            createDialog("info", "این دوره دارای هدف نمی باشد", "پیغام")
                            DynamicForm_CourseEvaluation.disable()
                            DynamicForm_CourseEvaluation.getItem("evaluation").setValue("1")

                   }
                  else
                        {
                              DynamicForm_CourseEvaluation.enable()
                              RestDataSource_course_evaluation.fetchDataURL = courseUrl + "getEvaluation/" + record.id
                              DynamicForm_CourseEvaluation.getItem("behavioralLevel").setDisabled(true)
                              ListGrid_CourseEvaluation.fetchData();
                              ListGrid_CourseEvaluation.invalidateCache();
                        }
            }

    }

    DynamicForm_CourseEvaluation.disable()


