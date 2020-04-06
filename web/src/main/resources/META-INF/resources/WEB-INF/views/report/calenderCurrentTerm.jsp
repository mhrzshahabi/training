<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

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

     CourseDS_Calender_CurrentTerm = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "needsAssessmentPriorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "needsAssessmentDomainId", title: "<spring:message code='domain'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.competenceTypeId", title: "<spring:message code="competence.type"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.scoresState", title: "<spring:message code='status'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.titleFa", title: "<spring:message code="course"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: null
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

   ToolStripButton_Calender_CurrentTerm = isc.ToolStripButtonRefresh.create({
        click: function () {
           refreshLG(PersonnelsLG_Calender_CurrentTerm);
        }
    });
 ToolStrip_Calender_CurrentTerm = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Calender_CurrentTerm
        ]
    });

     var DynamicForm_CalenderCurrentTerm = isc.DynamicForm.create({
        ID: "DynamicForm_CalenderCurrentTerm",
        fields: [

        ]
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
                 ToolStrip_Calender_CurrentTerm,
                 PersonnelsLG_Calender_CurrentTerm,
                // HLayout_Personnel_Ok_NABOP
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
            postCode = record.postCode.replace("/", ".");
            selectedPerson=record
            wait_NABOP = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/" + postCode, "GET", null, PostCodeSearch));
        }
         else {
            createDialog("info", "<spring:message code="personnel.without.postCode"/>");
        }
        }

         function PostCodeSearch(resp) {
        wait_NABOP.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 200) {
            print(JSON.parse(resp.httpResponseText));
           } else if (resp.httpResponseCode === 404 && resp.httpResponseText === "PostNotFound") {
            createDialog("info", "<spring:message code='needsAssessmentReport.postCode.not.Found'/>");
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }
    function print(post) {
        <%--isc.RPCManager.sendRequest({--%>
        <%--                    actionURL: "<spring:url value="/web/calender_current_term"/>"+"?objectId=" + post.id +"&postTitle="+selectedPerson.postTitle +"&postCode="+selectedPerson.postCode +"&personnelNo=" + selectedPerson.personnelNo+"&personnelNo2="+selectedPerson.personnelNo2 +"&companyName="+selectedPerson.companyName + "&objectType=Post" + "&nationalCode=" + selectedPerson.nationalCode +"&firstName=" +selectedPerson.firstName + "&lastName="+selectedPerson.lastName,--%>
        <%--                    httpMethod: "POST",--%>
        <%--                    useSimpleHttp: true,--%>
        <%--                    target: "_Blank",--%>
        <%--                    contentType: "application/json; charset=utf-8",--%>
        <%--                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},--%>
        <%--                    serverOutputAsString: false,--%>
        <%--                    callback: function (resp) {--%>
        <%--                    }--%>
        <%--                });--%>

        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action:"<spring:url value="/web/calender_current_term"/>"+"?objectId=" + post.id +"&postTitle="+selectedPerson.postTitle +"&postCode="+selectedPerson.postCode +"&personnelNo=" + selectedPerson.personnelNo+"&personnelNo2="+selectedPerson.personnelNo2 +"&companyName="+selectedPerson.companyName + "&objectType=Post" + "&nationalCode=" + selectedPerson.nationalCode +"&firstName=" +selectedPerson.firstName + "&lastName="+selectedPerson.lastName,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                   {name: "token", type: "hidden"}
                ]
        })
        criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
            }
