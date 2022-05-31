<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>
 var  ec = isc.ValuesManager.create({});
 let educationalCalender_method = "POST";

 let selectedRecord = null;

<%---------------------------------------------------Datasources----------------------------------------------------%>
    var RestDataSource_educationalCalender = isc.TrDS.create({

        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code",title: "<spring:message code="code"/>", filterOperator: "iContains"},
            {name: "startDate",title:"<spring:message code="start.date"/>", filterOperator: "equals" },
            {name: "endDate",title:"<spring:message code="end.date"/>", filterOperator: "iContains"},
            {name: "institute.titleFa",title: "<spring:message code="institute"/>", filterOperator: "iContains"},
            {name: "calenderStatus",title:"<spring:message code="status"/>", filterOperator: "equals"}



        ],
        fetchDataURL: educationalCalenderUrl + "spec-list",
        autoFetchData: true,
    });

 var RestDataSource_Institute_educationalCalender = isc.TrDS.create({
     fields: [
         {name: "id", primaryKey: true},
         {name: "titleFa", title: "<spring:message code="institute"/>"}
     ],
     fetchDataURL: instituteUrl +"iscTupleList",
     allowAdvancedCriteria: true,
 });

//---------------------------------------------------ListGrid-----------------------------------------------------------------

Menu_ListGrid_educational_Calender = isc.Menu.create({
    data: [
        {
            title: "<spring:message code="refresh"/>",
            icon: "<spring:url value="refresh.png"/>",
            click: function () {
                Refresh_Educational_Calender();
            }
        },
        {
            title: "<spring:message code="create"/>", icon: "<spring:url value="create.png"/>", click: function () {
                show_EducationalCalenderNewForm();
            }
        },
        {
            title: "<spring:message code="edit"/>", icon: "<spring:url value="edit.png"/>", click: function () {
                show_EducationalCalender_EditForm();
            }
        },
        {
            title: "<spring:message code="remove"/>", icon: "<spring:url value="remove.png"/>", click: function () {
                show_EducationalCalenderRemoveForm();
            }
        },

    ]
});

//    ----------------------------------------------------DynamicForms----------------------------------------------------------------
 ec = isc.ValuesManager.create({});
 DynamicForm_EducationalCalender = isc.DynamicForm.create({

     height: "100%",
     align: "center",
     isGroup: true,
     canSubmit: true,
     titleWidth: 80,
     showInlineErrors: true,
     showErrorText: false,
     valuesManager: "ec",
     numCols: 4,

     fields: [

         {
             name: "titleFa",
             title: "<spring:message code="title"/>",
             required: true,
             showHintInField: true,
             hint:"تقویم شش ماهه دوم ۱۴۰۱ سرچشمه",
             validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
             // keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
         },
         {
             name: "instituteId",
             editorType: "TrComboAutoRefresh",
             title: "<spring:message code="training.place"/>:",
             colSpan: 1,
             optionDataSource: RestDataSource_Institute_educationalCalender,
             displayField: "titleFa",
             valueField: "id",
             textAlign: "center",
             filterFields: ["titleFa", "titleFa"],
             required: true,
             showHintInField: true,
             hint: "موسسه",
             pickListWidth: 500,
             textMatchStyle: "substring",
             pickListFields: [
                 {name: "titleFa", filterOperator: "iContains"},

             ],
             changed: function (form, item) {
                 form.clearValue("trainingPlaceIds");
             },
             pickListProperties: {
                 sortField: 0,
                 showFilterEditor: false
             }
         },

         {
             name: "startDate",
             title: "<spring:message code="start.date"/>",
             ID: "startDate_jspEducationalCalendar",
             hint:"۱۴۰۰/۰۱/۰۱",
             showHintInField: true,
             filterOperator: "equals",
             type: 'text',
             required: true,
             keyPressFilter: "[\u200E\u200F ]",
             icons: [{
                 src: "<spring:url value="calendar.png"/>",
                 click: function (form) {
                     closeCalendarWindow();
                     displayDatePicker('startDate_jspEducationalCalendar', this, 'ymd', '/');
                 }
             }],
             textAlign: "center",
             changed: function (form, item, value) {
                 let dateCheck;
                 // var endDate = form.getValue("endDate");
                 dateCheck = checkDate(value);
                 if (dateCheck === false) {
                     form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                 } else {
                     form.clearFieldErrors("startDate", true);
                 }
             }

         },
         {
             name: "endDate",
             title: "<spring:message code="end.date"/>",
             ID: "endDate_jspEducationalCalendar",
             filterOperator: "equals",
             showHintInField: true,
             hint:"۱۴۰۰/۰۷/۰۱",
             type: 'text',
             required: true,
             keyPressFilter: "[\u200E\u200F ]",
             icons: [{
                 src: "<spring:url value="calendar.png"/>",
                 click: function (form) {
                     closeCalendarWindow();
                     displayDatePicker('endDate_jspEducationalCalendar', this, 'ymd', '/');
                 }
             }],
             textAlign: "center",
             changed: function (form, item, value) {
                 let startDate = form.getValue("startDate");
                 let dateCheck;
                 dateCheck = checkDate(value);
                 if (dateCheck === false) {
                     form.clearFieldErrors("endDate", true);
                     form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                 } else if (value < startDate) {
                     form.addFieldErrors("endDate", "<spring:message code="msg.equal.less.start.date"/>", true);
                     createDialog("info", "<spring:message code="msg.equal.less.start.date"/>", "<spring:message code="error"/>");
                     HLayout_Buttons_EducationalCalender.setDisabled(true);
                 } else {
                     form.clearFieldErrors("endDate", true);
                     HLayout_Buttons_EducationalCalender.setDisabled(false);
                 }
             }

         },


         {
             name: "calenderStatus",
             title: "<spring:message code="status"/>",

             valueMap: {

                 "1": "در دست طراحی",
                 "2": "خاتمه طراحی",

             },

             filterOperator: "equals",
             length: 12,
             required: true,
             keyPressFilter: "[0-9]"
         },
         {
             name: "code",
             title: "<spring:message code="code"/>",
             filterOperator: "iContains",
             length: 12,
             required: false,
             keyPressFilter: "[0-9]"
         },




     ]
 });

