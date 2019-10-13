<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

var taskMethod="POST";
 var photoDescription = "<spring:message code='photo.size.hint'/>" + "<br/>" + "<br/>" +
        "<spring:message code='photo.dimension.hint'/>" + "<br/>" + "<br/>" +
        "<spring:message code='photo.format.hint'/>";
  //******************************
    //Menu
    //******************************
    Menu_ListGrid_task = isc.Menu.create({
        data: [
            {
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                    ListGrid_Task.invalidateCache();
                }
            }, {
                title: "ایجاد", icon: "<spring:url value="create.png"/>", click: function () {

                }
            }, {
                title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {

                }
            }, {
                title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {

                }
            }, {isSeparator: true}, {
                title: "ارسال به Pdf", icon: "<spring:url value="pdf.png"/>", click: function () {

                }
            }, {
                title: "ارسال به Excel", icon: "<spring:url value="excel.png"/>", click: function () {

                }
            }, {
                title: "ارسال به Html", icon: "<spring:url value="html.png"/>", click: function () {

                }
            }]
    });

 //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
    var RestDataSource_term = isc.TrDS.create({
        ID: "termDS",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "startDate"},
            {name: "endDate"},
        ], dataFormat: "json",
        fetchDataURL: termUrl + "spec-list",
        autoFetchData: true,
    });
    var ListGrid_Task = isc.TrLG.create({
     //   dataSource: RestDataSource_term,
        canAddFormulaFields: true,
        contextMenu: Menu_ListGrid_task,
        autoFetchData: true,
        doubleClick: function () {
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام ", align: "center", filterOperator: "contains"},
            {name: "titleEn", title: "نام لاتین", align: "center", filterOperator: "contains"},
            {name: "taskDescription", title: "شرح توضیحات", align: "center", filterOperator: "contains"},

        ],
        doubleClick: function () {
           // DynamicForm_Term.clearValues();

        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 0,
    });


 //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************
    var ToolStripButton_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {

            ListGrid_Task.invalidateCache();
        }
    });
    var ToolStripButton_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {


        }
    });
    var ToolStripButton_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {
           taskMethod= "POST";
            ListGrid_task_add();

        }
    });
    var ToolStripButton_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {

        }
    });

    var ToolStripButton_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "چاپ",
        click: function () {

        }
    });


    var ToolStrip_Actions_Task = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print]
    });

//*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************
    var DynamicForm_Task = isc.DynamicForm.create({
        ID: "DynamicForm_Task",
         valuesManager: "vm",
        fields: [{name: "id", hidden: true},
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                readonly: true,
                required: true,
                height: 35,
                requiredMessage: "در نام فارسی می توانید از عدد و حروف انگلیسی هم استفاده کنید",
                // keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]", length: "250",
                width: "*",// hint: "Persian/فارسی", showHintInField: true,
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
             {
                name: "titleFa",
                title: "نام لاتین",
                required: true,
                type: 'text',
                readonly: true,
                required: true,
                height: 35,
                requiredMessage: "در نام فارسی می توانید از عدد و حروف انگلیسی هم استفاده کنید",
                // keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]", length: "250",
                width: "*",// hint: "Persian/فارسی", showHintInField: true,
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "description",
                title: "  شرح توضیحات",
                type: "textArea",
                colSpan: 3,
                height: "50",
                length: "250", width: "*",

            }

        ]
    });

     var TabSet_BasicInfo_JspTask = isc.TabSet.create({
        tabBarPosition: "top",
        titleEditorTopOffset: 2,
        height: "100%",
        width: "75%",
        tabs: [
            {
                title: "<spring:message code='basic.information'/>", canClose: false,
                pane: DynamicForm_Task,
            }
        ]
    });

   var DynamicForm_ViewLoader_JspTask = isc.Label.create({
        height: "100%",
        width: "100%",
        align: "center",
        contents: photoDescription
    });

     var showAttachViewLoader_Task = isc.ViewLoader.create({
        autoDraw: false,
        viewURL: "",
        overflow: "scroll",
        height: "140px",
        width: "130px",
        border: "1px solid red",
        scrollbarSize: 0,
        loadingMessage: "<spring:message code='msg.photo.loading.error'/>"
    });



     var VLayOut_ViewLoader_JspTask= isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        alignLayout: "right",
        align: "right",
        padding: 10,
        membersMargin: 10,
       members: [showAttachViewLoader_Task,
            DynamicForm_ViewLoader_JspTask]
    });

         var DynamicForm_Photo_JspTask = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        titleWidth: 0,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        titleSuffix: "",
        valuesManager: "vm",
        numCols: 2,
        titleAlign: "left",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                ID: "attachPic",
                name: "attachPic",
                title: "",
                type: "file",
                titleWidth: "80",
                accept: ".png,.gif,.jpg, .jpeg",
                multiple: "",
                width: "100%",
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name === "attachPic") {
                showTempAttach();
                setTimeout(function () {
                    if (attachNameTemp === null || attachNameTemp === "") {
                        DynamicForm_Task.getField("attachPic").setValue(null);
                        showAttachViewLoader_Task.setView();
                    }
                }, 300);
            }
        }
    });


        var  VLayOut_Photo_JspTask = isc.VLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        defaultLayoutAlign: "center",
        padding: 10,
        membersMargin: 10,
        width: "95%",
        members: [VLayOut_ViewLoader_JspTask, DynamicForm_Photo_JspTask]
    });


           var TabSet_Photo_JspTask = isc.TabSet.create({
                tabBarPosition: "top",
                titleEditorTopOffset: 2,
                width: "25%",
                alignLayout: "center",
                align: "center",
                tabs: [
                    {
                        title: "<spring:message code='personality.photo'/>", canClose: false,
                        pane: VLayOut_Photo_JspTask
                    }
                ]
            });

    // var HLayOut_TaskSaveOrExit_JspTask = isc.HLayout.create({
    //     layoutMargin: 5,
    //     showEdges: false,
    //     edgeImage: "",
    //     width: "100%",
    //     alignLayout: "center",
    //     align: "center",
    //     padding: 10,
    //     membersMargin: 10,
    //     members: [IButton_Teacher_Save_JspTeacher, IButton_Teacher_Exit_JspTeacher]
    // });
    //
     var HLayOut_Temp_JspTask = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        alignLayout: "center",
        align: "center",
        padding: 10,
        height: "55%",
        membersMargin: 10,
        members: [TabSet_BasicInfo_JspTask, TabSet_Photo_JspTask]
    });


     var  Window_Task = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code='teacher'/>",
        canDragReposition: true,
        canDragResize: true,
        autoSize: true,
        align: "center",
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        autoDraw: false,
        dismissOnEscape: true,
        border: "1px solid gray",
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [
                  HLayOut_Temp_JspTask,
             //   HLayOut_TeacherSaveOrExit_JspTeacher
            ]
        })]
    });



     //***********************************************************************************
    //HLayout
    //***********************************************************************************

      var HLayout_Actions_Task = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_Task]
    });
    var HLayout_Grid_Task = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Task]
    });

     var VLayout_Body_Task = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Task,
            HLayout_Grid_Task
        ]
    });
//**************************************************************************************************
                                  //  FUNCTION
//***************************************************************************************************
 function ListGrid_task_add() {
     //   vm.clearValues();
      //  vm.clearErrors(true);
        showAttachViewLoader_Task.show();
        showAttachViewLoader_Task.setView();
        taskMethod = "POST";
   //     vm.clearValues();

      Window_Task.show();
      //  Window_Teacher_JspTeacher.bringToFront();
    };
