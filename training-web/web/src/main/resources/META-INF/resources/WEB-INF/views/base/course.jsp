<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--<script>--%>

	<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

	var courseId = "";
	var runV = "";
	var eLevelTypeV = "";
	var etechnicalTypeV = "";
	var etheoTypeV = "";
	var course_method = "";

	var course_url = "${restApiUrl}/api/course";
	var RestDataSource_category = isc.RestDataSource.create({
		ID: "categoryDS",
		fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
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
		fetchDataURL: "${restApiUrl}/api/category/spec-list",
		autoFetchData: true,
	});
	var RestDataSource_course = isc.RestDataSource.create({
		ID: "courseDS",
		fields: [{name: "id", type: "Integer", primaryKey: true},
			{name: "titleFa"},
			{name: "titleEn"},
			{name: "category.id"},
			{name: "subCategory.id"},
			{name: "categoryId", foreignKey: "categoryDS.id"},
			{name: "categoryTitleFa", includeFrom: "categoryDS.titleFa", includeVia: "categoryId"},
			{name: "subCategoryId", foreignKey: "id"},
			{name: "erunType.titleFa"},
			{name: "elevelType.titleFa"},
			{name: "etheoType.titleFa"},
			{name: "theoryDuration"},
			{name: "etechnicalType.titleFa"},
			{name: "minTeacherDegree"},
			{name: "minTeacherExpYears"},
			{name: "minTeacherEvalScore"},
			{name: "version"}
		],
		dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		transformRequest: function (dsRequest) {
			dsRequest.httpHeaders = {
				"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
				"Access-Control-Allow-Origin": "${restApiUrl}"
			};
			return this.Super("transformRequest", arguments);
		},
		fetchDataURL: "${restApiUrl}/api/course/spec-list",
	});
	var RestDataSource_eTechnicalType = isc.RestDataSource.create({
		fields: [{name: "id"}, {name: "titleFa"}
		]
		, dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		transformRequest: function (dsRequest) {
			dsRequest.httpHeaders = {
				"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
				"Access-Control-Allow-Origin": "${restApiUrl}"
			};
			return this.Super("transformRequest", arguments);
		},
		fetchDataURL: "${restApiUrl}/api/enum/eTechnicalType/spec-list"

	});
	var RestDataSource_e_level_type = isc.RestDataSource.create({
		fields: [{name: "id"}, {name: "titleFa"}
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
		fetchDataURL: "${restApiUrl}/api/enum/eLevelType"

	});
	var RestDataSource_e_run_type = isc.RestDataSource.create({
		fields: [{name: "id"}, {name: "titleFa"}
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
		fetchDataURL: "${restApiUrl}/api/enum/eRunType/spec-list"

	});
	var RestDataSourceETheoType = isc.RestDataSource.create({
		fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
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
		fetchDataURL: "${restApiUrl}/api/enum/eTheoType"

	});
	var RestDataSourceSubCategory = isc.RestDataSource.create({

		fields: [{name: "id"}, {name: "titleFa"}
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
		fetchDataURL: "${restApiUrl}/api/sub-category/spec-list"

	});
	var RestDataSource_CourseGoal = isc.RestDataSource.create({
		fields: [
			{name: "id"}, {name: "titleFa"}, {name: "titleEn"},
			{name: "code"}, {name: "description"}
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
		fetchDataURL: "${restApiUrl}/api/goal/spec-list"
	});
	var RestDataSource_GoalAll = isc.RestDataSource.create({
		fields: [
			{name: "id"}, {name: "titleFa"}, {name: "titleEn"},
			{name: "code"}, {name: "description"}
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
		fetchDataURL: "${restApiUrl}/api/goal/spec-list"
	});
	var RestDataSource_Syllabus = isc.RestDataSource.create({
		fields: [
			{name: "id"},
			{name: "titleFa"},
			{name: "titleEn"},
			{name: "edomainType.titleFa"},
			{name: "code"}
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
		fetchDataURL: "${restApiUrl}/api/syllabus/spec-list"
	});
	var RestDataSource_SkillCourse_Attached_Courses = isc.MyRestDataSource.create({
		fields: [
			{name: "id"},
			{name: "titleFa"},
			{name: "titleEn"}
		],
	});
	var Menu_ListGrid_course = isc.Menu.create({
		width: 150,
		data: [{
			title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
				ListGrid_Course_refresh();
			}
		}, {
			title: "ایجاد دوره", icon: "pieces/16/icon_add.png", click: function () {
				ListGrid_Course_add();
			}
		}, {
			title: "ویرایش دوره", icon: "pieces/16/icon_edit.png", click: function () {
				ListGrid_Course_Edit();
			}
		}, {
			title: "حذف دوره", icon: "pieces/16/icon_delete.png", click: function () {
				ListGrid_Course_remove()
			}
		}, {
			title: "تعریف هدف و سرفصل", icon: "pieces/16/goal.png", click: function () {
				openTabGoal();
			}
		}, {isSeparator: true}, {
			title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {

			}
		}, {
			title: "ارسال به Excel", icon: "icon/excel.png", click: function () {

			}
		}, {
			title: "ارسال به Html", icon: "icon/html.jpg", click: function () {

			}
		}]
	});

	var ListGrid_Course = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		dataSource: "courseDS",
		contextMenu: Menu_ListGrid_course,
		doubleClick: function () {
			// openTabGoal();
		},
		selectionChanged: function (record, state) {
			if (record == null || record.id == null) {
				return;
			}
			ListGrid_Skill_Attached_SkillCourse.invalidateCache();
			RestDataSource_SkillCourse_Attached_Courses.fetchDataURL = "${restApiUrl}/api/course/" + record.id + "/skill1"
			//  console.log(RestDataSource_SkillCourse_Attached_Courses.fetchDataURL);
			ListGrid_Skill_Attached_SkillCourse.fetchData();
			// RestDataSource_CourseGoal.fetchDataURL = "${restApiUrl}/api/course/" + record.id + "/goal";
			// RestDataSource_GoalAll.fetchDataURL = "${restApiUrl}/api/course/goal/" + record.id;
			// ListGrid_CourseGoal.fetchData();
			// ListGrid_CourseGoal.invalidateCache();
			// ListGrid_GoalAll.invalidateCache();
			// RestDataSource_Syllabus.fetchDataURL = "${restApiUrl}/api/syllabus/course/"+record.id;
			// ListGrid_CourseSyllabus.fetchData();
			// ListGrid_CourseSyllabus.invalidateCache();

			// for (i = 0; i < mainTabSet.tabs.length; i++) {
			//     if ("اهداف" == (mainTabSet.getTab(i).title).substr(0,5)) {
			//
			//         mainTabSet.getTab(i).setTitle("اهداف دوره "+record.titleFa);
			//
			//     }
			//
			// }
		},
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "code", title: "کد دوره", align: "center"},
			{name: "titleFa", title: "نام فارسی", align: "center"},
			{name: "titleEn", title: "نام لاتین", align: "center"},
			{name: "category.titleFa", title: "گروه", align: "center"},
			{name: "subCategory.titleFa", title: "زير گروه", align: "center"},
			{name: "erunType.titleFa", title: "نوع اجرا", align: "center"},
			{name: "elevelType.titleFa", title: "سطح دوره", align: "center"},
			{name: "etheoType.titleFa", title: "نوع دوره", align: "center"},
			{name: "theoryDuration", title: "طول دوره(ساعت)", align: "center"},
			{name: "etechnicalType.titleFa", title: "نوع تخصصي", align: "center"},
			{name: "minTeacherDegree", title: "حداقل مدرك استاد", align: "center"},
			{name: "minTeacherExpYears", title: "حداقل سابقه تدريس", align: "center"},
			{name: "minTeacherEvalScore", title: "حداقل نمره ارزيابي", align: "center"},
			{name: "version", title: "version", canEdit: false, hidden: true},
			{name: "goalSet", hidden: true}
		],
		canResizeFields: true,
		sortField: 0,
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
	// var ListGrid_GoalAll = isc.ListGrid.create({
	//     width: "100%",
	//     height: "100%",
	//     dataSource: RestDataSource_GoalAll,
	//     /*contextMenu: Menu_ListGrid_CourseGoal,*/
	//     doubleClick: function () {
	//         /*ListGrid_CourseGoal_Edit();*/
	//     },
	//     fields: [
	//         {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
	//         {name: "titleFa", title: "كل اهداف", align: "center"},
	//         {name: "titleEn", title: "نام لاتین هدف ", align: "center", hidden: true},
	//         {name: "version", title: "version", canEdit: false, hidden: true}
	//     ],
	//     selectionType: "multiple",
	//     recordClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
	//
	//         RestDataSource_Syllabus.fetchDataURL = "${restApiUrl}/api/goal/" + record.id + "/syllabus";
	//         ListGrid_CourseSyllabus.fetchData();
	//         ListGrid_CourseSyllabus.invalidateCache();
	//         ListGrid_CourseGoal.deselectAllRecords();
	//
	//     },
	//     sortField: 1,
	//     sortDirection: "descending",
	//     dataPageSize: 50,
	//     autoFetchData: true,
	//     showFilterEditor: true,
	//     filterOnKeypress: true,
	//     sortFieldAscendingText: "مرتب سازی صعودی ",
	//     sortFieldDescendingText: "مرتب سازی نزولی",
	//     configureSortText: "تنظیم مرتب سازی",
	//     autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
	//     autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
	//     filterUsingText: "فیلتر کردن",
	//     groupByText: "گروه بندی",
	//     freezeFieldText: "ثابت نگه داشتن"
	// });
	// var ListGrid_CourseGoal = isc.ListGrid.create({
	//     width: "100%",
	//     height: "100%",
	//     dataSource: RestDataSource_CourseGoal,
	//     doubleClick: function () {
	//         /*ListGrid_CourseGoal_Edit();*/
	//     },
	//     fields: [
	//         {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
	//         {name: "titleFa", title: "اهداف دوره انتخاب شده", align: "center"},
	//         {name: "titleEn", title: "نام لاتین هدف ", align: "center", hidden: true},
	//         {name: "version", title: "version", canEdit: false, hidden: true}
	//     ],
	//     selectionType: "multiple",
	//     recordClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue){
	//         RestDataSource_Syllabus.fetchDataURL = "${restApiUrl}/api/goal/" + record.id + "/syllabus";
	//         ListGrid_CourseSyllabus.fetchData();
	//         ListGrid_CourseSyllabus.invalidateCache();
	//         ListGrid_GoalAll.deselectAllRecords();
	//     },
	//     sortField: 1,
	//     sortDirection: "descending",
	//     dataPageSize: 50,
	//     autoFetchData: false,
	//     showFilterEditor: true,
	//     filterOnKeypress: true,
	//     sortFieldAscendingText: "مرتب سازی صعودی ",
	//     sortFieldDescendingText: "مرتب سازی نزولی",
	//     configureSortText: "تنظیم مرتب سازی",
	//     autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
	//     autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
	//     filterUsingText: "فیلتر کردن",
	//     groupByText: "گروه بندی",
	//     freezeFieldText: "ثابت نگه داشتن"
	// });
	// var ListGrid_CourseSyllabus = isc.ListGrid.create({
	//     width: "100%",
	//     height: "100%",
	//     dataSource: RestDataSource_Syllabus,
	//     // contextMenu: Menu_ListGrid_CourseSyllabus,
	//     doubleClick: function () {
	//         // ListGrid_CourseSyllabus_Edit();
	//     },
	//     fields: [
	//         {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
	//         {name: "code", title: "کد سرفصل", align: "center", hidden: true},
	//         {name: "titleFa", title: "سرفصل دوره انتخاب شده", align: "center"},
	//         {name: "titleEn", title: "نام لاتین سرفصل", align: "center", hidden: true},
	//         {name: "edomainType.titleFa", title: "حیطه", align: "center"},
	//         {name: "theoreticalDuration", title: "ساعت نظري سرفصل", align: "center"},
	//         {name: "practicalDuration", title: "ساعت عملي سرفصل", align: "center"},
	//         {name: "version", title: "version", canEdit: false, hidden: true}
	//     ],
	//     sortField: 1,
	//     selectionType: "multiple",
	//     sortDirection: "descending",
	//     dataPageSize: 50,
	//     autoFetchData: false,
	//     showFilterEditor: true,
	//     filterOnKeypress: true,
	//     sortFieldAscendingText: "مرتب سازی صعودی ",
	//     sortFieldDescendingText: "مرتب سازی نزولی",
	//     configureSortText: "تنظیم مرتب سازی",
	//     autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
	//     autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
	//     filterUsingText: "فیلتر کردن",
	//     groupByText: "گروه بندی",
	//     freezeFieldText: "ثابت نگه داشتن"
	// });

	var ToolStripButton_Refresh = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/refresh.png",
		title: "بازخوانی اطلاعات دوره",
		click: function () {
			ListGrid_Course_refresh();
		}
	});
	var ToolStripButton_Edit = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "ویرایش دوره",
		click: function () {
			ListGrid_Course_Edit()
		}
	});
	var ToolStripButton_Add = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "ایجاد دوره",
		click: function () {
			ListGrid_Course_add();
		}
	});
	var ToolStripButton_OpenTabGoal = isc.ToolStripButton.create({
		icon: "pieces/16/goal.png",
		title: "تعریف هدف و سرفصل",
		click: function () {
			openTabGoal();
		}
	});
	var ToolStripButton_Remove = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "حذف دوره",
		click: function () {
			ListGrid_Course_remove()
		}
	});
	var ToolStripButton_Print = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png", title: "چاپ"
	});
	var ToolStripButton_Add_Vertical = isc.ToolStripButton.create({
		icon: "pieces/512/left-arrow.png",
		title: "",
		prompt: "افزودن اهداف انتخاب شده به اهداف دوره مذکور",
		click: function () {
			var vsRecord = ListGrid_Course.getSelectedRecord();
			if (vsRecord == null || vsRecord.id == null) {
				isc.Dialog.create({
					message: "دوره اي انتخاب نشده است.",
					icon: "[SKIN]ask.png",
					title: "پیغام",
					buttons: [isc.Button.create({title: "تائید"})],
					buttonClick: function (button, index) {
						this.close();
					}
				});
			} else {
				var goalRecord = ListGrid_GoalAll.getSelectedRecords();
				if (goalRecord.length == 0) {
					isc.Dialog.create({
						message: "هدفي انتخاب نشده است.",
						icon: "[SKIN]ask.png",
						title: "پیغام",
						buttons: [isc.Button.create({title: "تائید"})],
						buttonClick: function (button, index) {
							this.close();
						}
					});
				} else {
					var goalList = new Array();
					for (var i = 0; i < goalRecord.length; i++) {
						goalList.add(goalRecord[i].id);

					}
					isc.RPCManager.sendRequest({
						actionURL: "${restApiUrl}/api/course/" + vsRecord.id + "/" + goalList.toString(),
						httpMethod: "GET",
						httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
						useSimpleHttp: true,
						contentType: "application/json; charset=utf-8",
						showPrompt: false,
						// data: JSON.stringify(vsRecord,goalRecord),
						serverOutputAsString: false,
						callback: function (resp) {
							if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
								/*var OK = isc.Dialog.create({
									message: "عملیات با موفقیت انجام شد.",
									icon: "[SKIN]say.png",
									title: "انجام فرمان"
								});
								setTimeout(function () {
									OK.close();
								}, 3000);*/
								ListGrid_Course.selectRecord(vsRecord);
								ListGrid_GoalAll.invalidateCache();
								ListGrid_CourseGoal.invalidateCache();
								RestDataSource_Syllabus.fetchDataURL = "${restApiUrl}/api/syllabus/course/" + courseId.id;
								ListGrid_CourseSyllabus.invalidateCache();


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
			}
		}
	});
	var ToolStripButton_Remove_Vertical = isc.ToolStripButton.create({
		icon: "pieces/512/right-arrow.png",
		title: "",
		prompt: "حذف اهداف انتخاب شده از دوره مذکور",
		click: function () {
			var vsrRecord = ListGrid_Course.getSelectedRecord();
			if (vsrRecord == null || vsrRecord.id == null) {
				isc.Dialog.create({
					message: "دوره اي انتخاب نشده است.",
					icon: "[SKIN]ask.png",
					title: "پیغام",
					buttons: [isc.Button.create({title: "تائید"})],
					buttonClick: function (button, index) {
						this.close();
					}
				});
			} else {
				var goalrRecord = ListGrid_CourseGoal.getSelectedRecords();
				if (goalrRecord.length == 0) {
					isc.Dialog.create({
						message: "هدفي انتخاب نشده است.",
						icon: "[SKIN]ask.png",
						title: "پیغام",
						buttons: [isc.Button.create({title: "تائید"})],
						buttonClick: function (button, index) {
							this.close();
						}
					});
				} else {
					var arryRecord = new Array();
					for (var i = 0; i < goalrRecord.length; i++) {
						arryRecord.add(goalrRecord[i].id)

					}
					isc.RPCManager.sendRequest({

						actionURL: "${restApiUrl}/api/course/remove/" + vsrRecord.id + "/" + arryRecord.toString(),
						httpMethod: "GET",
						httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
						useSimpleHttp: true,
						contentType: "application/json; charset=utf-8",
						showPrompt: false,
						// data: JSON.stringify(vsRecord,goalRecord),
						serverOutputAsString: false,
						callback: function (resp) {
							if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
								/*var OK = isc.Dialog.create({
									message: "عملیات با موفقیت انجام شد.",
									icon: "[SKIN]say.png",
									title: "انجام فرمان"
								});
								setTimeout(function () {
									OK.close();
								}, 3000);*/
								ListGrid_Course.selectRecord(vsrRecord);
								ListGrid_GoalAll.invalidateCache();
								ListGrid_CourseGoal.invalidateCache();
								RestDataSource_Syllabus.fetchDataURL = "${restApiUrl}/api/syllabus/course/" + courseId.id;
								ListGrid_CourseSyllabus.invalidateCache();
								// ListGrid_Goal.invalidateCache();

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
			}
		}
	});

	var ToolStrip_Actions = isc.ToolStrip.create({
		width: "100%",
		members: [ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_OpenTabGoal, ToolStripButton_Refresh, ToolStripButton_Print]
	});
	// var ToolStrip_Vertical_Goals = isc.ToolStrip.create({
	//     width: "100%",
	//     height: "100%",
	//     align: "center",
	//     vertical: "center",
	//     members: [ToolStripButton_Add_Vertical, ToolStripButton_Remove_Vertical]
	// });

	var DynamicForm_course = isc.DynamicForm.create({
		width: "100%",
		margin: 10,
		cellPadding: 3,
		align: "center",
		titleAlign: "center",
		height: "100%",
		setMethod: "GET",
		canSubmit: true,
		showInlineErrors: true,
		numCols: "6",
		showErrorText: true,
		showErrorStyle: true,
		errorOrientation: "right",
		requiredMessage: "فیلد اجباری است.",
		wrapItemTitles: false,
		fields: [
			{name: "id", hidden: true},
			{
				colSpan: 2,
				name: "titleFa",
				title: "نام فارسی",
				keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
				required: true,
				type: 'text',
				length: "200",
				width: "280",
			},
			{
				name: "titleEn",
				title: "نام لاتین ",
				colSpan: 2,
				type: 'text',
				keyPressFilter: "[a-z|A-Z]",
				colspan: 3,
				width: "245",

			},
			{
				name: "code",
				title: "كد دوره",
				type: "staticText",
				length: "100",
				width: "*",


			},
			{
				name: "category.id",
				// dataPath: "categoryId",
				title: "گروه",
				autoFetchData: true,
				required: true,
				width: "*",
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSource_category,
				addUnknownValues: false,
				cachePickListResults: false,
				useClientFiltering: false,
				filterFields: ["titleFa"],
				sortField: ["id"],
				textMatchStyle: "startsWith",
				generateExactMatchCriteria: true,
				pickListProperties: {showFilterEditor: true},
				pickListFields: [
					{name: "titleFa", width: "30%", filterOperator: "iContains"}],
				changed: function (form, item, value) {
					DynamicForm_course.getItem("subCategory.id").setDisabled(false);
					RestDataSourceSubCategory.fetchDataURL = "${restApiUrl}/api/category/" + value + "/sub-categories";
					DynamicForm_course.getItem("subCategory.id").fetchData();
					DynamicForm_course.getItem("subCategory.id").setValue("");
				},
			},
			{
				// disabled:(b),
				name: "subCategory.id",
				title: "زير گروه",
				prompt: "ابتدا گروه را انتخاب کنید",
				textAlign: "center",
				required: true,
				width: "*",
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSourceSubCategory,
				autoFetchData: true,
				addUnknownValues: false,
				cachePickListResults: false,
				useClientFiltering: false,
				filterFields: ["titleFa"],
				sortField: ["id"],
				textMatchStyle: "startsWith",
				generateExactMatchCriteria: true,
				pickListProperties: {
					showFilterEditor: true
				},
				pickListFields: [
					{name: "titleFa", width: "30%", filterOperator: "iContains"}],

				changed: function (form, item, value) {
				},
			},
			{
				name: "erunType.id",
				value: "erunTypeId",
				title: "نوع اجرا",
				textAlign: "center",
				required: true,
				width: "*",
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSource_e_run_type,
				autoFetchData: false,
				addUnknownValues: false,
				cachePickListResults: false,
				useClientFiltering: false,
				filterFields: ["titleFa"],
				sortField: ["id"],
				textMatchStyle: "startsWith",
				generateExactMatchCriteria: true,
				pickListProperties: {
					showFilterEditor: true,
				},
				pickListFields: [
					{name: "titleFa", width: "30%", filterOperator: "iContains"}],

				changed: function (form, item, value) {
					switch (value) {
						case 1:
							runV = "C";
							break;
						case 2:
							runV = "D";
							break;
						case 3:
							runV = "S";
							break;
						case 4:
							runV = "H";
							break;
						case 5:
							runV = "J";
							break;
					}

				}
			},
			{
				name: "elevelType.id",
				value: "eLevelTypeId",
				title: "سطح دوره",
				textAlign: "center",
				required: true,
				width: "*",
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSource_e_level_type,
				autoFetchData: false,
				addUnknownValues: false,
				cachePickListResults: false,
				useClientFiltering: false,
				filterFields: ["titleFa"],
				sortField: ["id"],
				textMatchStyle: "startsWith",
				generateExactMatchCriteria: true,
				pickListProperties: {
					showFilterEditor: true,
				},
				pickListFields: [
					{name: "titleFa", width: "30%", filterOperator: "iContains"}],
				changed: function (form, item, value) {
					switch (value) {
						case 1:
							eLevelTypeV = "1";
							break;
						case 2:
							eLevelTypeV = "2";
							break;
						case 3:
							eLevelTypeV = "3";
							break;
					}

				},
			},
			{
				name: "etheoType.id",
				value: "etheoTypeId",
				title: "نوع دوره",
				textAlign: "center",
				required: true,
				width: "*",
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSourceETheoType,
				autoFetchData: false,
				addUnknownValues: false,
				cachePickListResults: false,
				useClientFiltering: false,
				filterFields: ["titleFa"],
				sortField: ["id"],
				textMatchStyle: "startsWith",
				generateExactMatchCriteria: true,
				pickListProperties: {
					showFilterEditor: true,
				},
				pickListFields: [
					{name: "titleFa", width: "30%", filterOperator: "iContains"}],
				changed: function (form, item, value) {
					switch (value) {
						case 1:
							etheoTypeV = "T";
							break;
						case 2:
							etheoTypeV = "P";
							break;
						case 3:
							etheoTypeV = "M";
							break;
					}

				},

			},
			{
				name: "etechnicalType.id",
				value: "etechnicalTypeId",
				title: "نوع تخصصي",
				textAlign: "center",
				required: true,
				width: "*",
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSource_eTechnicalType,
				autoFetchData: false,
				addUnknownValues: false,
				cachePickListResults: false,
				useClientFiltering: false,
				filterFields: ["titleFa"],
				sortField: ["id"],
				textMatchStyle: "startsWith",
				generateExactMatchCriteria: true,
				pickListProperties: {
					showFilterEditor: true,
				},
				pickListFields: [
					{name: "titleFa", width: "30%", filterOperator: "iContains"}],
				changed: function (form, item, value) {

					switch (value) {
						case 1:
							etechnicalTypeV = "4";
							break;
						case 2:
							etechnicalTypeV = "1";
							break;
						case 3:
							etechnicalTypeV = "3";
							break;
					}

				},

			},
			{
				name: "theoryDuration",
				title: "طول دوره",
				required: true,
				type: 'text',
				width: "*",
				length: 3,
				keyPressFilter: "[0-9]"
			},
			{
				name: "minTeacherDegree",
				title: "حداقل مدرك مدرس",
				keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
				required: true,
				type: 'text',
				width: "*",
			},
			{
				name: "minTeacherExpYears",
				title: "حداقل سابقه تدريس مدرس",
				type: 'text',
				width: "*",
				length: 2,
				required: true,
				keyPressFilter: "[0-9]",
				validators: [
					{
						type: "integerRange", min: 0, max: 30,
						errorMessage: "لطفا سابقه تدریس را صحیح وارد کنید",
					}
				]
			},
			{
				name: "minTeacherEvalScore",
				title: "حداقل نمره ارزيابي مدرس",
				required: true,
				type: 'text',
				width: "*",
				length: 2,
				keyPressFilter: "[0-9]",
				validators: [
					{
						type: "integerRange", min: 0, max: 20,
						errorMessage: "لطفا نمره را صحیح وارد کنید",
					}
				]
			},
			{
				name: "description",
				type: "textArea",
				colSpan: 6,
				height: 40,
				title: "توضيحات",
				width: "650",

			},
			{
				name: "mainObjective",
				title: "هدف كلي",
				colSpan: "6",
				readonly: true,
				type: "textArea",
				height: 60,
				width: "650",

			},
			// {name: "goalIdList", hidden: true}

		]
	});
	var IButton_course_Save = isc.IButton.create({
		top: 260, title: "ذخیره", icon: "pieces/16/save.png", click: function () {
			DynamicForm_course.validate();
			DynamicForm_course.getItem('code').setValue(runV + eLevelTypeV + etheoTypeV);
			if (DynamicForm_course.hasErrors()) {
				return;
			}
			var data = DynamicForm_course.getValues();
			isc.RPCManager.sendRequest({
				actionURL: course_url,
				httpMethod: course_method,
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
						Window_course.close();
						ListGrid_Course_refresh();
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
	var courseSaveOrExitHlayout = isc.HLayout.create({
		layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		width: "100%",
		alignLayout: "center",
		padding: 10,
		membersMargin: 10,
		members: [IButton_course_Save, isc.IButton.create({
			ID: "EditExitIButton",
			title: "لغو",
			prompt: "",
			width: 100,
			icon: "pieces/16/icon_delete.png",
			orientation: "vertical",
			click: function () {
				Window_course.close();
			}
		})]
	});
	var Window_course = isc.Window.create({
		title: "ایجاد دوره",
		width: "700",
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
			members: [DynamicForm_course, courseSaveOrExitHlayout]
		})]
	});
	var HLayout_Actions_Course = isc.HLayout.create({
		width: "100%",
		height: "5%",
		members: [ToolStrip_Actions]
	});
	var HLayout_Grid_Course = isc.HLayout.create({
		width: "100%",
		height: "50%",
		showResizeBar: true,
		members: [ListGrid_Course]
	});

	//----------------------------------
	// var VLayout_Grid_GoalAll = isc.VLayout.create({
	//     width: "20%",
	//     height: "100%",
	//     members: [ListGrid_GoalAll]
	// });
	// var VLayout_Actions_Goals = isc.VLayout.create({
	//     width: "20",
	//     height: "100%",
	//     members: [ToolStrip_Vertical_Goals]
	// });
	// var VLayout_Grid_Goal = isc.VLayout.create({
	//     width: "20%",
	//     height: "100%",
	//     members: [ListGrid_CourseGoal]
	// });
	// -----------------------------------------------
	//  var VLayout_Grid_Syllabus = isc.VLayout.create({
	//      width: "40%",
	//      height: "100%", members: [ListGrid_CourseSyllabus]
	//  });

	// var HLayout_Grid_Goals = isc.HLayout.create({
	//     width: "100%",
	//     height: "50%",
	//     members: [VLayout_Grid_GoalAll, VLayout_Actions_Goals, VLayout_Grid_Goal]
	// });
	var ListGrid_Skill_Attached_SkillCourse = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		dataSource: RestDataSource_SkillCourse_Attached_Courses,
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "titleFa", title: "نام فارسی", align: "center"},
			{name: "titleEn", title: "نام لاتین ", align: "center"}
		],
		selectionType: "multiple",
		sortField: 1,
		dataPageSize: 50,
		autoFetchData: false,
		showFilterEditor: true,
		filterOnKeypress: true,
	});


	var Detail_Tab_Course = isc.TabSet.create({
		tabBarPosition: "top",
		width: "100%",
		height: "100%",
		tabs: [
			{
				id: "TabPane_Skill_SkillGroup",
				title: "مهارت",
				pane: ListGrid_Skill_Attached_SkillCourse

			},

		]
	});


	var VLayout_Tab_Course = isc.VLayout.create({
		width: "100%",
		height: "50%",
		<%--border: "2px solid blue",--%>
		members: [Detail_Tab_Course]
	});

	var VLayout_Body_Course = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [HLayout_Actions_Course, HLayout_Grid_Course, VLayout_Tab_Course]
	});

	function ListGrid_Course_refresh() {
		ListGrid_Course.invalidateCache();
	};

	function ListGrid_Course_add() {
		course_method = "POST";
		course_url = "${restApiUrl}/api/course";
		DynamicForm_course.clearValues();
		DynamicForm_course.getItem("subCategory.id").setDisabled(true);
		Window_course.show();
	};

	function ListGrid_Course_remove() {


		var record = ListGrid_Course.getSelectedRecord();
		console.log(record);
		if (record == null) {
			isc.Dialog.create({
				message: "ركوردي انتخاب نشده!",
				icon: "[SKIN]ask.png",
				title: "توجه",
				buttons: [isc.Button.create({title: "تاييد"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			var Dialog_Delete = isc.Dialog.create({
				message: "آيا مي خواهيد اين ركورد حذف گردد؟",
				icon: "[SKIN]ask.png",
				title: "هشدار",
				buttons: [isc.Button.create({title: "بله"}), isc.Button.create({
					title: "خير"
				})],
				buttonClick: function (button, index) {
					this.close();

					if (index == 0) {
						<%--var wait = isc.Dialog.create({--%>
						<%--message: "<spring:message code='global.form.do.operation'/>",--%>
						<%--icon: "[SKIN]say.png",--%>
						<%--title: "<spring:message code='global.message'/>"--%>
						<%--});--%>
						isc.RPCManager.sendRequest({
							actionURL: "${restApiUrl}/api/course/" + record.id,
							httpMethod: "DELETE",
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							showPrompt: true,
							serverOutputAsString: false,
							callback: function (resp) {
								<%-- wait.close();--%>
								if (resp.httpResponseCode == 200) {
									ListGrid_Course.invalidateCache();
									var OK = isc.Dialog.create({
										message: "ركورد با موفقيت حذف گرديد",
										icon: "[SKIN]say.png",
										title: "انجام شد"
									});
									setTimeout(function () {
										OK.close();
									}, 3000);
								} else {
									var ERROR = isc.Dialog.create({
										message: "ركورد مورد نظر قابل حذف نيست",
										icon: "[SKIN]stop.png",
										title: "خطا"
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

	function ListGrid_Course_Edit() {

		var sRecord = ListGrid_Course.getSelectedRecord();

		if (sRecord == null || sRecord.id == null) {
			isc.Dialog.create({
				message: "دوره اي انتخاب نشده است.",
				icon: "[SKIN]ask.png",
				title: "پیغام",
				buttons: [isc.Button.create({title: "تائید"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			course_method = "PUT";
			course_url = "${restApiUrl}/api/course/" + sRecord.id;
			DynamicForm_course.clearValues();
			DynamicForm_course.getItem("subCategory.id").setDisabled(false);
			RestDataSourceSubCategory.fetchDataURL = "${restApiUrl}/api/category/" + sRecord.category.id + "/sub-categories"
			DynamicForm_course.getItem("subCategory.id").fetchData();
			DynamicForm_course.editRecord(sRecord);
			Window_course.show();
		}
	};
	// function openTabGoal() {
	//     courseId = ListGrid_Course.getSelectedRecord();
	//     if (courseId == null) {
	//         isc.Dialog.create({
	//             message: "دوره ای انتخاب نشده!",
	//             icon: "[SKIN]ask.png",
	//             title: "توجه",
	//             buttons: [isc.Button.create({title: "تاييد"})],
	//             buttonClick: function (button, index) {
	//                 this.close();
	//             }
	//         });
	//         }
	//     else {
	//         createTab("اهداف دوره "+courseId.titleFa, "/goal/show-form?courseId="+courseId.id, false);
	//         }
	// };
