<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>


//<script>

var committee_method = "POST";

//************************************************************************************
    // RestDataSource & ListGrid
 //************************************************************************************
 	var RestDataSource_committee = isc.MyRestDataSource.create({
        ID: "CommitteeDS",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {"Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true},
         {name: "titleFa"},
			{name:"subCategory.category.titleFa"},
         {name: "subCategory.titleFa"},
         {name: "members"},
         {name: "tasks"},
         {name: "description"},
        ], dataFormat: "json",
        fetchDataURL: committeeUrl + "spec-list",
        autoFetchData: true,
    });
     var RestDataSource_category = isc.MyRestDataSource.create({
        ID: "categoryDS",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {    "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ], dataFormat: "json",
        fetchDataURL: categoryUrl + "spec-list",
        autoFetchData: true,
    });
    var RestDataSourceSubCategory = isc.MyRestDataSource.create({

        fields: [{name: "id"}, {name: "titleFa"}, {name: "code"}
        ], dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",

    });
	var ListGrid_Committee = isc.MyListGrid.create({
		  dataSource: RestDataSource_committee,
		  canAddFormulaFields: true,
		 //پ contextMenu: Menu_ListGrid_term,
          autoFetchData: true,
		doubleClick: function () {
	    },
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "titleFa", title: "نام ", align: "center", filterOperator: "contains"},
			{name: "subCategory.category.titleFa", title: "گروه", align: "center", filterOperator: "contains"},
			{name: "subCategory.titleFa", title: "زیر گروه", align: "center", filterOperator: "contains"},
			{name: "members", title: "اعضاء", align: "center", filterOperator: "contains"},
			{name: "tasks", title: "وظایف", align: "center", filterOperator: "contains"},
			{name: "description", title: "توضیحات", align: "center", filterOperator: "contains"},
		],
		 showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
		sortField: 0,
	});

	//*************************************************************************************
			//DynamicForm & Window
//*************************************************************************************
	var DynamicForm_Committee = isc.MyDynamicForm.create({
		 ID: "DynamicForm_Committee",
			fields: [{name: "id", hidden: true},
		 {
			name: "titleFa",
			title: "نام فارسی",
			type: 'text',
		   required: true, keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]", length: "250",
                width: "*", height: 27, hint: "Persian/فارسی", showHintInField: true,
                validators: [MyValidators.NotEmpty]
					},

		 {
                name: "category",
                title: "<spring:message code="course_category"/>",
                editorType: "MyComboBoxItem",
               textAlign: "center",
                autoFetchData: true,
                required: true,
                width: "*",
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_category,
                filterFields: ["titleFa"],
                sortField: ["id"],
               changed: function (form, item, value) {
					  RestDataSourceSubCategory.fetchDataURL = categoryUrl + value + "/sub-categories";
                },
            },

           {
                name: "subCategory.id",
                colSpan: 1,

                title: "<spring:message code="course_subcategory"/>",
                editorType: "MyComboBoxItem",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                required: true,
                // height: "30",
                width: "200",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSourceSubCategory,
                filterFields: ["titleFa"],
                sortField: ["id"],
                changed: function (form, item, value) {

                },
            },
            {
                name: "members",

                title: "<spring:message code="committee_members"/>",
                editorType: "MyComboBoxItem",
                //autoFetchData: true,
                required: true,
                // height: "30",
                width: "*",
                //displayField: "titleFa",
                //valueField: "titleFa",
                //optionDataSource: RestDataSourceEducation,
                //filterFields: ["titleFa"],
                sortField: ["id"],
                changed: function (form, item, value) {
                    //RestDataSourceEducation.fetchDataURL = courseUrl + "getlistEducationLicense";
                },
            },

            {
			name: "tasks",
			title: "وظایف",
			type: "textArea",
            height: "50",
		    length: "250", width: "*",

		},
		 {
			name: "description",
			title: "توضیحات",
			type: "textArea",
            colSpan: 3,
            height: "50",
		    length: "250", width: "*",

		}

		]
	});
	var Window_Committee = isc.MyWindow.create({
		title: "دوره",
		 width: 500,
		items: [DynamicForm_Committee,isc.MyHLayoutButtons.create({
            members: [isc.MyButton.create({
                title: "ذخیره",
                icon: "pieces/16/save.png",
                click: function () {
                    save_Term();

                }
            }), isc.MyButton.create({
                title: "لغو",
                icon: "pieces/16/icon_delete.png",
                click: function () {
                    Window_Committee.close();
                }
            })],
        }),]
    });



	//**********************************************************************************
                                //ToolStripButton
//**********************************************************************************
	var ToolStripButton_Refresh = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/refresh.png",
		title: "بازخوانی اطلاعات",
		click: function () {
			ListGrid_Committee.invalidateCache();
		}
	});
	var ToolStripButton_Edit = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "ویرایش",
		click: function () {

		//		 show_TermEditForm();
		}
	});
	var ToolStripButton_Add = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "ایجاد",
		click: function () {
			committee_method = "POST";
		   show_CommitteeNewForm();

		}
	});
	var ToolStripButton_Remove = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "حذف",
		click: function () {
	//		show_TermRemoveForm()
		}
	});
	var ToolStripButton_Print = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png",
		title: "چاپ",
		  click: function () {
      //    print_TermListGrid("pdf");
         }

	});
	var ToolStrip_Actions = isc.ToolStrip.create({
		width: "100%",
		members: [ToolStripButton_Refresh,ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove,ToolStripButton_Print]
	});

//***********************************************************************************
                                //HLayout
//***********************************************************************************
	var HLayout_Actions_Group = isc.HLayout.create({
		width: "100%",
		members: [ToolStrip_Actions]
	});

	var HLayout_Grid_Committee = isc.HLayout.create({
		width: "100%",
		height: "100%",
		members: [ListGrid_Committee]
	});

	var VLayout_Body_Group = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [
			HLayout_Actions_Group
			, HLayout_Grid_Committee
		]
	});


//************************************************************************************
                                 //function
//************************************************************************************

     function  show_CommitteeNewForm()
	{
        committee_method = "POST";
      	DynamicForm_Committee.clearValues();
       	Window_Committee.show();
    };