<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    var change_value_JspEGQ = false;
    var classRecord_JspEGQ;
    var wait_JspEGQ;

    var RestDataSource_Golas_JspEGQ = isc.TrDS.create({
        transformResponse: function (dsResponse, dsRequest, data) {
            ListGrid_Goal_JspEGQ.setData(data.response.data.toArray());
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
        editOnFocus: true,
        showRowNumbers: false,
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        canHover: true,
        canSelectCells: true,
        autoFetchData: false,
        canRemoveRecords: true,
        fields: [
            {
                name: "originQuestion",
                title: "سوالات اهداف کلاس",
                autoFithWidth: true
            },
            {
                name: "question",
                title: "سوالات ویرایش شده",
                canEdit: true,
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
            if(data.size() == 0)
                createDialog("info", "امکان حذف تمام اهداف وجود ندارد");
            else{
                wait_JspEGQ = createDialog("wait");
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
    });

    var ToolStripButton_Refresh_JspEGQ = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
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
            ToolStripButton_Refresh_JspEGQ
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
            IButton_SaveButton_JspEGQ
        ]
    });

    var VLayout_Body_JspEGQ = isc.TrVLayout.create({
        members: [
            HLayout_Actions_JspEGQ,
            ListGrid_Goal_JspEGQ,
            HLayOut_SaveButton_JspEGQ
        ]
    });