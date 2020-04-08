<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>

    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
 var RestDataSource_Course_CurrentTerm = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
            {name: "titleClass"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "code"},
            {name: "term.titleFa"},
            {name: "course.titleFa"},
            {name: "course.id"},
            {name: "teacherId"},
            {name: "teacher"},
            {name: "reason"},
            {name: "classStatus"},
            {name: "topology"},
            {name: "trainingPlaceIds"},
            {name: "instituteId"},
            {name: "workflowEndingStatusCode"},
            {name: "workflowEndingStatus"},
            {name: "preCourseTest", type: "boolean"}
        ],
        fetchDataURL: calenderCurrentTerm + "spec-list"
    });

     var RestDataSource_Class_CurrentTerm = isc.TrDS.create({
        fields: [
            {name: "corseCode"},
            {name: "titleClass"},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "hduration"},
            {name: "classStatus"},


        ],
     });



    //******************************
    //Menu
    //******************************
    Menu_ListGrid_CurrentTerm = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                  //  ListGrid_Term.invalidateCache();
                }
            }]
    });


    var ListGrid_Course_CalculatorCurrentTerm = isc.TrLG.create({
        dataSource: RestDataSource_Course_CurrentTerm,
        canAddFormulaFields: true,
        contextMenu: Menu_ListGrid_CurrentTerm,
        autoFetchData: true,

          fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code",title: "<spring:message code='class.code'/>",align: "center",filterOperator: "iContains",autoFitWidth: true},
           // {name: "titleClass",title: "titleClass",align: "center",filterOperator: "iContains",autoFitWidth: true},
            {name: "course.titleFa",title: "<spring:message code='course.title'/>",align: "center",filterOperator: "iContains",autoFitWidth: true,sortNormalizer: function (record) {return record.course.titleFa;}},
            {name: "term.titleFa",title: "term",align: "center",filterOperator: "iContains",hidden: true},
           // {name: "startDate",title: "<spring:message code='start.date'/>",align: "center",filterOperator: "iContains"},
          //  {name: "endDate", title: "<spring:message code='end.date'/>", align: "center", filterOperator: "iContains"},
            {name: "teacher", title: "<spring:message code='teacher'/>", align: "center", filterOperator: "iContains"},
           // {name: "reason", title: "<spring:message code='training.request'/>", align: "center",valueMap: {"1": "نیازسنجی","2": "درخواست واحد","3": "نیاز موردی"},},
            {name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",valueMap: {"1": "برنامه ریزی","2": "در حال اجرا","3": "پایان یافته",},},
        ],
        recordDoubleClick: function () {

        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 2,
        sortDirection: "descending",

    });
        var criteria_CalculatorCurrentTerm = {
        _constructor: "AdvancedCriteria",
        operator: "and",
        criteria: [
            {fieldName: "startDate", operator: "lessThanOrEqual",value:todayDate},
            {fieldName: "endDate",operator:"greaterThan", value: todayDate}
        ]
    };
    var ListGrid_CalculatorCurrentTerm1 = isc.TrLG.create({
        dataSource: RestDataSource_Class_CurrentTerm,
         allowAdvancedCriteria: true,
        contextMenu: Menu_ListGrid_CurrentTerm,
           fields: [
            {name: "corseCode",title:"کد دوره",autoFitWidth: true},
            {name: "titleClass",title:"عنوان کلاس",autoFitWidth: true},
            {name: "code",title:"کد کلاس",autoFitWidth: true},
            {name: "startDate",title:"تاریخ شروع",autoFitWidth: true},
            {name: "endDate",title:"تاریخ پایان",autoFitWidth: true},
            {name: "hduration",title:"مدن زمان(ساعت)",autoFitWidth: true},
            {name: "classStatus",title:"وضعیت کلاس",autoFitWidth: true},
        ],
        recordDoubleClick: function () {

        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 2,
        sortDirection: "descending",

    });


    //*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************

      var selectedPerson=null
   PersonnelDS_Calender_CurrentTerm = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains",autoFitWidth: true},
             {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: personnelUrl + "/iscList"
    });


  Menu_Calender_CurrentTerm = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(PersonnelsLG_Calender_CurrentTerm);
            }
        }]
    });
   PersonnelsLG_Calender_CurrentTerm = isc.TrLG.create({
        dataSource: PersonnelDS_Calender_CurrentTerm,
          contextMenu: Menu_Calender_CurrentTerm,
        autoFetchData:true,
        selectionType: "single",
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "companyName"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "postTitle"},
            {name: "postCode"},
        ],
        rowDoubleClick:Select_Person

    });



    Window_Calender_CurrentTerm = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code="personnel.choose"/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                  PersonnelsLG_Calender_CurrentTerm,
                ]
        })]
    });

     function Select_Person(record) {
        record = (record == null) ? PersonnelsLG_Calender_CurrentTerm.getSelectedRecord() : record;
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
         if (record.postCode !== undefined) {

         var code = record.postCode.replace("/", ".");
            selectedPerson=record
            wait_NABOP = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/" + code, "GET", null, PostCodeSearch));

        }
         else {
            createDialog("info", "<spring:message code="personnel.without.postCode"/>");
        }
        }

         function PostCodeSearch(resp) {
        wait_NABOP.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 200) {
            print_CurrentTerm(JSON.parse(resp.httpResponseText));
           } else if (resp.httpResponseCode === 404 && resp.httpResponseText === "PostNotFound") {
            createDialog("info", "<spring:message code='needsAssessmentReport.postCode.not.Found'/>");
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({

        title: "<spring:message code="refresh"/>",
        click: function () {
          //  ListGrid_CalculatorCurrentTerm.invalidateCache();
        }
    });


    var ToolStripButton_Print = isc.ToolStripButtonPrint.create({
         title: "<spring:message code="print"/>",
        click: function () {
       Window_Calender_CurrentTerm.show()
        }
    });


    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
             ToolStripButton_Print,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh,
                ]
            })
        ]
    });
    //***********************************************************************************
    //HLayout
    //***********************************************************************************
    var HLayout_Actions_Group = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions]
    });
    var VLayout1=isc.VLayout.create({
       width: "40%",
       // height: "100%",
        members: [ListGrid_CalculatorCurrentTerm1]
    });
     var VLayout2=isc.VLayout.create({
        width: "20%",
        //height: "100%",
          members: [ListGrid_Course_CalculatorCurrentTerm]
    });

    var HLayout_Grid_CalculatorCurrentTerm = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [VLayout2,VLayout1]
    });

    var VLayout_Body_Group = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Group
            , HLayout_Grid_CalculatorCurrentTerm
        ]
    });

    //************************************************************************************
    //function
    //************************************************************************************
    //===================================================================================



   function print_CurrentTerm(post) {
   Window_Calender_CurrentTerm.close();
          //isc.RPCManager.sendRequest(TrDSRequest(calenderCurrentTerm + "print"+"?objectId=" + post.id +"&postTitle="+selectedPerson.postTitle +"&postCode="+selectedPerson.postCode +"&personnelNo=" + selectedPerson.personnelNo+"&personnelNo2="+selectedPerson.personnelNo2 +"&companyName="+selectedPerson.companyName + "&objectType=Post" + "&nationalCode=" + selectedPerson.nationalCode +"&firstName=" +selectedPerson.firstName + "&lastName="+selectedPerson.lastName,"POST", null, null));

            RestDataSource_Class_CurrentTerm.fetchDataURL = calenderCurrentTerm + "print"+"?objectId=" + post.id +"&postTitle="+selectedPerson.postTitle +"&postCode="+selectedPerson.postCode +"&personnelNo=" + selectedPerson.personnelNo+"&personnelNo2="+selectedPerson.personnelNo2 +"&companyName="+selectedPerson.companyName + "&objectType=Post" + "&nationalCode=" + selectedPerson.nationalCode +"&firstName=" +selectedPerson.firstName + "&lastName="+selectedPerson.lastName;
            ListGrid_CalculatorCurrentTerm1.fetchData()
            ListGrid_CalculatorCurrentTerm1.invalidateCache()
         <%--                   actionURL: "<spring:url value="/web/calender_current_term"/>"+"?objectId=" + post.id +"&postTitle="+selectedPerson.postTitle +"&postCode="+selectedPerson.postCode +"&personnelNo=" + selectedPerson.personnelNo+"&personnelNo2="+selectedPerson.personnelNo2 +"&companyName="+selectedPerson.companyName + "&objectType=Post" + "&nationalCode=" + selectedPerson.nationalCode +"&firstName=" +selectedPerson.firstName + "&lastName="+selectedPerson.lastName,--%>
         <%--                   httpMethod: "POST",--%>
         <%--                   useSimpleHttp: true,--%>
         <%--                   target: "_Blank",--%>
         <%--                   contentType: "application/json; charset=utf-8",--%>
         <%--                   httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},--%>
         <%--                   serverOutputAsString: false,--%>
         <%--                   callback: function (resp) {--%>
         <%--                   }--%>
         <%--               });--%>
           };

