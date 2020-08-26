<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

    var change_value_JspEGQ = false;
    var classRecord_JspEGQ;
    var wait_JspEGQ;

    var RestDataSource_Golas_JspEGQ = isc.TrDS.create({
        fields: [
            {name: "question"},
            {name: "goalQuestion"},
            {name: "skillId"},
            {name: "goalId"},
            {name: "classId"},
            {name: "id"}
        ]
    });


    var ListGrid_Goal_JspEGQ = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Golas_JspEGQ,
        selectionType: "single",
        editOnFocus: true,
        showRowNumbers: false,
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        canHover: true,
        canSelectCells: true,
        autoFetchData: false,
        fields: [
            {
                name: "goalQuestion",
                title: "سوالات اهداف کلاس",
            },
            {
                name: "question",
                title: "سوالات ویرایش شده",
                canEdit: true,
                validateOnChange: false,
                editEvent: "click",
                editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum) {
                        record.question = newValue;
                }
            }
        ],
    });

    var IButton_SaveButton_JspEGQ = isc.IButtonSave.create({
        top: 260,
        click: function () {
            wait_JspEGQ = createDialog("wait");
            let data = ListGrid_Goal_JspEGQ.getData().localData;
            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/editClassGoalsQuestions" , "POST", JSON.stringify(data), function (resp) {
                ListGrid_Goal_JspEGQ.invalidateCache();
                wait_JspEGQ.close();
            }
        ));

    }
    });

    var HLayOut_SaveButton_JspEGQ = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_SaveButton_JspEGQ,
        ]
    });

    var VLayout_Body_JspEGQ = isc.TrVLayout.create({
        members: [
            ListGrid_Goal_JspEGQ,
            HLayOut_SaveButton_JspEGQ
        ]
    });