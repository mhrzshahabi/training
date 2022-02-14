<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var change_value_JspEGQ = false;
    var classRecord_JspEGQ;
    var wait_JspEGQ;

    var RestDataSource_Golas_JspEGQ = isc.TrDS.create({
        transformResponse: function (dsResponse, dsRequest, data) {
            <sec:authorize access="hasAuthority('Evaluation_Goals_R')">
            ListGrid_Goal_JspEGQ.setData(data.response.data.toArray());
            </sec:authorize>
            return this.Super("transformResponse", arguments);
        },
        fields: [
            {name: "question"},
            {name: "originQuestion"},
            {name: "skillId"},
            {name: "goalId"},
            {name: "classId"},
            {name: "id"}
        ]
    });

    var ListGrid_Goal_JspEGQ = isc.TrLG.create({
        width: "100%",
        height: "100%",
        selectionType: "single",
        showRowNumbers: false,
        <sec:authorize access="hasAuthority('Evaluation_Goals_Actions')">
        editOnFocus: true,
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        canSelectCells: true,
        canRemoveRecords: true,
        </sec:authorize>
        canHover: true,
        autoFetchData: false,
        fields: [
            {
                name: "originQuestion",
                title: "سوالات اهداف کلاس",
                autoFithWidth: true
            },
            {
                name: "question",
                title: "سوالات ویرایش شده",
                <sec:authorize access="hasAuthority('Evaluation_Goals_Actions')">
                canEdit: true,
                </sec:authorize>
                validateOnChange: false,
                editEvent: "click",
                autoFithWidth: true,
                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum) {
                    record.question = newValue;
                }
            }
        ]
    });

    var IButton_SaveButton_JspEGQ = isc.IButtonSave.create({
        top: 260,
        click: function () {
            let data = ListGrid_Goal_JspEGQ.getData();
            wait_JspEGQ = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/classHasEvaluationForm/" + classRecord_JspEGQ.id, "GET", null, function (resp) {
               if(resp.httpResponseText == "true"){
                   createDialog("info", "بعلت استفاده از این اهداف در فرم های ارزیابی امکان ویرایش اهداف وجود ندارد");
                   wait_JspEGQ.close();
               }
               else if(resp.httpResponseText == "false"){
                   if(data.size() == 0){
                       createDialog("info", "امکان حذف تمام اهداف وجود ندارد");
                       wait_JspEGQ.close();
                   }
                   else{
                       isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteClassGoalsQuestions/" + classRecord_JspEGQ.id, "GET", null, function (resp) {
                               isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/editClassGoalsQuestions" , "POST", JSON.stringify(data), function (resp) {
                                       ListGrid_Goal_JspEGQ.invalidateCache();
                                       wait_JspEGQ.close();
                                   }
                               ));
                           }
                       ));
                   }
               }
            }));

        }
    });

    var ToolStripButton_Refresh_JspEGQ = isc.ToolStripButtonRefresh.create({
        title: "لغو تغییرات",
        click: function () {
            RestDataSource_Golas_JspEGQ.fetchDataURL = evaluationUrl + "/getClassGoalsQuestions/" + classRecord_JspEGQ.id;
            RestDataSource_Golas_JspEGQ.fetchData();
            ListGrid_Goal_JspEGQ.invalidateCache();
        }
    });

    var ToolStrip_JspEGQ = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Evaluation_Goals_Actions')">
            ToolStripButton_Refresh_JspEGQ
            </sec:authorize>
        ]
    });

    var HLayout_Actions_JspEGQ = isc.HLayout.create({
        width: "100%",
        height: "1%",
        members: [ToolStrip_JspEGQ]
    });

    var HLayOut_SaveButton_JspEGQ = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        members: [
            <sec:authorize access="hasAuthority('Evaluation_Goals_Actions')">
            IButton_SaveButton_JspEGQ
            </sec:authorize>
        ]
    });

    var VLayout_Body_JspEGQ = isc.TrVLayout.create({
        members: [
            HLayout_Actions_JspEGQ,
            ListGrid_Goal_JspEGQ,
            HLayOut_SaveButton_JspEGQ
        ]
    });

    // </script>
