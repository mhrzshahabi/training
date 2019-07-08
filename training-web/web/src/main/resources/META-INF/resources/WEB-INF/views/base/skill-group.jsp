<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--<script>--%>

	<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

	var skillGrouprecordid = -1;
	var method = "POST";
	var url = "${restApiUrl}/api/skill-group";

	//
	// skillData=[
	//     {
	//         skill_code:"CO6A001",
	//         skill_name:"آشنایی با مفاهیم فن آوری"
	//     },
	//     {
	//         skill_code:"CO2B004",
	//         skill_name:"توانایی برنامه نویسی با زبان C"
	//     }
	// ]
	// var skillDS=isc.DataSource.create({
	//     fields:[
	//         {name:"skill_code", title:"کد مهارت"},
	//         {name:"skill_name", title:"نام مهارت"},
	//     ],
	//     clientOnly: true,
	//     testData: skillData
	// })
	//
	//
	// var SkillListGrid=isc.ListGrid.create({
	//     width:"100%", alternateRecordStyles:true,
	//     dataSource: skillDS,
	//     autoFetchData: true
	// })

	//
	// competencyData=[
	//     {
	//         competencey_name:"شایستگی برنامه سازی",
	//         competencey_type:"عملکردی"
	//     },
	//     {
	//         competencey_name:"شایستگی مدیریت",
	//         competencey_type:"توسعه ای"
	//     },
	//     {
	//         competencey_name:"شایستگی برنامه ریزی",
	//         competencey_type:"عملکردی"
	//     }
	// ]
	// var CompetenceDS=isc.DataSource.create({
	//       fields:[
	//         {name:"competencey_name", title:"نام شایستگی"},
	//         {name:"competencey_type", title:"نوع شایستگی"},
	//              ],
	//     clientOnly: true,
	//     testData: competencyData
	// })


	var RestDataSource_Skill_Group_Skills_Jsp = isc.RestDataSource.create({
		fields: [
			{name: "id"},
			{name: "titleFa"},
			{name: "titleEn"},
			{name: "description"},
			{name: "version"}
		], dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		autoFetchData: false,
		transformRequest: function (dsRequest) {
			dsRequest.httpHeaders = {
				"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
				"Access-Control-Allow-Origin": "${restApiUrl}"
			};
			return this.Super("transformRequest", arguments);
		}
		// ,fetchDataURL:"${restApiUrl}/api/skill-group/1/getSkills"
	});


	var RestDataSource_All_Skills = isc.RestDataSource.create({
		fields: [
			{name: "id"},
			{name: "code"},
			{name: "titleFa"},
			{name: "titleEn"},
			{name: "description"},
			{name: "version"}
		], dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		autoFetchData: false,
		transformRequest: function (dsRequest) {
			dsRequest.httpHeaders = {
				"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
				"Access-Control-Allow-Origin": "${restApiUrl}"
			};
			return this.Super("transformRequest", arguments);
		}
		, fetchDataURL: "${restApiUrl}/api/skill/spec-list"
	});

	var RestDataSource_ForThisSkillGroup_GetSkills = isc.RestDataSource.create({
		fields: [
			{name: "id"},
			{name: "code"},
			{name: "titleFa"},
			{name: "titleEn"},
			{name: "description"},
			{name: "version"}
		], dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		autoFetchData: false,
		transformRequest: function (dsRequest) {
			dsRequest.httpHeaders = {
				"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
				"Access-Control-Allow-Origin": "${restApiUrl}"
			};
			return this.Super("transformRequest", arguments);
		}
		//,fetchDataURL:"${restApiUrl}/api/skill-group/1/getSkills"
	});


	var DynamicForm_thisSkillGroupHeader_Jsp = isc.DynamicForm.create({
		titleWidth: "400",
		width: "700",
		align: "right",
		autoDraw: false,


		fields: [
			//     {name: "id", type: "hidden", title: ""},
			//     {
			//         name: "titleFa",
			//         type: "header",
			//         title: "افزودن مهارت به گروه مهارت:",
			//         wrapTitle: false,
			//         width: "250",
			//         align:"right"
			//      }
			//,
			{
				name: "sgTitle",
				type: "staticText",
				title: "افزودن مهارت به گروه مهارت:",
				wrapTitle: false,
				width: 250
			}
		]
	});


	var ListGrid_AllSkills = isc.ListGrid.create({
		//title:"تمام مهارت ها",
		width: "100%",
		height: "100%",
		canDragRecordsOut: true,
		canAcceptDroppedRecords: true,
		autoFetchData: true,
		dataSource: RestDataSource_All_Skills,
		fields: [
			{name: "id", title: "id", primaryKey: true, hidden: true},
			{name: "code", title: "کد مهارت", align: "center", width: "20%"},
			{name: "titleFa", title: "نام مهارت", align: "center", width: "60%"},
			{name: "titleEn", title: "نام لاتین مهارت", align: "center", hidden: true},
			{name: "description", title: "توضیحات", align: "center", hidden: true},
			{name: "version", title: "version", canEdit: false, hidden: true}
		],
		sortField: 1,
		sortDirection: "descending",
		dataPageSize: 50,
		autoFetchData: true,
		showFilterEditor: true,
		filterOnKeypress: true,
		dragTrackerMode: "title",
		canDrag: true,
		sortFieldAscendingText: "مرتب سازی صعودی ",
		sortFieldDescendingText: "مرتب سازی نزولی",
		configureSortText: "تنظیم مرتب سازی",
		autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
		autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
		filterUsingText: "فیلتر کردن",
		groupByText: "گروه بندی",
		freezeFieldText: "ثابت نگه داشتن",


		recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {

			// var activeSkill = record;
			// var activeSkillId = activeSkill.id;
			// var activeSkillGroup = ListGrid_Skill_Group_Jsp.getSelectedRecord();
			// var activeSkillGroupId = activeSkillGroup.id;

			var skillGroupRecord = ListGrid_Skill_Group_Jsp.getSelectedRecord();
			var skillGroupId = skillGroupRecord.id;
			//  alert(skillGroupId);
			// var skillId=dropRecords[0].id;
			var skillIds = new Array();
			for (i = 0; i < dropRecords.getLength(); i++) {
				skillIds.add(dropRecords[i].id);
			}
			;

			//  alert("${restApiUrl}/api/skill-group/addSkills/"+skillGroupId+"/"+skillIds);

			var JSONObj = {"ids": skillIds};
			isc.RPCManager.sendRequest({
				httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
				useSimpleHttp: true,
				contentType: "application/json; charset=utf-8",
				//${restApiUrl}/api/skill-group/addSkills/22/23%2C41
				actionURL: "${restApiUrl}/api/skill-group/removeSkills/" + skillGroupId + "/" + skillIds, //"${restApiUrl}/api/tclass/addStudents/" + ClassID,
				httpMethod: "DELETE",
				data: JSON.stringify(JSONObj),
				serverOutputAsString: false,
				callback: function (resp) {
					if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

						ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
						ListGrid_AllSkills.invalidateCache();

						// var OK = isc.Dialog.create({
						//     message: "عملیات با موفقیت انجام شد",
						//     icon: "[SKIN]say.png",
						//     title: "پیام موفقیت"
						// });
						// setTimeout(function () {
						//     // OK.close();
						// }, 3000);
					} else {
						isc.say("خطا");
					}
				}
			});
		},


		recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
			var activeSkill = record;
			var activeSkillId = activeSkill.id;
			var activeSkillGroup = ListGrid_Skill_Group_Jsp.getSelectedRecord();
			var activeSkillGroupId = activeSkillGroup.id;
			isc.RPCManager.sendRequest({
				httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
				useSimpleHttp: true,
				contentType: "application/json; charset=utf-8",
				actionURL: "${restApiUrl}/api/skill-group/addSkill/" + activeSkillId + "/" + activeSkillGroupId,
				httpMethod: "POST",
				serverOutputAsString: false,
				callback: function (resp) {
					if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

						// RestDataSource_ForThisSkillGroup_GetSkills.removeRecord(activeSkill);
						ListGrid_AllSkills.invalidateCache();
						ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
					} else {
						isc.say("<spring:message code='error'/>");
					}
				}
			});
		}


	});


	var ListGrid_ForThisSkillGroup_GetSkills = isc.ListGrid.create({
		//title:"تمام مهارت ها",
		width: "100%",
		height: "100%",
		canDragRecordsOut: true,
		canAcceptDroppedRecords: true,
		//showRowNumbers: true,
		showRecordComponents: true,
		showRecordComponentsByCell: true,
		// rowNumberFieldProperties: {
		//     autoFitWidthApproach: "both",
		//     canDragResize: true,
		//     autoFitWidth: false,
		//     headerTitle: "row",
		//     width: 50
		// },
		dataSource: RestDataSource_ForThisSkillGroup_GetSkills,
		fields: [
			{name: "id", title: "id", primaryKey: true, hidden: true},
			{name: "code", title: "کد مهارت", align: "center", width: "20%"},
			{name: "titleFa", title: "نام مهارت", align: "center", width: "70%"},
			//  {name:"titleEn", title:"نام لاتین مهارت", align:"center", hidden:true},
			// {name: "description", title: "توضیحات", align: "center",hidden:true},
			// {name: "version", title: "version", canEdit: false, hidden: true},
			{name: "OnDelete", title: "حذف", align: "center"}
		],

		//--------------------------------------------


		createRecordComponent: function (record, colNum) {
			var fieldName = this.getFieldName(colNum);

			if (fieldName == "OnDelete") {
				var recordCanvas = isc.HLayout.create({
					height: 20,
					width: "100%",
					layoutMargin: 5,
					membersMargin: 10,
					align: "center"
				});

				var removeIcon = isc.ImgButton.create({
					showDown: false,
					showRollOver: false,
					layoutAlign: "center",
					src: "pieces/16/icon_delete.png",
					prompt: "remove",
					height: 16,
					width: 16,
					grid: this,
					click: function () {
						var activeSkill = record;
						var activeSkillId = activeSkill.id;
						var activeSkillGroup = ListGrid_Skill_Group_Jsp.getSelectedRecord();
						var activeSkillGroupId = activeSkillGroup.id;
						isc.RPCManager.sendRequest({
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							actionURL: "${restApiUrl}/api/skill-group/removeSkill/" + activeSkillGroupId + "/" + activeSkillId,
							httpMethod: "DELETE",
							serverOutputAsString: false,
							callback: function (resp) {
								if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

									// RestDataSource_ForThisSkillGroup_GetSkills.removeRecord(activeSkill);
									ListGrid_AllSkills.invalidateCache();
									ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
								} else {
									isc.say("خطا در پاسخ سرویس دهنده");
								}
							}
						});
					}
				});
				recordCanvas.addMember(removeIcon);
				return recordCanvas;
			} else
				return null;
		},


		//----------------------------------------------------


		recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {

			// alert(dropRecords[0].titleFa);


			var skillGroupRecord = ListGrid_Skill_Group_Jsp.getSelectedRecord();
			var skillGroupId = skillGroupRecord.id;
			//  alert(skillGroupId);
			// var skillId=dropRecords[0].id;
			var skillIds = new Array();
			for (i = 0; i < dropRecords.getLength(); i++) {
				skillIds.add(dropRecords[i].id);
			}
			;

			//  alert("${restApiUrl}/api/skill-group/addSkills/"+skillGroupId+"/"+skillIds);

			var JSONObj = {"ids": skillIds};
			isc.RPCManager.sendRequest({
				httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
				useSimpleHttp: true,
				contentType: "application/json; charset=utf-8",
				//${restApiUrl}/api/skill-group/addSkills/22/23%2C41
				actionURL: "${restApiUrl}/api/skill-group/addSkills/" + skillGroupId + "/" + skillIds, //"${restApiUrl}/api/tclass/addStudents/" + ClassID,
				httpMethod: "POST",
				data: JSON.stringify(JSONObj),
				serverOutputAsString: false,
				callback: function (resp) {
					if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

						ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
						ListGrid_AllSkills.invalidateCache();

						// var OK = isc.Dialog.create({
						//     message: "عملیات با موفقیت انجام شد",
						//     icon: "[SKIN]say.png",
						//     title: "پیام موفقیت"
						// });
						// setTimeout(function () {
						//     // OK.close();
						// }, 3000);
					} else {
						isc.say("خطا");
					}
				}
			});
		},


		recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
			//  alert("hazf nakon baba");
			var activeSkill = record;
			var activeSkillId = activeSkill.id;
			var activeSkillGroup = ListGrid_Skill_Group_Jsp.getSelectedRecord();
			var activeSkillGroupId = activeSkillGroup.id;
			isc.RPCManager.sendRequest({
				httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
				useSimpleHttp: true,
				contentType: "application/json; charset=utf-8",
				actionURL: "${restApiUrl}/api/skill-group/removeSkill/" + activeSkillGroupId + "/" + activeSkillId,
				httpMethod: "DELETE",
				serverOutputAsString: false,
				callback: function (resp) {
					if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

						// RestDataSource_ForThisSkillGroup_GetSkills.removeRecord(activeSkill);
						ListGrid_AllSkills.invalidateCache();
						ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
					} else {
						isc.say("<spring:message code='error'/>");
					}
				}
			});
		},


		sortField: 1,
		sortDirection: "descending",
		dataPageSize: 50,
		autoFetchData: false,
		showFilterEditor: true,
		filterOnKeypress: true,
		sortFieldAscendingText: "مرتب سازی صعودی ",
		sortFieldDescendingText: "مرتب سازی نزولی",
		configureSortText: "تنظیم مرتب سازی",
		autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
		autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
		filterUsingText: "فیلتر کردن",
		groupByText: "گروه بندی",
		freezeFieldText: "ثابت نگه داشتن"


	});


	var SectionStack_All_Skills_Jsp = isc.SectionStack.create({
		visibilityMode: "multiple",
		width: "50%",
		sections: [
			{
				title: "لیست مهارت ها",
				expanded: true,
				canCollapse: false,
				align: "center",
				items: [
					ListGrid_AllSkills
				]
			}
		]
	});

	var SectionStack_Current_Skill_JspClass = isc.SectionStack.create({
		visibilityMode: "multiple",
		width: "50%",
		sections: [
			{
				title: "لیست مهارت های این گروه مهارت",
				expanded: true,
				canCollapse: false,
				align: "center",
				items: [
					ListGrid_ForThisSkillGroup_GetSkills
				]
			}
		]
	});

	var HStack_thisSkillGroup_AddSkill_Jsp = isc.HStack.create({
		membersMargin: 10,
		height: 500,
		members: [
			SectionStack_All_Skills_Jsp,
			SectionStack_Current_Skill_JspClass
		]
	});


	var HLayOut_thisSkillGroup_AddSkill_Jsp = isc.HLayout.create({
		width: 700,
		height: 30,
		border: "0px solid yellow",
		layoutMargin: 5,
		align: "center",
		onCreate: function () {
			alert("man toye hlayout hastam");

		},
		members: [
			DynamicForm_thisSkillGroupHeader_Jsp
		]
	});


	var VLayOut_SkillGroup_Skills_Jsp = isc.VLayout.create({
		width: "100%",
		height: "300",
		autoDraw: false,
		border: "3px solid red", layoutMargin: 5,
		members: [
			HLayOut_thisSkillGroup_AddSkill_Jsp,
			HStack_thisSkillGroup_AddSkill_Jsp
		]
	});

	var Window_Add_Skill_to_SkillGroup = isc.Window.create({
		title: "لیست مهارت ها",
		width: "900",
		height: "400",
		autoSize: true,
		autoCenter: true,
		isModal: true,
		showModalMask: true,
		align: "center",
		autoDraw: false,
		dismissOnEscape: true,

		closeClick: function () {


			ListGrid_Skill_Group_Competence.invalidateCache();
			ListGrid_Skill_Group_Skills.invalidateCache();
			this.hide();
		},
		items: [
			VLayOut_SkillGroup_Skills_Jsp
		]
	});


	var RestDataSource_Skill_Group_Competencies_Jsp = isc.RestDataSource.create({
		fields: [
			{name: "id"},
			{name: "titleFa"},
			{name: "titleEn"},
			{name: "description"},
			{name: "version"}
		], dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		autoFetchData: false,
		transformRequest: function (dsRequest) {
			dsRequest.httpHeaders = {
				"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
				"Access-Control-Allow-Origin": "${restApiUrl}"
			};
			return this.Super("transformRequest", arguments);
		}//,
		 //fetchDataURL:"${restApiUrl}/api/skill-group/?/getCompetences"
	});


	var ListGrid_Skill_Group_Skills = isc.ListGrid.create({
		width: "100%",
		height: "100%",

		dataSource: RestDataSource_Skill_Group_Skills_Jsp,
		// contextMenu: Menu_ListGrid_Skill_Group_Jsp,
		doubleClick: function () {
			//    ListGrid_Skill_Group_edit();
		},
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "titleFa", title: "نام مهارت", align: "center"},
			{name: "titleEn", title: "نام لاتین مهارت ", align: "center"},
			{name: "description", title: "توضیحات", align: "center"},
			{name: "version", title: "version", canEdit: false, hidden: true}
		],
		sortField: 1,
		sortDirection: "descending",
		dataPageSize: 50,
		autoFetchData: false,
		showFilterEditor: true,
		filterOnKeypress: true,
		sortFieldAscendingText: "مرتب سازی صعودی ",
		sortFieldDescendingText: "مرتب سازی نزولی",
		configureSortText: "تنظیم مرتب سازی",
		autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
		autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
		filterUsingText: "فیلتر کردن",
		groupByText: "گروه بندی",
		freezeFieldText: "ثابت نگه داشتن"
	});


	var ListGrid_Skill_Group_Competence = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		dataSource: RestDataSource_Skill_Group_Competencies_Jsp,
		// contextMenu: Menu_ListGrid_Skill_Group_Jsp,
		doubleClick: function () {
			//    ListGrid_Skill_Group_edit();
		},
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "titleFa", title: "نام شایستگی", align: "center"},
			{name: "titleEn", title: "نام لاتین شایستگی ", align: "center"},
			{name: "description", title: "توضیحات", align: "center"},
			{name: "version", title: "version", canEdit: false, hidden: true}
		],
		sortField: 1,
		sortDirection: "descending",
		dataPageSize: 50,
		autoFetchData: false,
		showFilterEditor: true,
		filterOnKeypress: true,
		sortFieldAscendingText: "مرتب سازی صعودی ",
		sortFieldDescendingText: "مرتب سازی نزولی",
		configureSortText: "تنظیم مرتب سازی",
		autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
		autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
		filterUsingText: "فیلتر کردن",
		groupByText: "گروه بندی",
		freezeFieldText: "ثابت نگه داشتن"
	});


	function ListGrid_Skill_Group_edit() {
		var record = ListGrid_Skill_Group_Jsp.getSelectedRecord();
		if (record == null || record.id == null) {

simpleDialog("تایید","گروه مهارتی انتخاب نشحده است.",0,"ask");
			// isc.Dialog.create({
			// 	message: "گروه مهارتی انتخاب نشده است.",
			// 	icon: "[SKIN]ask.png",
			// 	title: "پیغام",
			// 	buttons: [isc.Button.create({title: "تائید"})],
			// 	buttonClick: function (button, index) {
			// 		this.close();
			// 	}
			// });
		} else {
			method = "PUT";
			url = "${restApiUrl}/api/skill-group/" + record.id;
			DynamicForm_Skill_Group_Jsp.editRecord(record);
			Window_Skill_Group_Jsp.show();
		}
	};


	function ListGrid_Skill_Group_remove() {
		var record = ListGrid_Skill_Group_Jsp.getSelectedRecord();
		if (record == null) {
		//	isc.Dialog.create({

simpleDialog("تایید","گروه مهارتی انتخاب نشده است.",0,"ask");

		//	simpleDialog("تایید","گروه مهارتی انتخاب نشده است--","confirm",2000);

            //
			// 	message: "گروه مهارتی انتخاب نشده است",
			// 	icon: "[SKIN]ask.png",
			// 	title: "پیام",
			// 	buttons: [isc.Button.create({title: "تائید"})],
			// 	buttonClick: function (button, index) {
			// 		this.close();
			// 	}
			// });
		} else {
			var Dialog_Delete = isc.Dialog.create({
				message: getFormulaMessage("آیا از حذف گروه مهارت:' ", "2", "black", "c") + getFormulaMessage(record.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه مهارت:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
				icon: "[SKIN]ask.png",
				title: "تائید حذف",
				buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
					title: "خیر"
				})],
				buttonClick: function (button, index) {
					this.close();

					if (index == 0) {
						var wait = isc.Dialog.create({
							message: "در حال انجام عملیات...",
							icon: "[SKIN]say.png",
							title: "پیام"
						});
						isc.RPCManager.sendRequest({
							actionURL: "${restApiUrl}/api/skill-group/" + record.id,
							httpMethod: "DELETE",
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							showPrompt: true,
							serverOutputAsString: false,
							callback: function (resp) {
								wait.close();
								if (resp.httpResponseCode == 200) {
									ListGrid_Skill_Group_Jsp.invalidateCache();
									var OK = isc.Dialog.create({
										message: "حذف با موفقیت انجام شد",
										icon: "[SKIN]say.png",
										title: "عملیات موفق"
									});
									setTimeout(function () {
										OK.close();
									}, 3000);
								} else {
									var ERROR = isc.Dialog.create({
										message: "حذف با خطا مواجه شد",
										icon: "[SKIN]stop.png",
										title: "پیام"
									});
									setTimeout(function () {
										ERROR.close();
									}, 3000);
								}
							}
						});
					}
				}
			});
		}
	};


	function ListGrid_Skill_Group_refresh() {
		ListGrid_Skill_Group_Jsp.invalidateCache();
	};

	function ListGrid_Skill_Group_add() {
		method = "POST";
		url = "${restApiUrl}/api/skill-group";
		DynamicForm_Skill_Group_Jsp.clearValues();
		Window_Skill_Group_Jsp.show();
	};


	var DynamicForm_Skill_Group_Jsp = isc.DynamicForm.create({
		width: "750",
		height: "150",
		align: "center",
		canSubmit: true,
		showInlineErrors: true,
		showErrorText: true,
		showErrorStyle: true,
		errorOrientation: "right",
		titleAlign: "right",
		requiredMessage: "فیلد اجباری است.",
		numCols: 2,
		colWidths: [130, "*"],
		margin: 10,
		padding: 5,
		fields: [
			{name: "id", hidden: true},
			{
				name: "titleFa",
				type: "text",

				title: "نام گروه مهارت",
				//keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
				validators: [MyValidators.NotEmpty,MyValidators.NotStartWithNumber,MyValidators.NotStartWithSpecialCharacter],
				length: "500",
				width: "*",
				height: "40",
				required: true,
			},

			{
				name: "titleEn",
				type: "text",
				length: "500",
				width: "*",
				height: "40",
				title: "نام لاتین گروه مهارت ",
				//hint: "English/انگلیسی",
				keyPressFilter: "[a-z|A-Z|0-9]",
				validators: [{
					type: "isString",
					validateOnExit: true,
					stopOnError: true,
					errorMessage: "نام مجاز بین چهار تا پانصد کاراکتر است"
				}],
			},
			{
				name: "description",
				type: "text",
				length: "500",
				width: "*",
				height: "40",

				title: "توضیحات",
				//hint: "Persian/فارسی",
				keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
				validators: [{
					type: "isString",
					validateOnExit: true,
					stopOnError: true,
					errorMessage: "نام مجاز بین چهار تا پانصد کاراکتر است"
				}],
			}
		]
	});


	var IButton_Skill_Group_Exit_Jsp = isc.IButton.create({
		top: 260, title: "لغو", icon: "pieces/16/icon_delete.png", align: "center",
		click: function () {
			Window_Skill_Group_Jsp.close();
		}
	});

	var IButton_Skill_Group_Save_Jsp = isc.IButton.create({
		top: 260, title: "ذخیره", icon: "pieces/16/save.png", align: "center", click: function () {

			DynamicForm_Skill_Group_Jsp.validate();
			if (DynamicForm_Skill_Group_Jsp.hasErrors()) {
				return;
			}
			var data = DynamicForm_Skill_Group_Jsp.getValues();

			isc.RPCManager.sendRequest({
				actionURL: url,
				httpMethod: method,
				httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
				useSimpleHttp: true,
				contentType: "application/json; charset=utf-8",
				showPrompt: false,
				data: JSON.stringify(data),
				serverOutputAsString: false,
				callback: function (resp) {
					if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
						var OK = isc.Dialog.create({
							message: "عملیات با موفقیت انجام شد.",
							icon: "[SKIN]say.png",
							title: "انجام فرمان"
						});
						setTimeout(function () {
							OK.close();
						}, 3000);
						ListGrid_Skill_Group_refresh();
						Window_Skill_Group_Jsp.close();
					} else {
						var ERROR = isc.Dialog.create({
							message: ("اجرای عملیات با مشکل مواجه شده است!"),
							icon: "[SKIN]stop.png",
							title: "پیغام"
						});
						setTimeout(function () {
							ERROR.close();
						}, 3000);
					}

				}
			});
		}
	});


	var HLayOut_Skill_GroupSaveOrExit_Jsp = isc.HLayout.create({
		layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		width: "700",
		height: "10",
		alignLayout: "center",
		align: "center",
		padding: 10,
		membersMargin: 10,
		members: [IButton_Skill_Group_Save_Jsp, IButton_Skill_Group_Exit_Jsp]
	});

	var Window_Skill_Group_Jsp = isc.Window.create({
		title: " گروه مهارت ",
		width: 700,
		height: 200,
		autoSize: true,
		autoCenter: true,
		isModal: true,
		showModalMask: true,
		align: "center",
		autoDraw: false,
		dismissOnEscape: false,
		border: "1px solid gray",
		closeClick: function () {
			this.Super("closeClick", arguments);
		},
		items: [isc.VLayout.create({
			width: "100%",
			height: "100%",
			members: [DynamicForm_Skill_Group_Jsp, HLayOut_Skill_GroupSaveOrExit_Jsp]
		})]
	});


	var RestDataSource_Skill_Group_Jsp = isc.RestDataSource.create({
		fields: [
			{name: "id"},
			{name: "titleFa"},
			{name: "titleEn"},
			{name: "description"},
			{name: "version"}
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
		fetchDataURL: "${restApiUrl}/api/skill-group/spec-list"
	});


	function getFechUrl() {
		return "${restApiUrl}/api/skill-group/spec-list";

	}


	var Menu_ListGrid_Skill_Group_Jsp = isc.Menu.create({
		width: 150,
		data: [{
			title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
				ListGrid_Skill_Group_refresh();
			}
		}, {
			title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
				ListGrid_Skill_Group_add();
			}
		}, {
			title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {
				ListGrid_Skill_Group_edit();
			}
		}, {
			title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
				ListGrid_Skill_Group_remove();
			}
		}, {isSeparator: true}, {
			title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {
				"<spring:url value="/tclass/print/pdf" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}, {
			title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
				"<spring:url value="/tclass/print/excel" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}, {
			title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
				"<spring:url value="/tclass/print/html" var="printUrl"/>"
				window.open('${printUrl}');
			}
		},
			{isSeparator: true}, {
				title: "لیست مهارت ها", icon: "pieces/512/skill-standard.png", click: function () {
					var record = ListGrid_Skill_Group_Jsp.getSelectedRecord();


					if (record == null || record.id == null) {

						isc.Dialog.create({

							message: "گروه مهارتی انتخاب نشده است",
							icon: "[SKIN]ask.png",
							title: "پیام",
							buttons: [isc.Button.create({title: "تائید"})],
							buttonClick: function (button, index) {
								this.close();
							}
						});
					} else {

						// alert(record.id);
						RestDataSource_All_Skills.fetchDataURL = "${restApiUrl}/api/skill-group/" + record.id + "/unAttachSkills";
						RestDataSource_All_Skills.invalidateCache();
						RestDataSource_All_Skills.fetchData();
						ListGrid_AllSkills.invalidateCache();
						ListGrid_AllSkills.fetchData();


						RestDataSource_ForThisSkillGroup_GetSkills.fetchDataURL = "${restApiUrl}/api/skill-group/" + record.id + "/getSkills"
						RestDataSource_ForThisSkillGroup_GetSkills.invalidateCache();
						RestDataSource_ForThisSkillGroup_GetSkills.fetchData();
						ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
						ListGrid_ForThisSkillGroup_GetSkills.fetchData();
						DynamicForm_thisSkillGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
						Window_Add_Skill_to_SkillGroup.show();
					}
				}
			}
		]
	});


	<%--var RestDataSource_Skill_Group_Jsp = isc.RestDataSource.create({--%>
	<%--fields: [--%>
	<%--{name: "id"},--%>
	<%--{name: "titleFa"},--%>
	<%--{name: "titleEn"},--%>
	<%--{name: "description"},--%>
	<%--], dataFormat: "json",--%>
	<%--jsonPrefix: "",--%>
	<%--jsonSuffix: "",--%>
	<%--transformRequest: function (dsRequest) {--%>
	<%--dsRequest.httpHeaders = {--%>
	<%--"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",--%>
	<%--"Access-Control-Allow-Origin": "${restApiUrl}"--%>
	<%--};--%>
	<%--return this.Super("transformRequest", arguments);--%>
	<%--},--%>
	<%--fetchDataURL: "${restApiUrl}/api/course/spec-list"--%>
	<%--});--%>

	// alert(getFormulaMessage("salam","10","red"))

	var ListGrid_Skill_Group_Jsp = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		color: "red",
		dataSource: RestDataSource_Skill_Group_Jsp,
		contextMenu: Menu_ListGrid_Skill_Group_Jsp,
		click: function (record, state) {
			record = ListGrid_Skill_Group_Jsp.getSelectedRecord();
			if (record == null || record.id == null) {

			} else {
				// skillGrouprecordid=record.id;
				// skillGrouprecordname=recor;

				RestDataSource_Skill_Group_Competencies_Jsp.fetchDataURL = "${restApiUrl}/api/skill-group/" + record.id + "/getCompetences"
				RestDataSource_Skill_Group_Skills_Jsp.fetchDataURL = "${restApiUrl}/api/skill-group/" + record.id + "/getSkills"
				ListGrid_Skill_Group_Skills.invalidateCache();
				ListGrid_Skill_Group_Skills.fetchData();
				RestDataSource_Skill_Group_Competencies_Jsp.invalidateCache();
				RestDataSource_Skill_Group_Competencies_Jsp.fetchData();
				RestDataSource_Skill_Group_Skills_Jsp.invalidateCache();
				RestDataSource_Skill_Group_Skills_Jsp.fetchData();
				ListGrid_Skill_Group_Competence.invalidateCache();
				ListGrid_Skill_Group_Competence.fetchData();

			}

		},
		doubleClick: function () {
			ListGrid_Skill_Group_edit();
		},
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "titleFa", title: "نام گروه مهارت", align: "center"},
			{name: "titleEn", title: "نام لاتین گروه مهارت ", align: "center"},
			{name: "description", title: "توضیحات", align: "center"},
			{name: "version", title: "version", canEdit: false, hidden: true}
		],
		sortField: 1,
		sortDirection: "descending",
		dataPageSize: 50,
		autoFetchData: true,
		showFilterEditor: true,
		filterOnKeypress: true,
		sortFieldAscendingText: "مرتب سازی صعودی ",
		sortFieldDescendingText: "مرتب سازی نزولی",
		configureSortText: "تنظیم مرتب سازی",
		autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
		autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
		filterUsingText: "فیلتر کردن",
		groupByText: "گروه بندی",
		freezeFieldText: "ثابت نگه داشتن"
	});


	var ToolStripButton_Refresh_Skill_Group_Jsp = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/refresh.png",
		title: "بازخوانی اطلاعات",
		click: function () {
			ListGrid_Skill_Group_refresh();
		}
	});
	var ToolStripButton_Edit_Skill_Group_Jsp = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "ویرایش",
		click: function () {
			ListGrid_Skill_Group_edit();
		}
	});
	var ToolStripButton_Add_Skill_Group_Jsp = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "ایجاد",
		click: function () {

			ListGrid_Skill_Group_add();
		}
	});
	var ToolStripButton_Remove_Skill_Group_Jsp = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "حذف",
		click: function () {
			ListGrid_Skill_Group_remove();
		}
	});
	var ToolStripButton_Print_Skill_Group_Jsp = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png",
		title: "چاپ",
		click: function () {
			<%--"<spring:url value="/tclass/print/pdf" var="printUrl"/>"--%>
			<%--window.open('${printUrl}');--%>
		}
	});
	var ToolStripButton_Add_Skill_Group_AddSkill_Jsp = isc.ToolStripButton.create({
		icon: "pieces/512/skill-standard.png",
		title: "لیست مهارت ها",
		click: function () {
			var record = ListGrid_Skill_Group_Jsp.getSelectedRecord();
			//  alert(Window_Add_Skill_to_SkillGroup.DynamicForm[0].fields[0]);
			// alert(DynamicForm_thisSkillGroupHeader_Jsp.getItem("titleFa"));

			if (record == null || record.id == null) {

				isc.Dialog.create({

					message: "گروه مهارتی انتخاب نشده است",
					icon: "[SKIN]ask.png",
					title: "پیام",
					buttons: [isc.Button.create({title: "تائید"})],
					buttonClick: function (button, index) {
						this.close();
					}
				});

			} else {


				RestDataSource_All_Skills.fetchDataURL = "${restApiUrl}/api/skill-group/" + record.id + "/unAttachSkills";
				RestDataSource_All_Skills.invalidateCache();
				RestDataSource_All_Skills.fetchData();
				ListGrid_AllSkills.invalidateCache();
				ListGrid_AllSkills.fetchData();


				RestDataSource_ForThisSkillGroup_GetSkills.fetchDataURL = "${restApiUrl}/api/skill-group/" + record.id + "/getSkills"
				RestDataSource_ForThisSkillGroup_GetSkills.invalidateCache();
				RestDataSource_ForThisSkillGroup_GetSkills.fetchData();
				ListGrid_ForThisSkillGroup_GetSkills.invalidateCache();
				ListGrid_ForThisSkillGroup_GetSkills.fetchData();
				DynamicForm_thisSkillGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
				Window_Add_Skill_to_SkillGroup.show();


				//Window_Add_Skill_to_SkillGroup.
				Window_Add_Skill_to_SkillGroup.show();

			}
		}
	});

	var ToolStrip_Actions_Skill_Group_Jsp = isc.ToolStrip.create({
		width: "100%",
		members: [
			ToolStripButton_Add_Skill_Group_Jsp,
			ToolStripButton_Edit_Skill_Group_Jsp,
			ToolStripButton_Remove_Skill_Group_Jsp,
			ToolStripButton_Refresh_Skill_Group_Jsp
			, ToolStripButton_Print_Skill_Group_Jsp,
			ToolStripButton_Add_Skill_Group_AddSkill_Jsp]
	});


	var HLayout_Actions_Skill_Group_Jsp = isc.HLayout.create({
		width: "100%",
		members: [ToolStrip_Actions_Skill_Group_Jsp]
	});


	// var IButton_Skill_Group_Show_Skills = isc.IButton.create({
	//     top: 260, title: "لیست مهارت ها", icon: "pieces/16/icon_delete.png", align: "center",
	//     click: function () {
	//         Window_Class_JspClass.close();
	//     }
	// });


	var Detail_Tab_Skill_Group = isc.TabSet.create({
		tabBarPosition: "top",
		width: "100%",
		height: "100%",
		tabs: [
			{
				id: "TabPane_Skill_Group_Skill",
				title: "لیست مهارت ها",
				pane: ListGrid_Skill_Group_Skills

			},
			{
				id: "TabPane_Skill_Group_Competence",
				title: "لیست شایستگی ها",
				pane: ListGrid_Skill_Group_Competence
			}
		]
	});


	var HLayout_Tab_Skill_Group = isc.HLayout.create({
		width: "100%",
		height: "100%",
		<%--border: "2px solid blue",--%>
		members: [Detail_Tab_Skill_Group]
	});


	// var HLayout_Grid_Skill_Group_Title_Jsp = isc.HLayout.create({
	//     width: "100%",
	//     height: "100%",
	//     members: [ListGrid_Skill_Group_Competence]
	// });

	var HLayout_Grid_Skill_Group_Jsp = isc.HLayout.create({
		width: "100%",
		height: "100%",
		members: [ListGrid_Skill_Group_Jsp]
	});
	var VLayout_Body_Skill_Group_Jsp = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [
			HLayout_Actions_Skill_Group_Jsp
			, HLayout_Grid_Skill_Group_Jsp
			, HLayout_Tab_Skill_Group
		]

	});
