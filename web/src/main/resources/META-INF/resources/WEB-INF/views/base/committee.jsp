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
         // {name: "members"},
         {name: "tasks"},
         {name: "description"},
        ], dataFormat: "json",
        fetchDataURL: committeeUrl + "spec-list",
        autoFetchData: true,
    });
     var RestDataSource_category = isc.MyRestDataSource.create({
        ID: "category",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {    "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}
        ], dataFormat: "json",
        fetchDataURL: categoryUrl + "spec-list",
      });


    var RestDataSourceSubCategory = isc.MyRestDataSource.create({
         ID: "subcategory",
        fields: [{name: "id",primaryKey: true}, {name: "titleFa"}
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
                textAlign: "center",
                optionDataSource: RestDataSource_category,
                autoFetchData: true,
                required: true,
                width: "*",
                changeOnKeypress: true,
                filterOnKeypress: true,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                sortField: ["id"],
                changed: function (form, item, value) {
                    DynamicForm_Committee.getItem("subCategoryId").setValue();
		    	  RestDataSourceSubCategory.fetchDataURL = categoryUrl + value + "/sub-categories";
		    	  DynamicForm_Committee.getItem("subCategoryId").fetchData();
		    	  DynamicForm_Committee.getItem("subCategoryId").setDisabled(false);
                },
            },

           {
                name: "subCategoryId",
                title: "<spring:message code="course_subcategory"/>",
                editorType: "MyComboBoxItem",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                required: true,
                width: "*",
                valueField: "id",
                optionDataSource: RestDataSourceSubCategory,
                displayField: "titleFa",
                filterFields: ["titleFa"],
                sortField: ["id"],
                changed: function (form, item, value) {
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
		title: "ایجاد",
		 width: 500,
		items: [DynamicForm_Committee,isc.MyHLayoutButtons.create({
            members: [isc.MyButton.create({
                title: "ذخیره",
                icon: "pieces/16/save.png",
                click: function () {
                   save_Committee();

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

				 show_CommitteEditForm();
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
        DynamicForm_Committee.getItem("subCategoryId").setDisabled(true);
       	Window_Committee.show();
    };
     function  save_Committee() {

        if (!DynamicForm_Committee.validate()) {
            return;
        }
        var committeeData = DynamicForm_Committee.getValues();
        var committeeSaveUrl = committeeUrl;
        if (committee_method.localeCompare("PUT") == 0) {
            var committeeRecord = ListGrid_Committee.getSelectedRecord();
           committeeSaveUrl += committeeRecord.id;
        }
        isc.RPCManager.sendRequest(MyDsRequest(committeeSaveUrl, committee_method, JSON.stringify(committeeData), "callback: show_CommitteeActionResult(rpcResponse)"));

    };
     function  show_CommitteeActionResult(resp) {
        var respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
                ListGrid_Committee.invalidateCache();
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",

            });

            setTimeout(function () {
                MyOkDialog_job.close();

            }, 3000);

         Window_Committee.close();

        } else {
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });

            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);
        }
    };

      function   show_CommitteEditForm() {

        var record = ListGrid_Committee.getSelectedRecord();

        if (record == null || record.id == null)
      {


            isc.Dialog.create({
                message: "<spring:message code="msg.record.not.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                   this.close();
                }
            });
        }

            else
                {

                committee_method = "PUT";
                DynamicForm_Committee.clearValues();
                // DynamicForm_Committee.editRecord(record);
                Window_Committee.show();

                } };