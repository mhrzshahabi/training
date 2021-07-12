<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
/*
abaspour 9803
*/
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    var workFlowName = null;
    var rejectDocumentLabel = null;
    var doRejectTaskButton = null;
    var doDeleteTaskButton = null;
    var viewDocButton = null;
    var targetUrl = null;
    var taskActionsDS = isc.RestDataSource.create({
        fields: [
            {name: "REJECTVAL", type: "text", required: true},
            {name: "processId", type: "text"}
            <%--<c:forEach items="${formProperties}" var="taskFormVariable" varStatus="loopStatus">--%>
            <%--,{--%>
            <%--name:"${taskFormVariable.id}"--%>
            <%--}--%>
            <%--</c:forEach>--%>
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",

    });

    <c:forEach items="${formProperties}" var="taskFormVariable" varStatus="loopStatus">
    <c:if test="${taskFormVariable.objectType == 'SelectItem' && taskFormVariable.dsName != null}">
    // var ${taskFormVariable.dsName} =
    isc.RestDataSource.create({
        fields: [
            <%--{name: "crDate", title: "<spring:message code="creation.date"/>",type:"text"},--%>
            {name: "id", title: "id", type: "text"},
            <%--{name: "assignee", title: "assignee", type: "text"},--%>
            <%--{name: "recom", title: "recom", type: "text"}--%>

        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        fetchDataURL: "<spring:url value="${taskFormVariable.fetchDataURL}"/>"
    });
    <%--&lt;%&ndash;&ndash;%&gt; ${taskFormVariable.dsName}.fetchData({_startRow:1,_endRow:100});--%>

    </c:if>
    <c:if test="${taskFormVariable.id =='REJECTVAL' }">
    <c:if test="${taskFormVariable.value !=' '}">
    rejectDocumentLabel = isc.HTMLFlow.create({
        ID: "rejectDocumentLabel",
        width: "100%", align: "center",
        styleName: "exampleTextBlock",
        contents: "<center><hr> <b> <p style='color:#FF0000';> ${taskFormVariable.value} </p></b><hr></center>"
    });
    </c:if>
    </c:if>

    <c:if test="${taskFormVariable.id =='target'}">

    <spring:url value="${taskFormVariable.value}" var="addDocumentUrl"/>

    <%--var targetUrl = "${taskFormVariable.value}";--%>

    </c:if>

    <c:if test="${taskFormVariable.id =='workFlowName'}">
     workFlowName = "${taskFormVariable.value}";
    </c:if>

    <c:if test="${taskFormVariable.id =='targetTitleFa'}">
    var targetTitleFa = "${taskFormVariable.value}";
    var targetTitleFaFull = "مشاهده ی " + targetTitleFa;
    viewDocButton = isc.IButton.create({
        ID: "viewDocButton",
        icon: "[SKIN]actions/edit.png",
        title: targetTitleFaFull,
        align: "center",
        width: "150",
        click: function () {
            let data = taskStartConfirmForm.getValues();
            workflowRecordId = data.cId;
            switch(workFlowName){
                case "NeedAssessment":
                    showWindowDiffNeedsAssessment(workflowRecordId, data.cType,data.rRRRobjectName,false);
                    break;
                case "Competence":
                    isc.RPCManager.sendRequest(TrDSRequest(competenceUrl + "/spec-list?id=" + workflowRecordId, "GET", null,(resp)=>{
                        if(resp.httpResponseCode !== 200){
                            createDialog("warning", "ارتباط با سرور برقرار نشد.")
                        }
                        let record = JSON.parse(resp.data).response.data[0];
                        let valueMap = {
                            0: "ارسال به گردش کار",
                            1: "عدم تایید",
                            2: "تایید نهایی",
                            3: "حذف گردش کار",
                            4: "اصلاح شایستگی و ارسال به گردش کار"
                        }
                        let field = [
                            {name: "code", title: "کد شایستگی", autoFitWidth: true},
                            {name: "title", title: "عنوان شایستگی",autoFitWidth: true},
                            {name: "competenceType.title", title: "نوع شایستگی",autoFitWidth: true},
                            {name: "workFlowStatusCode", title: "وضعیت",autoFitWidth: true, valueMap: valueMap},
                            {name: "category.titleFa", title: "<spring:message code="category"/>",autoFitWidth: true},
                            {name: "category.code", title: "کد گروه",autoFitWidth: true},
                            {name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>",autoFitWidth: true},
                            {name: "subCategory.code", title: "کد زیرگروه",autoFitWidth: true},
                            {name: "description", title: "<spring:message code="description"/>", autoFitWidth: true},
                        ]
                        showDetailViewer("شایستگی", field, record)
                    }));
                    break;
                default:
                    trainingTabSet.removeTab(targetTitleFa);
                    createTab(targetTitleFa, "${addDocumentUrl}");
                    // taskConfirmationWindow.resizeTo(taskConfirmationWindow.widht, 70);
                    // taskConfirmationWindow.maximize();
                    taskConfirmationWindow.top = "0";
                    taskConfirmationWindow.minimize();
            }
            workflowParameters = {
                "taskId": "${id}",
                "usr": "${username}",
                "workflowdata": taskStartConfirmForm.getValues()
            }
        }
    });
    </c:if>

    </c:forEach>

    var taskStartConfirmForm = isc.DynamicForm.create({
        ID: "taskStartConfirmForm",
        width: "100%",
        alignLayout: "center",
        wrapItemTitles: false,
        margin: 10, dataSource: "taskActionsDS", autoFetchData: false,
        numCols: 3,
        cellPadding: 5,
        align: "right",
        requiredMessage: "فیلد اجباری است.",
        fields: [
            {
                type: "text"
                , name: "cId"
                , title: "شناسه فرایند"
                , defaultValue: "${cId}"
                , hidden: true
                , width: 200
            }
            <c:forEach items="${formProperties}" var="taskFormVariable" varStatus="loopStatus">

            <c:choose>
            <c:when test="${ taskFormVariable.isWritable }">, {
                name: "${taskFormVariable.id}"
                , suppressBrowserClearIcon: true, showIconsOnFocus: true
                , icons: [
                    {
                        name: "clear", src: "[SKINIMG]actions/close.png"
                        , width: 20, height: 20, inline: false, prompt: "Clear"
                        , click: function (form, item, icon) {
                            item.setValue("")
                            item.focusInItem();
                        }
                    }
                    , {
                        name: "undo", src: "[SKINIMG]actions/undo.png"
                        , width: 20, height: 20, inline: false, prompt: "undo"
                        , click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                        }
                    }
                ]
                , iconWidth: 36
                , iconHeight: 36
                </c:when>
                <c:otherwise>,{
                name: "rRRR${taskFormVariable.id}" </c:otherwise>
                </c:choose>
                <c:choose>
                <c:when test="${taskFormVariable.id =='REJECT'}">,
                type: "hidden" </c:when>
                <c:when test="${taskFormVariable.id =='REJECTVAL'}">,
                type: "hidden" </c:when>
                <c:when test="${taskFormVariable.id =='target'}">,
                type: "hidden" </c:when>
                <c:when test="${taskFormVariable.id =='targetTitleFa'}">,
                type: "hidden" </c:when>
                <c:when test="${taskFormVariable.id =='cId'}">,
                type: "hidden" </c:when>
                <c:when test="${taskFormVariable.id =='workFlowName'}">,
                type: "hidden" </c:when>
                <c:when test="${taskFormVariable.id =='cType'}">,
                type: "hidden" </c:when>
                <c:when test="${taskFormVariable.id =='DELETE'}">,
                type: "hidden" </c:when>
                <c:when test="${fn:startsWith(taskFormVariable.id,'role')}">,
                type: "hidden" </c:when>
                <c:when test="${((dataForm.repeated) && (!(taskFormVariable.isWritable || dataForm.id=='RFQ')))}">,
                type: "hidden" </c:when>
                <c:when test="${taskFormVariable.objectType == 'date'}">
                ,
                type: "text"
                ,
                icons: [
                    {
                        src: "pieces/pcal.png", click: function () {
                            displayDatePicker("${taskFormVariable.id}", this, 'ymd', '/');
                        }
                    }
                ]
                </c:when>
                <c:when test="${taskFormVariable.objectType == 'string' || taskFormVariable.objectType =='long'}">
                ,
                type: "text"
                </c:when>
                <c:otherwise>
                ,
                type: "${taskFormVariable.objectType}"
                </c:otherwise>
                </c:choose>
                ,
                required: ${taskFormVariable.isRequired eq true}
                ,
                width: "${taskFormVariable.width == null ? 500 : taskFormVariable.width  }"
                ,
                colSpan: 2
                ,
                titleColSpan: 1
                ,
                tabIndex: 1
                <c:if test="${taskFormVariable.multiple != null}">
                ,
                multiple: "${taskFormVariable.multiple}"
                </c:if>
                ,
                canEdit:${taskFormVariable.isWritable eq true}
                ,
                title: "${taskFormVariable.name}"
                ,
                showHover: true
                ,
                align: "right"
                <c:if test="${taskFormVariable.value != null}">
                ,
                defaultValue: "${taskFormVariable.value}"
                </c:if>
                <c:if test="${taskFormVariable.objectType == 'SelectItem' && taskFormVariable.dsName != null && taskFormVariable.tblDataSource != null }">
                ,
                editorType: "SelectItem"
                ,
                optionDataSource:${taskFormVariable.dsName}
                ,
                displayField: "${taskFormVariable.tblDataSource.dsDisplayField}"
                ,
                valueField: "${taskFormVariable.tblDataSource.dsValueField}"
                ,
                pickListWidth: "${taskFormVariable.tblDataSource.dsPickListWidth}"
                ,
                pickListProperties: {
                    showFilterEditor: true
                }
                <c:if test="${taskFormVariable.dsCriteria != null}">
                ,
                optionCriteria:${taskFormVariable.dsCriteria}
                </c:if>
                <c:if test="${taskFormVariable.pickListCriteria != null}">
                ,
                getPickListFilterCriteria: function () {
                    return ${taskFormVariable.pickListCriteria};
                }
                </c:if>
                ,
                pickListFields: [
                    <c:set var="dataParts" value="${fn:split(taskFormVariable.tblDataSource.dsPickListFields, ',')}" />
                    <c:forEach items="${dataParts}" var="optionVariable1" varStatus="loopStatus1">
                    <c:choose>
                    <c:when test="${loopStatus1.last}">
                    {name: '<c:out value="${optionVariable1}"></c:out>'}
                    </c:when>
                    <c:otherwise>
                    {name: '<c:out value="${optionVariable1}"></c:out>'},
                    </c:otherwise>
                    </c:choose>
                    </c:forEach>
                ]
                </c:if>

                <c:if test="${taskFormVariable.listValues != null && taskFormVariable.listValues!='SHOWPROPERTY_numberSep'}">
                ,
                valueMap:
                ${taskFormVariable.listValues}
                </c:if>
                <c:if test="${taskFormVariable.listValues != null && taskFormVariable.listValues=='SHOWPROPERTY_numberSep'}">
                ,
                change: function (form, item, value, oldValue) {
                    item.setValue(ThousandSeparate1(value));
                }
                ,
                keyPressFilter: "[0-9.]"

                </c:if>
            }

            </c:forEach>
        ]
    });


    isc.IButton.create
    ({
        ID: "doStartTaskButton",
        icon: "[SKIN]actions/edit.png",
        title: "تایید",
        align: "center",
        width: "150",
        click: function () {
            var v = taskStartConfirmForm.hasErrors();
            v = taskStartConfirmForm.validate();
            if (taskStartConfirmForm.hasErrors()) {
                return;
            }
            isc.Dialog.create({
                message: "<spring:message code="are.you.sure"/>",
                title: "<spring:message code="message"/>",
                icon: "[SKIN]ask.png",
                buttons: [
                    isc.IButtonSave.create({title: "<spring:message code="yes"/>"}),
                    isc.IButtonCancel.create({title: "<spring:message code="global.no"/>"})
                ],
                buttonClick: function (button, index) {
                    if (index == 0 && v == true) {
                        taskStartConfirmForm.setValue("REJECT", "N");
                        taskStartConfirmForm.setValue("REJECTVAL", " ");
                        var data = taskStartConfirmForm.getValues();
                        var odat = taskStartConfirmForm.getOldValues();
                        var ndat = {};
                        for (var pr in data)
                            if (pr.startsWith("recom")) {
                                if (!odat.hasOwnProperty(pr) || (odat.hasOwnProperty(pr) && !(odat[pr] == data[pr]))) {
                                    ndat[pr] = (data[pr].startsWith("(${username})") ? data[pr] : "(${username})" + data[pr]);
                                }
                            } else if (!pr.startsWith("rRRR"))
                                ndat[pr] = data[pr];

                        isc.RPCManager.sendRequest({
                            actionURL: workflowUrl + "/doUserTask",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            httpMethod: "POST",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            data: JSON.stringify(ndat),
                            params: {"taskId": "${id}", "usr": "${username}"},
                            serverOutputAsString: false,
                            callback: function (RpcResponse_o) {
                                if (RpcResponse_o.data == 'success') {
                                    // isc.say(rejectDocumentLabel == null ? targetTitleFa + " تایید شد." : targetTitleFa + " جهت بررسی ارسال شد.");
                                    //isc.say(rejectDocumentLabel == null ? " تایید شد." : " جهت بررسی ارسال شد.");
                                    simpleDialog("<spring:message code="message"/>", rejectDocumentLabel == null ? " تایید شد." : " عملیات تایید با موفقیت انجام شد.", 3000, "say");
                                    taskConfirmationWindow.hide();
                                    ListGrid_UserTaskList.invalidateCache();
                                    <%--userCartableButton.setTitle("شخصی (" + ${cartableCount -1} +"   )");--%>
                                    <%--<c:set var="cartableCount" value="${cartableCount -1}"/>--%>

                                    activeDocumentDS.fetchDataURL = "";
                                    ListGrid_DocumentActivity.setData([]);

                                } else {
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
            ID: "doCancelUserTaskButton",
            icon: "[SKIN]actions/edit.png",
            title: "بستن",
            align: "center",
            width: "150",
            click: function () {
                taskConfirmationWindow.hide();
                <%--trainingTabSet.removeTab(targetTitleFa);--%>
                <%--createTab(targetTitleFa, "<spring:url value="/tclass/show-form"/>",true);--%>
            }
        }
    );

    Window_userCartableReject = isc.Window.create({
        ID: "createWindowtblManagerCommandsInfo", title: "اعلام دلیل برگشت", width: "50%",
        isModal: true, showModalMask: true, showMaximizeButton: true, autoCenter: true, align: "center",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items:
            [
                isc.VLayout.create({
                    layoutMargin: 5,
                    showEdges: false,
                    edgeImage: "",
                    alignLayout: "center",
                    membersMargin: 3,
                    width: "100%",
                    height: "100%",
                    members: [
                        isc.DynamicForm.create({
                            ID: "rejectTaskForm",
                            dataSource: taskActionsDS,
                            colWidths: ["10%", "80%", "10%"],
                            width: "100%",
                            height: "100%",
                            numCols: "3",
                            autoFocus: "true",
                            cellPadding: 5,
                            fields: [
                                {
                                    type: "text",
                                    name: "processId",
                                    title: "شناسه فرایند",
                                    defaultValue: "${id}",
                                    hidden: true,
                                    width: 200
                                },
                                {
                                    name: "REJECTVAL",
                                    title: "عودت بدلیل ",
                                    type: "text",
                                    width: "100%",
                                    height: 40,
                                    required: true,
                                    <c:forEach items="${formProperties}" var="taskFormVariable" varStatus="loopStatus">
                                    <c:if test="${taskFormVariable.id =='REJECTVAL' }"><c:if test="${taskFormVariable.value !=' ' }">defaultValue: "${taskFormVariable.value}", </c:if></c:if>
                                    </c:forEach>
                                }
                                , {name: "REJECT", title: "عودت بدلیل ", type: "hidden"}
                            ]
                        }),
                        isc.HLayout.create({
                            layoutMargin: 5,
                            membersMargin: 3,
                            showEdges: false,
                            edgeImage: "",
                            width: "100%",
                            alignLayout: "center",
                            members: [
                                isc.Label.create({width: 400}),
                                isc.IButton.create({
                                    autoCenter: true, align: "center", width: 200, title: "عودت فعالیت",
                                    click: function () {
                                        rejectTaskForm.validate();
                                        if (rejectTaskForm.hasErrors()) {
                                            return;
                                        }

                                        rejectTaskForm.setValue("REJECT", "Y");
                                        var data = rejectTaskForm.getValues();
                                        isc.RPCManager.sendRequest({
                                            actionURL: workflowUrl + "/doUserTask",
                                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                            httpMethod: "POST",
                                            useSimpleHttp: true,
                                            contentType: "application/json; charset=utf-8",
                                            showPrompt: false,
                                            data: JSON.stringify(data),
                                            params: {"taskId": "${id}", "usr": "${username}"},
                                            serverOutputAsString: false,
                                            callback: function (RpcResponse_o) {
                                                if (RpcResponse_o.data == 'success') {
                                                    simpleDialog("<spring:message code="message"/>", targetTitleFa + " عودت داده شد.", 3000, "say");
                                                    taskConfirmationWindow.hide();
                                                    ListGrid_UserTaskList.invalidateCache();
                                                    <%--userCartableButton.setTitle("شخصی (" + ${cartableCount} +"   )");--%>

                                                    activeDocumentDS.fetchDataURL = "";
                                                    ListGrid_DocumentActivity.setData([]);
                                                }
                                            }
                                        });
                                        createWindowtblManagerCommandsInfo.close();
                                        taskConfirmationWindow.closeClick();
                                    }
                                }) //Button
                            ]
                        }) //Hlayout
                    ]
                })//VLayout
            ]//Window
    });

    <c:forEach items="${formProperties}" var="taskFormVariable" varStatus="loopStatus">

    <c:if test="${taskFormVariable.id =='REJECT'}">
    doRejectTaskButton = isc.IButton.create({
        icon: "[SKIN]actions/edit.png", title: "عودت فعالیت", align: "center", width: "150",
        click: function () {
            Window_userCartableReject.show();
        }
    });
    </c:if>

    <c:if test="${taskFormVariable.id =='DELETE'}">
    doDeleteTaskButton = isc.IButton.create({
        icon: "[SKIN]actions/edit.png", title: "حذف گردش کار", align: "center", width: "150",
        click: function () {

            isc.MyYesNoDialog.create({
                message: "<spring:message code="course.remove.from.workflow.ask"/>",
                title: "<spring:message code="message"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        taskStartConfirmForm.setValue("REJECT", "Y");
                        taskStartConfirmForm.setValue("REJECTVAL", "حذف از گردش کار");
                        var data = taskStartConfirmForm.getValues();
                        var odat = taskStartConfirmForm.getOldValues();
                        var ndat = {};
                        for (var pr in data)
                            if (pr.startsWith("recom")) {
                                if (!odat.hasOwnProperty(pr) || (odat.hasOwnProperty(pr) && !(odat[pr] == data[pr]))) {
                                    ndat[pr] = (data[pr].startsWith("(${username})") ? data[pr] : "(${username})" + data[pr]);
                                }
                            } else if (!pr.startsWith("rRRR"))
                                ndat[pr] = data[pr];

                        isc.RPCManager.sendRequest({
                            actionURL: workflowUrl + "/doUserTask",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            httpMethod: "POST",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            data: JSON.stringify(ndat),
                            params: {"taskId": "${id}", "usr": "${username}"},
                            serverOutputAsString: false,
                            callback: function (RpcResponse_o) {
                                if (RpcResponse_o.data == 'success') {

                                    isc.say("گردش کار حذف شد.");
                                    taskConfirmationWindow.hide();
                                    ListGrid_UserTaskList.invalidateCache();

                                }
                            }
                        });
                    }
                }
            });
        }
    });
    </c:if>

    </c:forEach>

    isc.HLayout.create({
        ID: "userTaskConfirmFooterHLayout",
        width: "100%",
        align: "center",
        membersMargin: 10,
        members: [
            doDeleteTaskButton,
            viewDocButton,
            doStartTaskButton,
            doRejectTaskButton,
            doCancelUserTaskButton
        ]
    });
    isc.HTMLFlow.create({
        ID: "userTaskDocumentLabel",
        width: "100%", align: "center",
        styleName: "exampleTextBlock",
        contents: "<center><hr> <b> ${assignee} : ${title} ${description}  </p></b><hr></center>"
    });

    isc.VLayout.create({
        ID: "userTaskConfirmVLayout",
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
            userTaskDocumentLabel,
            rejectDocumentLabel,
            taskStartConfirmForm,
            userTaskConfirmFooterHLayout,
//  isc.ListGrid.create({
// width: "100%",
// height: "100%",autoFetchData:true,
// dataSource: TblUserTaskList})

        ]
    });
