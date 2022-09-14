<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>


    let RestDataSource_AllCompetenceNeedsAssessmentGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد شایستگی", autoFitData: true, autoFitWidthApproach: true},
            {name: "title", title: "نام شایستگی"},
            {name: "competenceType", title: "نوع شایستگی"},
            {name: "competenceLevelId", title: "حیطه" , },
            {name: "competencePriorityId", title: "اولویت" , },
            {name: "courseCode", title: "کد دوره" , },
            {name: "courseTitleFa", title: "نام دوره" , },
            {name: "limitSufficiency", title: "حد بسندگی" , }
        ],
    });


    let ListGrid_AllCompetenceNeedsAssessmentGap = isc.ListGrid.create({
        ID: "ListGrid_AllCompetenceNeedsAssessmentGap",
        dataSource: RestDataSource_AllCompetenceNeedsAssessmentGap,
        filterOnKeypress: true,
        autoFetchData: false,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد شایستگی", autoFitData: true, autoFitWidthApproach: true},
            {name: "title", title: "نام شایستگی"},
            {name: "competenceType", title: "نوع شایستگی"},
            {name: "needsAssessmentDomain", title: "حیطه" , },
            {name: "needsAssessmentPriority", title: "اولویت" , },
            {name: "courseCode", title: "کد دوره" , },
            {name: "courseTitleFa", title: "نام دوره" , },
            {name: "limitSufficiency", title: "حد بسندگی" , }
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
        RestDataSource_AllCompetenceNeedsAssessmentGap.fetchDataURL = allCompetencesIscList+"/"+gapObjectId+"/"+gapObjectType;
        ListGrid_AllCompetenceNeedsAssessmentGap.invalidateCache();
        ListGrid_AllCompetenceNeedsAssessmentGap.fetchData();

    }






    // </script>