//--------------------------------------------------ToolStrips & windows----------------------------------------------------------------
 HLayOut_EducationalCalender= isc.TrHLayout.create({
     layoutMargin: 5,
     showEdges: false,
     edgeImage: "",
     alignLayout: "center",
     align: "center",
     padding: 10,
     height: "20%",
     membersMargin: 10,
     members: [DynamicForm_EducationalCalender]
 });

 HLayout_Buttons_EducationalCalender = isc.TrHLayoutButtons.create({
     members: [
         isc.IButtonSave.create({
             title: "<spring:message code="save"/>",
             click: function () {
                 if (educationalCalender_method === "PUT") {
                     // Edit_Company();
                 } else {
                     save_EducationalCalender();
                 }
             }
         }), isc.IButtonCancel.create({
             title: "<spring:message code="cancel"/>",
             click: function () {
                 Window_EducationalCalender.close();
             }
         })
     ]
 });
 Window_EducationalCalender = isc.Window.create({
     width: "50%",
     height: "45%",
     minWidth: 900,
     title: "<spring:message code='educational.calender.create'/>",
     canDragReposition: true,
     align: "center",
     autoCenter: true,
     border: "1px solid gray",
     items: [isc.TrVLayout.create({
         height: "390",
         members: [
             HLayOut_EducationalCalender,
             HLayout_Buttons_EducationalCalender,
         ]
     })]
 });
 ListGrid_Educational_Calender = isc.TrLG.create({
     dataSource: RestDataSource_educationalCalender,
     contextMenu: Menu_ListGrid_educational_Calender,
     sortField: 1,
     autoFetchData: true,

     fields: [
         {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
         {name: "code", title: "<spring:message code="code"/>", align: "center", filterOperator: "iContains",
             filterEditorProperties: {
                 keyPressFilter: "[0-9|\-]"
             }
         },
         {name: "titleFa", title: "<spring:message code="title"/>", align: "center", filterOperator: "iContains"},
         {
             name: "institute.titleFa",
             title: "<spring:message code="institute"/>",
             canSort: false,
             align: "center",
             canFilter:true,
             filterOperator: "iContains",

         },
         {
             name: "startDate",
             title: "<spring:message code="start.date"/>",
             align: "center",
             filterOperator: "equals",

         },

         {name: "endDate",
             title: "<spring:message code="end.date"/>",
             align: "center",
             filterOperator: "equals",

         },
         {
             name: "calenderStatus",
             title: "<spring:message code='status'/>",
             align: "center",
             valueMap: {

                 "1": "در دست طراحی",
                 "2": "خاتمه طراحی",

             },
             filterEditorProperties: {
                 pickListProperties: {
                     showFilterEditor: false
                 },
             },
             filterOnKeypress: true,
         },

     ],

     rowDoubleClick: function () {
         show_EducationalCalender_EditForm();
     },
     selectionUpdated: function (record) {

         loadCalenderClasses(record);

     },
     filterEditorSubmit: function () {
         ListGrid_Educational_Calender.invalidateCache();
     },

     click: function () {
     },
     dataArrived: function (startRow, endRow) {
     }

 });

ToolStripButton_Refresh_educationalCalender = isc.ToolStripButtonRefresh.create({
    title: "<spring:message code="refresh"/>",
    click: function () {
        Refresh_Educational_Calender();
    }
});
ToolStripButton_Add_educationalCalender = isc.ToolStripButtonAdd.create({
    title: "<spring:message code="create"/>",
    click: function () {
        show_EducationalCalenderNewForm();
    }
});
ToolStripButton_Edit_educationalCalender = isc.ToolStripButtonEdit.create({

    title: "<spring:message code="edit"/>",
    click: function () {

        show_EducationalCalender_EditForm();
    }
});
ToolStripButton_Remove_educationalCalender = isc.ToolStripButtonRemove.create({

    title: "<spring:message code="remove"/>",
    click: function () {
        show_EducationalCalenderRemoveForm();
    }
});

 var TabSet_Class_EducationalCalender = isc.TabSet.create({

     ID: "tabSetClass",
     enabled: false,
     tabBarPosition: "top",
     tabs: [


         {


             ID: "classesTab",
             title: "<spring:message code="classes"/>",
             pane: isc.ViewLoader.create({
                 autoDraw: true,
                 viewURL:"tclass/calenderClasses",
                 //
                 // viewURLParams: {
                 //
                 //     recordId: ListGrid_Educational_Calender.getSelectedRecord(),
                 // }

             })
         },


     ],
     tabSelected: function (tabNum, tabPane, ID, tab, name) {
         // if (isc.Page.isLoaded())
         //     refreshSelectedTab_class(tab);
     }
 });
 let HLayout_Tab_Class_EducationalCalender = isc.HLayout.create({
     minWidth: "100%",
     width: "100%",
     height: "79%",
     members: [TabSet_Class_EducationalCalender]
 });


ToolStrip_Actions_educationalCalender = isc.ToolStrip.create({
    width: "100%",
    membersMargin: 5,
    members: [
        ToolStripButton_Add_educationalCalender,
        ToolStripButton_Edit_educationalCalender,
        ToolStripButton_Remove_educationalCalender,

        isc.ToolStrip.create({
            width: "100%",
            align: "left",
            border: '0px',
            members: [
                ToolStripButton_Refresh_educationalCalender,
            ]
        })
    ]
});

HLayout_Actions_Group_educationalCalender = isc.HLayout.create({
    width: "100%",
    members: [ToolStrip_Actions_educationalCalender]
});

HLayout_Grid_EducationalCalender = isc.TrHLayout.create({
    members: [ListGrid_Educational_Calender]
});

VLayout_Body_Group_educationalCalender = isc.TrVLayout.create({
    members:
        [
            HLayout_Actions_Group_educationalCalender,
            HLayout_Grid_EducationalCalender,
            HLayout_Tab_Class_EducationalCalender
        ]
});

VLayout_Committee_Body_All_educationalCalender = isc.TrVLayout.create({
    members: [VLayout_Body_Group_educationalCalender]
});




 //----------------------------------------------------------------Functions--------------------------------------------------------------------------


function  Refresh_Educational_Calender() {
    ListGrid_Educational_Calender.invalidateCache();
    ListGrid_Educational_Calender.filterByEditor()
}

 function show_EducationalCalenderNewForm(){
     selectedRecord = null;
     ec.clearValues();
     ec.clearErrors(true);
     // company_method = "POST";
     Window_EducationalCalender.setTitle("<spring:message code="educational.calender.create"/>");

     Window_EducationalCalender.show();

}
function  show_EducationalCalender_EditForm(){
    selectedRecord =  ListGrid_Educational_Calender.getSelectedRecord();
    if (selectedRecord == null || selectedRecord.id == null) {
        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
    } else {
        ec.clearValues();
        ec.clearErrors(true);
        educationalCalender_method = "POST";
        ec.editRecord(selectedRecord);

        Window_EducationalCalender.setTitle("<spring:message code="calender.edit"/>");
        Window_EducationalCalender.show();
    }
}
function  show_EducationalCalenderRemoveForm(){

    let record = ListGrid_Educational_Calender.getSelectedRecord();
    if (record == null || record.id == null) {
        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
    } else {
        let Dialog_Remove_Calender = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
            "<spring:message code='verify.delete'/>");
        Dialog_Remove_Calender.addProperties({
            buttonClick: function (button, index) {
                this.close();
                if (index === 0) {

                    isc.RPCManager.sendRequest(TrDSRequest(educationalCalenderUrl + record.id, "DELETE", null, function (resp){


                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            DynamicForm_EducationalCalender.clearValues();
                            Window_EducationalCalender.close();
                            ListGrid_Educational_Calender.invalidateCache();
                        } else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }));
                }
            }
        });
    }

}

function save_EducationalCalender() {
    if (!DynamicForm_EducationalCalender.validate()) {
        return;
    } else {
        let data = ec.getValues();
        if (selectedRecord!=null)
        data.id = selectedRecord.id;
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(educationalCalenderUrl, "POST", JSON.stringify(data), function (resp) {
            wait.close();

            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                DynamicForm_EducationalCalender.clearValues();
                Window_EducationalCalender.close();
                ListGrid_Educational_Calender.invalidateCache();
            } else {
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }

        }));
    }
}

function loadCalenderClasses(){
    let record =  ListGrid_Educational_Calender.getSelectedRecord();

    if (record === null) {

        TabSet_Class_EducationalCalender.disable();
        return;
    }else {

         loadPage_CalenderClasses(record.id)

    }
    TabSet_Class_EducationalCalender.enable();

}



















    // </script>