<%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 1/13/2019
  Time: 3:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%--<script>--%>

var form = isc.DynamicForm.create({
ID: "processStartConfirmForm",
width: "100%",
dataSource: "processTaskActionsDS",
alignLayout: "center",
wrapItemTitles: false,
margin: 10,
autoFetch: true,
autoFocus: "true",
numCols: 3,
cellPadding: 5,
<%--titleAlign :right,--%>
align: "right",
requiredMessage: "فیلد اجباری است.",
fields: [

{
type: "text"
, name: "title"
, title: "عنوان کار"
, defaultValue: "${title}"
, canEdit: false
, width: 200
},
{
type: "text"
, name: "processId"
, title: "ID"
, defaultValue: "${id}"
, canEdit: false
, width: 200
}
, {
type: "text"
, name: "competnecyCreator"
, title: "ایجاد کننده ی فرایند"
, defaultValue: "${username}"
, canEdit: false
, hidden: true

}


<c:forEach items="${formProperties}" var="taskFormVariable" varStatus="loopStatus">

    , {
    name: "${taskFormVariable.id}"
    <c:if test="${taskFormVariable.isReadable eq true}">
        <c:if test="${taskFormVariable.objectType ne 'date'}">
            , type: "${taskFormVariable.objectType}"

        </c:if>
        <c:if test="${taskFormVariable.objectType == 'date'}">
            , type: "text"
            , icons: [
            {
            src: "pieces/pcal.png", click: function () {
            displayDatePicker("${taskFormVariable.id}", this, 'ymd', '/');
            }
            }
            ]
        </c:if>
        , required: true
        , width: 200
        , colSpan: 2
        , titleColSpan: 1
        , tabIndex: 1
        <c:if test="${taskFormVariable.multiple != null}">
            , multiple: "${taskFormVariable.multiple}"
        </c:if>

        , canEdit:${taskFormVariable.isWritable}
        , title: "${taskFormVariable.name}"
        , showHover: true
        , align: "right"
        <c:if test="${taskFormVariable.value != null}">
            , defaultValue: "${taskFormVariable.value}"
        </c:if>

        <c:if test="${taskFormVariable.objectType == 'SelectItem'}">
            , editorType: "SelectItem"
            <%--, optionDataSource:""--%>
            <%--,displayField:""--%>
            , valueField: "${taskFormVariable.listValues.values}"
            , pickListWidth: "150"
            , pickListProperties: {
            showFilterEditor: true
            }
            , pickListFields: []
        </c:if>
        <c:if test="${taskFormVariable.listValues != null}">
            , valueMap: {
            ${taskFormVariable.listValues}
            }
        </c:if>
    </c:if>
    <c:if test="${taskFormVariable.isReadable == false}">
        , type: "hidden"
    </c:if>
    }

</c:forEach>
]
});

isc.IButton.create
({
ID: "doStartProcessButton",
icon: "[SKIN]actions/edit.png",
title: "شروع فرایند",
align: "center",
width: "150",
click: function () {
processStartConfirmForm.validate();
if (processStartConfirmForm.hasErrors()) {
return;
}
isc.Dialog.create({
message: "آیا اطمینان دارید؟",
icon: "[SKIN]ask.png",
buttons: [
isc.Button.create({title: "<spring:message code="yes"/>"}),
isc.Button.create({title: "<spring:message code="global.no"/>"})
],
buttonClick: function (button, index) {

if (index == 0) {
var data = processStartConfirmForm.getValues();
isc.RPCManager.sendRequest({

actionURL: "<spring:url value="/web/workflow/startProcess/"/>" + "?Authorization=Bearer " + "${cookie['access_token'].getValue()}",
httpMethod: "POST",
useSimpleHttp: true,
contentType: "application/json; charset=utf-8",
showPrompt: false,
data: JSON.stringify(data),
params: {"processDefId": "${id}", "user": "${username}"},
serverOutputAsString: false,
callback: function (RpcResponse_o) {
if (RpcResponse_o.data == 'success') {
isc.say("فرایند آغاز شد.");
processConfirmVLayout.hide();
ListGrid_ProcessDefinitionList.invalidateCache();
} else {
isc.say(RpcResponse_o.data);
}
}
});

}

this.hide();
}
});
}
});


isc.IButton.create
({
ID: "doCancelProcessButton",
icon: "[SKIN]actions/edit.png",
title: "کنسل",
align: "center",
width: "150",
click: function () {

processConfirmVLayout.hide();

}
});

isc.HLayout.create({
ID: "processConfirmHeaderHLayout",
width: "100%",
height: "100%",
align: "center",
members: [
processStartConfirmForm
]
});


isc.HLayout.create({
ID: "processConfirmFooterHLayout",
width: "100%",
align: "center",
membersMargin: 10,
members: [
doStartProcessButton,
doCancelProcessButton
]
});

isc.Label.create({
ID: "processDocumentLabel",
wrap: false,
icon: "",
contents: "${description}",
dynamicContents: true
});

isc.Label.create({
ID: "processTitleLabel",
wrap: false,
icon: "",
contents: "${title}",
dynamicContents: true
});

isc.HLayout.create({
ID: "processConfirmDocumentHLayout",
width: "100%",
height: "10%",
align: "center",
membersMargin: 10,
members: [
processDocumentLabel,
processTitleLabel
]
});

isc.VLayout.create({
ID: "processConfirmVLayout",
layoutMargin: 5,
membersMargin: 10,
showEdges: false,
overflow: "auto",
edgeImage: "",
width: "100%",
height: "100%",
//backgroundColor: "#FFAAAA",
alignLayout: "center",
members: [

processConfirmDocumentHLayout,
processConfirmHeaderHLayout
, processConfirmFooterHLayout


]
});