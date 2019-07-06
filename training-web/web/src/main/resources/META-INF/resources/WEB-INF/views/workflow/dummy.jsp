<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%--<script>--%>

	<%--var ValuesManager_FiscalYear = isc.ValuesManager.create({});--%>

	var form1 = isc.DynamicForm.create({
		<%--ID: "form1",--%>
		width: "100%",
		dataSource: "userTaskActionsDS",
		alignLayout: "center",
		wrapItemTitles: false,
		margin: 10,
		autoFetch: true,
		numCols: 3,
		cellPadding: 5,
		overflow: "hidden",
		align: "right",
		<%--valuesManager: ValuesManager_FiscalYear,--%>
		requiredMessage: "فیلد اجباری است.",
		fields: [


			{
				type: "text"
				, name: "title"
				, title: "عنوان کار"
				, defaultValue: "بررسی رئیس اداره حقوق و دسمتزد"
				, canEdit: false
				, width: 200
			},
			{
				type: "text"
				, name: "processId"
				, title: "شناسه فرایند"
				, defaultValue: "170012"
				, canEdit: false
				, width: 200
			}


			, {
				name: "documentCreator"


				, type: "text"


				, required: false
				, width: 200
				, colSpan: 2
				, titleColSpan: 1
				, tabIndex: 1

				, canEdit: false
				, title: "ایجاد کننده ی سند"
				, showHover: true
				, align: "right"

				, defaultValue: "najafian"


			}


			, {
				name: "documentId"


				, type: "text"


				, required: false
				, width: 200
				, colSpan: 2
				, titleColSpan: 1
				, tabIndex: 1

				, canEdit: false
				, title: "شماره سند"
				, showHover: true
				, align: "right"

				, defaultValue: "303370"


			}


			, {
				name: "salariBossStatusCheck"


				, type: "SelectItem"


				, required: true
				, width: 200
				, colSpan: 2
				, titleColSpan: 1
				, tabIndex: 1

				, canEdit: true
				, title: "آیا سند مورد تایید است؟"
				, showHover: true
				, align: "right"


				, editorType: "SelectItem"


				, valueMap: {
					"yes": "سند مورد تایید است",
					"no": "سند دارای اشکالاتی است"
				}


			}


			, {
				name: "txsalariBossRejectReason"


				, type: "textArea"


				, required: true
				, width: 200
				, colSpan: 2
				, titleColSpan: 1
				, tabIndex: 1

				, canEdit: true
				, title: "دلایل رد سند"
				, showHover: true
				, align: "right"


			}


		]
	});

	<%--<script>--%>
	isc.IButton.create
	({
		ID: "doStartTaskButton",
		icon: "[SKIN]actions/edit.png",
		title: "تایید",
		align: "center",
		width: "150",
		click: function () {

			<%--if (form1.hasErrors()) {--%>
			<%--return;--%>
			<%--}--%>
			console.log(form1.validate());
			if (form1.validate()) {
				isc.Dialog.create({
					message: "آیا اطمینان دارید؟",
					icon: "[SKIN]ask.png",
					buttons: [
						isc.Button.create({title: "بله"}),
						isc.Button.create({title: "خیر"})
					],
					buttonClick: function (button, index,) {

						if (index == 0) {
							var data = form1.getValues();
							isc.RPCManager.sendRequest({
								actionURL: "/account/rest/workflow/doUserTask/",
								httpMethod: "POST",
								useSimpleHttp: true,
								contentType: "application/json; charset=utf-8",
								showPrompt: false,
								data: JSON.stringify(data),
								params: {"taskId": "170012", "usr": "najafian"},
								serverOutputAsString: false,
								callback: function (RpcResponse_o) {
									if (RpcResponse_o.data == 'success') {
										isc.say("سند به گردش کار ارسال شد.");
										userTaskViewLoader.hide();
										ListGrid_UserTaskList.invalidateCache();
										userCartableButton.setTitle("شخصی (" + 1 + "   )");
									} else {

									}
								}
							});

						}
						this.hide();
					}
				});
			}
		}
	});

	isc.IButton.create
	({
		ID: "viewDocButton",
		icon: "[SKIN]actions/edit.png",
		title: "مشاهده ی سند",
		align: "center",
		width: "150",
		click: function () {
			var data = form1.getValues();
			console.log(data);

			createTab(" سند شماره" + data.documentId, "/account/document/addDocument?action=show&docId=" + data.documentId, false);


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

			userTaskConfirmVLayout.hide();

		}
	});

	isc.HLayout.create({
		ID: "userTakConfirmHeaderHLayout",
		width: "100%",
		height: "70%",
		align: "center",
		members: [
			form1
		]
	});


	isc.HLayout.create({
		ID: "userTaskConfirmFooterHLayout",
		width: "100%",
		align: "center",
		membersMargin: 10,
		members: [
			viewDocButton,
			doStartTaskButton,
			doCancelUserTaskButton
		]
	});

	isc.Label.create({
		ID: "userTaskDocumentLabel",
		wrap: false,
		icon: "",
		contents: "<br/> <span style='color: #ff5044; font-weight: bold; font-size: large'>${txeditExpBySalariExpert}  ${txdocumentControlBossRejectReason}</span><br/>",
		dynamicContents: true
	});
	isc.Label.create({
		ID: "userTaskTitleLabel",
		wrap: false,
		icon: "",
		contents: "<br/> <span style='color: #ff5044; font-weight: bold; font-size: large'>بررسی رئیس اداره حقوق و دسمتزد</span> <br/>",
		dynamicContents: true
	});
	isc.HLayout.create({
		ID: "userTaskConfirmDocumentHLayout",
		width: "100%",
		height: "10%",
		align: "center",
		membersMargin: 10,
		members: [
			userTaskDocumentLabel,
			userTaskTitleLabel
		]
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
			userTaskConfirmDocumentHLayout,
			userTakConfirmHeaderHLayout,
			userTaskConfirmFooterHLayout
		]
	});


