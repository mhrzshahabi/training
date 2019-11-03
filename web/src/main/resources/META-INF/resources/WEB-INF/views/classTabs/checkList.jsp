<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>


//<script>


 var ListGrid_Class_JspClass = isc.TrLG.create({
        width: "100%",
        height: "100%",
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
        <%--createRecordComponent: function (record, colNum) {--%>
        <%--    var fieldName = this.getFieldName(colNum);--%>
        <%--    if (fieldName === "information") {--%>
        <%--        var recordCanvas = isc.HLayout.create({--%>
        <%--            height: 20,--%>
        <%--            width: "100%",--%>
        <%--            layoutMargin: 5,--%>
        <%--            membersMargin: 10,--%>
        <%--            align: "center"--%>
        <%--        });--%>
        <%--        var checkIcon = isc.ImgButton.create({--%>
        <%--        align:"left",--%>
        <%--            showDown: false,--%>
        <%--            showRollOver: false,--%>
        <%--            layoutAlign: "center",--%>
        <%--            src: "<spring:url value='info.png'/>",--%>
        <%--            height: 16,--%>
        <%--            width: 16,--%>
        <%--            grid: this,--%>
        <%--            click: function () {--%>
        <%--            // pane: isc.ViewLoader.create(--%>
        <%--            // {viewURL: "tclass/checkList-tab"}--%>
        <%--            //   )--%>
        <%--            }--%>
        <%--        });--%>
        <%--        recordCanvas.addMember(checkIcon);--%>
        <%--        return recordCanvas;--%>
        <%--    } else--%>
        <%--        return null;--%>
        <%--},--%>
         doubleClick: function () {

        },

    });


 var DynamicForm_thisCommitteeHeader_Jsp = isc.DynamicForm.create({
        titleWidth: "400",
        width: "700",
        align: "right",
        autoDraw: false,


        fields: [

            {
               // name: "sgTitle",
                type: "staticText",
              //  title: "افزودن آیتم به فرم",
                wrapTitle: false,
                width: 250
            }
        ]
    });

   var HLayOut_thisCommittee_AddUsers_Jsp = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",
        onCreate: function () {
            alert("man toye hlayout hastam");

        },
        members: [ListGrid_Class_JspClass
          //  DynamicForm_thisCommitteeHeader_Jsp
        ]
    });
 var VLayOut_User_Committee_Jsp = isc.VLayout.create({
        width: "100%",
        height: "300",
        autoDraw: false,
        border: "3px solid gray", layoutMargin: 5,
        members: [HLayOut_thisCommittee_AddUsers_Jsp,
                 ]
    });

 var Window_Add_User_TO_Committee = isc.Window.create({
        title: "تکمیل چک لیست",
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
            this.hide();
        },
        items: [
            VLayOut_User_Committee_Jsp
        ]
    });


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
                    alert("vzxcvxcvzxcv")
                }
            }
        ]
    })
