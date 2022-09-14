<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>


    let RestDataSource_AllCompetenceNeedsAssessmentGap = isc.TrDS.create({
        fields: [
            {name: "code", title: "کد شایستگی", autoFitData: true, autoFitWidthApproach: true},
            {name: "title", title: "نام شایستگی"},
            {name: "competenceType.title", title: "نوع شایستگی"},
            {name: "competenceLevelId", title: "حیطه" , },
            {name: "competencePriorityId", title: "اولویت" , }
        ],
    });


    let ListGrid_AllCompetenceNeedsAssessmentGap = isc.ListGrid.create({
        ID: "ListGrid_AllCompetenceNeedsAssessmentGap",
        dataSource: RestDataSource_AllCompetenceNeedsAssessmentGap,
        filterOnKeypress: true,
        autoFetchData: false,
        fields: [
            {name: "code", title: "کد شایستگی", autoFitData: true, autoFitWidthApproach: true},
            {name: "title", title: "نام شایستگی"},
            {name: "competenceType.title", title: "نوع شایستگی"},
            {name: "competenceLevelId", title: "حیطه" , },
            {name: "competencePriorityId", title: "اولویت" , }
        ]
    });

    <%--//----------------------------------------- ToolStrips --------------------------------------------------------------%>



    let HLayout_Data = isc.TrHLayout.create({
        members: [
            isc.TrVLayout.create({
                ID: "VLayoutLeft_JspAllCompetenceNeedsAssessmentGap",
                members: [
                    ListGrid_AllCompetenceNeedsAssessmentGap
                ]
            })
        ]
    });

    let ToolStrip_JspNeedsAssessmentAllCompetence = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        align: "center",
        border: "1px solid gray",
        members: [
            // buttonSave,
            // buttonSendToWorkFlow,
            // buttonChangeCancel
        ]
    });


    isc.TrVLayout.create({
        members: [
            HLayout_Data,
            ToolStrip_JspNeedsAssessmentAllCompetence
        ],
    });





    function loadEditNeedsAssessmentAllCompeteceGap(record, type) {
        gapObjectId = record.id
        gapObjectType = type
        RestDataSource_AllCompetenceNeedsAssessmentGap.fetchDataURL = CompetencesIscList+"/"+gapObjectId+"/"+gapObjectType;
        // ListGrid_AllCompetenceNeedsAssessmentGap.invalidateCache();
        // ListGrid_AllCompetenceNeedsAssessmentGap.fetchData();
        // clearAllGrid()
        // wait.show();
        <%--isc.RPCManager.sendRequest(TrDSRequest(canChangeData+gapObjectId+"/"+gapObjectType , "Get",null, function (resp) {--%>
        <%--    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
        <%--        wait.close();--%>
        <%--    } else {--%>
        <%--        wait.close();--%>
        <%--        createDialog("info", "<spring:message code="msg.operation.error"/>");--%>
        <%--    }--%>
        <%--}));--%>
    }






    // </script>
