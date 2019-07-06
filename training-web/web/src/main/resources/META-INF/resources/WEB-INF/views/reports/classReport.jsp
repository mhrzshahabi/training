<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--<script>--%>

	<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

	//--------------------------------------------------------------------------------------------------------------------//
	/*Rest Data Sources*/
	//--------------------------------------------------------------------------------------------------------------------//

	var RestDataSource_Teacher_JspClassReport = isc.RestDataSource.create({
		fields: [
			{name: "id"},
			{name: "fullNameFa"},
		], dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		transformRequest: function (dsRequest) {
			dsRequest.httpHeaders = {
				"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
				"Access-Control-Allow-Origin": "${restApiUrl}"
			};
			return this.Super("transformRequest", arguments);
		},
		fetchDataURL: "${restApiUrl}/api/teacher/spec-list"
	});

	var RestDataSource_Course_JspClassReport = isc.RestDataSource.create({
		fields: [
			{name: "id"},
			{name: "code"},
			{name: "titleFa"},
		], dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		transformRequest: function (dsRequest) {
			dsRequest.httpHeaders = {
				"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
				"Access-Control-Allow-Origin": "${restApiUrl}"
			};
			return this.Super("transformRequest", arguments);
		},
		fetchDataURL: "${restApiUrl}/api/course/spec-list"
	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*DynamicForm*/
	//--------------------------------------------------------------------------------------------------------------------//

	var DynamicForm_ReportConditions_JspClassReport = isc.DynamicForm.create({
		width: "100%",
		height: "98%",
		autoDraw: false,
		padding: 20,
		border: "0px",
		showInlineErrors: true,
		showErrorStyle: true,
		errorOrientation: "right",
		overflow: "scroll",
		criteria: "or",
		fields: [
			{
				name: "course.id",
				operator: "inSet",
				type: "selectItem",
				textAlign: "center",
				title: "<spring:message code='course.title'/>",
				autoFetchData: true,
				optionDataSource: RestDataSource_Course_JspClassReport,
				valueField: "id",
				displayField: "titleFa",
				pickListProperties: {
					showFilterEditor: true
				},
				multiple: true,
				required: true,
				validators: [MyValidators.NotEmpty]
			},
			{
				name: "teacher.id",
				operator: "inSet",
				type: "selectItem",
				textAlign: "center",
				title: "<spring:message code='trainer'/>",
				autoFetchData: true,
				optionDataSource: RestDataSource_Teacher_JspClassReport,
				valueField: "id",
				displayField: "fullNameFa",
				pickListProperties: {
					showFilterEditor: true
				},
				multiple: true,
			},
			{
				name: "startDate",
				title: "<spring:message code='start.date'/>",
				ID: "startDate_jspClassReport",
				operator: "equals",
				type: 'text',
				hint: "YYYY/MM/DD",
				showHintInField: true,
				focus: function () {
					displayDatePicker('startDate_jspClassReport', this, 'ymd', '/');
				},
				icons: [{
					src: "pieces/pcal.png",
					click: function () {
						closeCalendarWindow();
						displayDatePicker('startDate_jspClassReport', this, 'ymd', '/');
					}
				}],
				validators: [{
					validateOnExit: true,
					type: "substringCount",
					substring: "/",
					operator: "==",
					count: "2",
					min: 10,
					max: 10,
					stopOnError: true,
					errorMessage: "<spring:message code='msg.correct.date'/>"
				}]
			},
			{
				name: "endDate",
				title: "<spring:message code='end.date'/>",
				ID: "endDate_jspClassReport",
				type: 'text',
				operator: "equals",
				hint: "YYYY/MM/DD",
				showHintInField: true,
				focus: function () {
					displayDatePicker('endDate_jspClassReport', this, 'ymd', '/');
				},
				icons: [{
					src: "pieces/pcal.png",
					click: function () {
						closeCalendarWindow();
						displayDatePicker('endDate_jspClassReport', this, 'ymd', '/');
					}
				}],
				validators: [{
					validateOnExit: true,
					type: "substringCount",
					substring: "/",
					operator: "==",
					count: "2",
					min: 10,
					max: 10,
					stopOnError: true,
					errorMessage: "<spring:message code='msg.correct.date'/>"
				}]
			},
			{
				name: "group",
				title: "<spring:message code='group'/>",
				operator: "equals",
				validators: [{
					type: "isInteger", validateOnExit: true, stopOnError: true,
					errorMessage: "<spring:message code='msg.number.type'/>"
				}]
			}
		]
	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*ToolStrips and Layout*/
	//--------------------------------------------------------------------------------------------------------------------//

	var IButton_Print_JspClassReport = isc.Button.create({
		title: "<spring:message code="print"/>",
		type: "ButtonItem",
		width: "150",
		colSpan: 2,
		click: function () {
			var endDate = DynamicForm_ReportConditions_JspClassReport.getValue("endDate");
			var startDate = DynamicForm_ReportConditions_JspClassReport.getValue("startDate");
			if (startDate > endDate) {
				DynamicForm_ReportConditions_JspClassReport.clearErrors(true);
				DynamicForm_ReportConditions_JspClassReport.setError("endDate", "<spring:message code='msg.date.order'/>");
				DynamicForm_ReportConditions_JspClassReport.showErrors();
				return;
			}
			DynamicForm_ReportConditions_JspClassReport.validate();
			if (DynamicForm_ReportConditions_JspClassReport.hasErrors()) {
				return;
			}
			var advancedCriteria = DynamicForm_ReportConditions_JspClassReport.getValuesAsAdvancedCriteria();
			var criteriaForm = isc.DynamicForm.create({
				method: "POST",
				action: "/classReport/print",
				target: "_Blank",
				canSubmit: true,
				fields:
					[
						{name: "CriteriaStr", type: "hidden"}
					]
			});
			criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
			criteriaForm.submitForm();
		}
	});

	var HLayOut_BaseCondition_JspClassReport = isc.HLayout.create({
		width: "100%",
		height: "20",
		layoutMargin: 5,
		membersMargin: 5,
		autoDraw: false,
		isModal: true,
		showModalMask: true,
		border: "1px solid midnightblue",
		members: [
			IButton_Print_JspClassReport
		]
	});

	var VLayOut_getRangesAndConditions_JspClassReport = isc.VLayout.create({
		width: "100%",
		height: "100%",
		showResizeBar: true,
		showEdges: true,
		members: [
			DynamicForm_ReportConditions_JspClassReport,
			HLayOut_BaseCondition_JspClassReport
		]
	});

	var HLayout_JspClassReport = isc.HLayout.create({
		membersMargin: 10, height: "100%", width: "100%",
		members: [
			VLayOut_getRangesAndConditions_JspClassReport
		]
	});


