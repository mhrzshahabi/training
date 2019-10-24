/*
abaspour 9803
*/
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

	<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

	var rejectDocumentLabel = null;
	var doRejectTaskButton = null;

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
	var ${taskFormVariable.dsName} =
	isc.RestDataSource.create({
		fields: [
			<%--{name: "crDate", title: "تاریخ ایجاد",type:"text"},--%>
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
	<c:if test="${taskFormVariable.value !=' ' }">
	rejectDocumentLabel = isc.HTMLFlow.create({
		ID: "rejectDocumentLabel",
		width: "100%", align: "center",
		styleName: "exampleTextBlock",
		contents: "<center><hr> <b> <p style='color:#FF0000';> ${taskFormVariable.value} </p></b><hr></center>"
	});
	</c:if>
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
				message: "آیا اطمینان دارید؟",
				icon: "[SKIN]ask.png",
				buttons: [
					isc.Button.create({title: "بله"}),
					isc.Button.create({title: "خیر"})
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
							actionURL: "${restApiUrl}/api/workflow/doUserTask",
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							httpMethod: "POST",
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							showPrompt: false,
							data: JSON.stringify(ndat),
							params: {"taskId": "${id}", "usr": "${username}"},
							serverOutputAsString: false,
							callback: function (RpcResponse_o) {
								if (RpcResponse_o.data == 'success') {
									isc.say("شایستگی به گردش کار ارسال شد.");
									taskConfirmationWindow.hide();
									ListGrid_UserTaskList.invalidateCache();
									userCartableButton.setTitle("شخصی (" + ${cartableCount -1} +"   )");
									<c:set var="cartableCount" value="${cartableCount -1}"/>
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
	<spring:url value="base/competence?action=show&cId=" var="addDocumentUrl"/>
	isc.IButton.create
	({
		ID: "viewDocButton",
		icon: "[SKIN]actions/edit.png",
		title: "مشاهده ی شایستگی",
		align: "center",
		width: "150",
		click: function () {
			var data = taskStartConfirmForm.getValues();
			//console.log(data);

			alert("here");

			createTab(" شایستگی" + data.cId, "${addDocumentUrl}" + data.cId, false);


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

		}
	});

	<c:forEach items="${formProperties}" var="taskFormVariable" varStatus="loopStatus">

	<c:if test="${taskFormVariable.id =='REJECT'}">
	doRejectTaskButton = isc.IButton.create({
		icon: "[SKIN]actions/edit.png", title: "عودت فعالیت", align: "center", width: "150",
		click: function () {
			isc.Window.create({
				ID: "createWindowtblManagerCommandsInfo", title: "اعلام دلیل برگشت", width: "90%", height: "30%",
				isModal: true, showModalMask: true, showMaximizeButton: true, autoCenter: true, align: "center",
				closeClick: function () {
					this.Super("closeClick", arguments);
				},
				items:
					[
						isc.VLayout.create({
							layoutMargin: 5, showEdges: false, edgeImage: "", alignLayout: "center", membersMargin: 3,
							members: [
								isc.DynamicForm.create({
									ID: "rejectTaskForm",
									dataSource: taskActionsDS,
									colWidths: ["10%", "90%"],
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
													actionURL: "${restApiUrl}/api/workflow/doUserTask",
													httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
													httpMethod: "POST",
													useSimpleHttp: true,
													contentType: "application/json; charset=utf-8",
													showPrompt: false,
													data: JSON.stringify(data),
													params: {"taskId": "${id}", "usr": "${username}"},
													serverOutputAsString: false,
													callback: function (RpcResponse_o) {
														if (RpcResponse_o.data == 'success') {
															isc.say("تعریف شایستگی به گردش کار ارسال شد.");
															taskConfirmationWindow.hide();
															ListGrid_UserTaskList.invalidateCache();
															userCartableButton.setTitle("شخصی (" + ${cartableCount} +"   )");
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