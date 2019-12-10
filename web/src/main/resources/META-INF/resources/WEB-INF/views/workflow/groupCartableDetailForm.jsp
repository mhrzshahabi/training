<%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 1/13/2019
  Time: 3:25 PM
  update abaspour 9803
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%--<script>--%>

var form = isc.DynamicForm.create({
ID: "groupsTasksStartConfirmForm",
width:"100%",
dataSource:"groupTasksActionsDS",
alignLayout:"center",
wrapItemTitles : false,
margin:10,
autoFetch:true,
autoFocus:"true",
numCols:3,
cellPadding : 5,
<%--titleAlign :right,--%>
align:"right",
requiredMessage: "فیلد اجباری است.",
fields: [
{
type:"text"
,name:"title"
,title:"عنوان کار"
,defaultValue :"${title}"
,canEdit : false
,width:200
},
{
type:"text"
,name:"processId"
,title:"ID"
,defaultValue :"${id}"
,canEdit : false
,width:200
},
<%--{--%>
<%--type: "text"--%>
<%--,name: "employeeName"--%>
<%--,defaultValue: "${username}"--%>
<%--,canEdit: false--%>
<%--,hidden: true--%>

<%--}--%>


<c:forEach items="${formProperties}" var="taskFormVariable" varStatus="loopStatus">

    ,{
    name: "${taskFormVariable.id}"
    <c:if test="${taskFormVariable.isReadable()}">
        <c:choose>
            <c:when test="${taskFormVariable.id =='REJECT'}">,type:"hidden" </c:when>
            <c:when test="${taskFormVariable.id =='REJECTVAL'}">,type:"hidden" </c:when>
            <c:when test="${fn:startsWith(taskFormVariable.id,'role')}">,type:"hidden" </c:when>
            <c:when test="${((dataForm.repeated) && (!(taskFormVariable.isWritable() || dataForm.id=='RFQ')))}"> ,type:"hidden" </c:when>
            <c:when test="${taskFormVariable.objectType == 'date'}">
                ,type:"text"
                ,icons: [
                {
                src: "pieces/pcal.png" ,click: function () {
                displayDatePicker("${taskFormVariable.id}", this ,'ymd','/');
                }
                }
                ]
            </c:when>
            <c:when test="${taskFormVariable.objectType == 'string' || taskFormVariable.objectType =='long'}">
                ,type:"text"
            </c:when>
            <c:otherwise>
                ,type:"${taskFormVariable.objectType}"
            </c:otherwise>
        </c:choose>
        ,required: false
        ,width:500
        ,colSpan:2
        ,titleColSpan:1
        , tabIndex:1
        ,canEdit:${taskFormVariable.isWritable()}
        ,title:"${taskFormVariable.name}"
        ,showHover:true
        ,align:"right"
        <c:if test="${taskFormVariable.value != null}">
            ,defaultValue: "${taskFormVariable.value}"
        </c:if>
        <c:if test="${taskFormVariable.objectType == 'SelectItem'}">
            ,editorType: "SelectItem"
        </c:if>
        <c:if test="${taskFormVariable.listValues != null}">
            , valueMap: {
            ${taskFormVariable.listValues}
            }
        </c:if>
    </c:if>
    <c:if test="${taskFormVariable.isReadable() == false}">
        ,type:"hidden"
    </c:if>
    ,canEdit : false
    }

</c:forEach>
]
});


isc.IButton.create
({
ID: "doClaimTaskButton",
icon: "[SKIN]actions/edit.png",
title: "به من منتسب شود",
align: "center",
width:"150",
click: function () {
groupsTasksStartConfirmForm.validate();
if (groupsTasksStartConfirmForm.hasErrors()) {
return;
}
isc.Dialog.create({
message : "آیا اطمینان دارید؟",
icon:"[SKIN]ask.png",
buttons : [
isc.Button.create({ title:"بله" }),
isc.Button.create({ title:"خیر" })
],
buttonClick : function (button, index) {

if(index == 0)
{
var data = groupsTasksStartConfirmForm.getValues();
isc.RPCManager.sendRequest({
actionURL: "<spring:url value="/rest/workflow/doClaimTaskToUser/"/>" ,
httpMethod: "POST",
useSimpleHttp: true,
contentType: "application/json; charset=utf-8",
showPrompt:false,
data: JSON.stringify(data),
params: {"taskId": "${id}", "user":"${username}"},
serverOutputAsString: false,
callback: function (RpcResponse_o) {
if(RpcResponse_o.data == 'success'){
isc.say("کار به شما منتسب شد.");
ListGrid_GroupTaskList.invalidateCache();
GroupTask_ViewLoader.hide();
}
else {
<%--isc.say(RpcResponse_o.data);--%>
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
ID: "doCancelUserClaimTaskButton",
icon: "[SKIN]actions/edit.png",
title: "کنسل",
align: "center",
width:"150",
click: function () {
processConfirmVLayout.hide();


}
});

isc.HLayout.create({
ID:"groupTakConfirmHeaderHLayout",
width: "100%",
height: "100%",
align :"center",
members: [
groupsTasksStartConfirmForm
]
});


isc.HLayout.create({
ID:"groupTaskConfirmFooterHLayout",
width: "100%",
align :"center",
membersMargin :10,
members: [
doClaimTaskButton,
doCancelUserClaimTaskButton
]
});

isc.Label.create({
ID:"groupTaskDocumentLabel",
wrap:false,
icon:"",
contents:"${description}" ,
dynamicContents:true
});
isc.Label.create({
ID:"groupTaskTitleLabel",
wrap:false,
icon:"",
contents:"\n${title}\n>>",
dynamicContents:true
});
isc.HLayout.create({
ID:"groupTaskConfirmDocumentHLayout",
width: "100%",
height: "10%",
align :"center",
membersMargin :10,
members: [
groupTaskDocumentLabel,
groupTaskTitleLabel
]
});

isc.VLayout.create({
ID:"groupTaskConfirmVLayout",
layoutMargin:5,
membersMargin :10,
showEdges: false,
overflow:"auto",
edgeImage:"",
width:"100%",
height:"100%",
//backgroundColor: "#FFAAAA",
alignLayout:"center",
members : [
groupTaskConfirmDocumentHLayout,
groupTakConfirmHeaderHLayout,
groupTaskConfirmFooterHLayout
]
});