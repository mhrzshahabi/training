<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
//
//<script>

RestDataSource_Scores = isc.TrDS.create({
fields: [
{name: "id", hidden: true},
{
name: "firstName",
title: "<spring:message code="firstName"/>",
filterOperator: "iContains",
autoFitWidth: true
},
{
name: "lastName",
title: "<spring:message code="lastName"/>",
filterOperator: "iContains",
autoFitWidth: true
},
{
name: "nationalCode", title: "<spring:message
        code="national.code"/>", filterOperator: "iContains", autoFitWidth: true
},
{
name: "companyName",
title: "<spring:message code="company.name"/>",
filterOperator: "iContains",
autoFitWidth: true
},
{
name: "personnelNo",
title: "<spring:message code="personnel.no"/>",
filterOperator: "iContains",
autoFitWidth: true
},
{
name: "personnelNo2",
title: "<spring:message code="personnel.no.6.digits"/>",
filterOperator: "iContains"
},
{
name: "postTitle",
title: "<spring:message code="post"/>",
filterOperator: "iContains",
autoFitWidth: true
},
{name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
{
name: "ccpAssistant",
title: "<spring:message code="reward.cost.center.assistant"/>",
filterOperator: "iContains"
},
{
name: "ccpAffairs",
title: "<spring:message code="reward.cost.center.affairs"/>",
filterOperator: "iContains"
},
{
name: "ccpSection",
title: "<spring:message code="reward.cost.center.section"/>",
filterOperator: "iContains"
},
{name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
],
fetchDataURL: classUrl + "student"
});

ToolStrip_Scores = isc.ToolStrip.create({
members: [
isc.TrRefreshBtn.create({
click: function () {
}
}),
isc.TrAddBtn.create({
click: function () {
}
}),
isc.TrRemoveBtn.create({
click: function () {
}
}),
// isc.LayoutSpacer.create({width: "*"}),
// isc.Label.create({ID: "StudentsCount_student"}),
]
});

var ListGrid_Scores = isc.TrLG.create({
dataSource: RestDataSource_Scores,
fields: [
{name: "firstName"},
{name: "lastName"},
{name: "nationalCode"},
{name: "companyName"},
{name: "personnelNo"},
{name: "personnelNo2"},
// {name: "postTitle"},
// {name: "ccpArea"},
// {name: "ccpAssistant"},
// {name: "ccpAffairs"},
// {name: "ccpSection"},
// {name: "ccpUnit"},
],
gridComponents: [ToolStrip_Scores, "filterEditor", "header", "body"],
});

var vlayout = isc.VLayout.create({
width: "100%",
members: [ListGrid_Scores]
})

function loadPage_Scores() {
classRecord = ListGrid_Class_JspClass.getSelectedRecord();
if (!(classRecord == undefined || classRecord == null)) {
ListGrid_Scores.fetchData({"classID": classRecord.id});
ListGrid_Scores.invalidateCache();
}

}