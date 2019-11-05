<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>


//<script>





    var ToolStripButton_Category_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {

        }
    });
    var ToolStripButton_Category_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {

        }
    });
    var ToolStripButton_Category_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {

        }
    });
    var ToolStripButton_Category_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {

        }
    });
//---------------------------------------------------------------------------
  var ToolStripButton_CheckListItem_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {

        }
    });
    var ToolStripButton_CheckListItem_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {

        }
    });
    var ToolStripButton_CheckListItem_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {

        }
    });
    var ToolStripButton_CheckListItem_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {

        }
    });


//============================================================================


       var ToolStrip_Actions_CheckList = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Category_Refresh, ToolStripButton_Category_Add, ToolStripButton_Category_Edit, ToolStripButton_Category_Remove]
    });

     var ToolStrip_Actions_CheckListItem = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_CheckListItem_Refresh, ToolStripButton_CheckListItem_Add, ToolStripButton_CheckListItem_Edit, ToolStripButton_CheckListItem_Remove]
    });



    HLayout_Action_CheckListItem=isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_CheckListItem]
    });


        var HLayout_Action_CheckList = isc.HLayout.create({
        width: "100%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_CheckList]
    });


    //=================================================================

    <%--     var VLayout_Body_CheckListItem = isc.VLayout.create({--%>
    <%--    width: "*",--%>
    <%--    height: "*",--%>
    <%--    &lt;%&ndash;border: "2px solid blue",&ndash;%&gt;--%>
    <%--    members: [HLayout_Action_CheckListItem]--%>
    <%--});--%>

      var VLayout_Body_CheckListItem = isc.SectionStack.create({
       // visibilityMode: "multiple",
        width: "*",
        height:"*",
        sections: [
            {
                title: "افزودن آیتم به فرم",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                   HLayout_Action_CheckListItem
                ]
            }
        ]
    });
    <%--  var VLayout_Body_CheckList = isc.VLayout.create({--%>
    <%--   //groupTitle:"افزودن فرم",--%>
    <%--    isGroup:true,--%>
    <%--    width: "*",--%>
    <%--    height: "*",--%>
    <%--    &lt;%&ndash;border: "2px solid blue",&ndash;%&gt;--%>
    <%--    members: [HLayout_Action_CheckList]--%>
    <%--});--%>
     var VLayout_Body_CheckList = isc.SectionStack.create({
       // visibilityMode: "multiple",
        width: "*",
        height:"*",
        sections: [
            {
                title: "افزودن فرم",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                   HLayout_Action_CheckList
                ]
            }
        ]
    });

  //=================================================================
       var HLayout_Body= isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [VLayout_Body_CheckList,VLayout_Body_CheckListItem]
    });

         var Window_CheckList_Design = isc.Window.create({
                        title: "طراحی چک لیست",
                        width: 1000,
                        height:1000,
                        autoSize: true,
                        autoCenter: true,
                        isModal: true,
                        showModalMask: true,
                        align: "center",
                        autoDraw: false,
                        dismissOnEscape: true,
                        closeClick: function () {
                            this.hide();
                        },
                        items: [HLayout_Body, isc.MyHLayoutButtons.create({
            members: [isc.Button.create({
                title: "ذخیره",
                   click: function () {
                }

            }), isc.Button.create({
                title: "لغو",
                   click: function () {
                   Window_CheckList_Design.close();
                }
            })],
        }),
                        ]
                    });

  //==================================================================
     var Window_CheckList_Design = isc.Window.create({
                        title: "طراحی چک لیست",
                        width: 1000,
                        height:1000,
                        autoSize: true,
                        autoCenter: true,
                        isModal: true,
                        showModalMask: true,
                        align: "center",
                        autoDraw: false,
                        dismissOnEscape: true,

                        closeClick: function () {
                            this.hide();
                        },
                        items: [HLayout_Body, isc.MyHLayoutButtons.create({
            members: [isc.Button.create({
                title: "ذخیره",
                   click: function () {
                }

            }), isc.Button.create({
                title: "لغو",
                   click: function () {
                   Window_CheckList_Design.close();
                }
            })],
        }),
                        ]
                    });

//================================= تکمیل چک لیست===============================================تکمیل چک لیست=========================================تکمیل چک لیست======================================تکمیل چک لیست=====================
 var ListGrid_Class_JspClass = isc.TrLG.create({
        width: "*",
       height: "200",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        alternateRecordStyles:true,
        canEdit:true,
        editEvent:"click",
        modalEditing:true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
    dataSource: RestDataSource_Class_JspClass,
        contextMenu: Menu_ListGrid_Class_JspClass,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='class.code'/>", align: "center", filterOperator: "equals"},
            {name:"member_g8", title:"G8",  type: "boolean"},
            {name:"government", title:"Government",
            length: 500
        }
       ],

        dataArrived: function () {

        },
           doubleClick: function () {

        },

    });



   var HLayOut_thisCommittee_AddUsers_Jsp = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
       // layoutMargin: 2,
        align: "center",
        onCreate: function () {


        },
        members: [ListGrid_Class_JspClass

        ]
    });
 var VLayOut_User_Committee_Jsp = isc.VLayout.create({
        width: "*",
       // height: "350",
        autoDraw: false,
        border: "3px solid gray", layoutMargin: 5,
        members: [HLayOut_thisCommittee_AddUsers_Jsp,isc.MyHLayoutButtons.create({
            members: [isc.Button.create({
                title: "ذخیره",
                click: function () {


                }

            }), isc.Button.create({
                title: "لغو",
             //   icon: "<spring:url value="remove.png"/>",
                click: function () {
                    Window_term.close();
                }
            })],
        }),
                 ]
    });

 var Window_Add_User_TO_Committee = isc.Window.create({
        title: "تکمیل چک لیست",
        width: 500,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,

        closeClick: function () {
            this.hide();
        },
        items: [
            VLayOut_User_Committee_Jsp
        ]
    });

//==================================   تب چک لیست  =====================================
    isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        isGroup: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        numCols: 8,
        items: [

            {
                name: "categoryId",
                title: "انتخاب فرم مورد نظر",
                textAlign: "center",

                width: 200,
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                changed: function (form, item, value) {

                },
            },
            {
                type: "button",
                title: "تکمیل چک لیست",
                width: 150,
                showTitle: false,
                startRow: false,
                click: function () {
                   Window_Add_User_TO_Committee.show();
                }
            },
            isc.LayoutSpacer.create({
                width: "*"
            }),
            {
                type: "button",
                title: "طراحی چک لیست",
                width: 150,
                showTitle: false,
                startRow: false,
                click: function () {
                Window_CheckList_Design.show();
                }
            }
        ]
    })
