<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var productData = [
        {quarter:"Q1, 2016", month:"دانشی", domain:"شایستگی برنامه نویسی", product:"عملکرد ضروری", _value:"توانایی"},
        {quarter:"Q1, 2016", month:"مهارتی", domain:"شایستگی برنامه نویسی", product:"عملکرد بهبود", _value:"آشنایی"},
        {quarter:"Q1, 2016", month:"نگرشی", domain:"شایستگی برنامه نویسی", product:"عملکرد توسعه", _value:"مهارتییس"},

    ];

    var NeedAssessmentDF_First = isc.DynamicForm.create({
        numCols:8,
        margin: 20,
        border:"2px solid red",

        fields:[
            {
              type:"SpacerItem",
                colSpan:2
            },
            {
                name:"alignment", type:"radioGroup", showTitle:false,
                valueMap:["شغل","گروه شغلی","پست","گروه پستی"], defaultValue:"center",
                change:"countryList.getField('countryCode').align = value; countryList.markForRedraw()",
                align:"center",
                // colSpan:1
            },
            {
                name:"combo", type:"TrComboAutoRefresh", showTitle:false,
                width:"250",
                align:"center",

            }
        ]
    });
    var NeedAssessmentCG_First = isc.CubeGrid.create({
        width:"100%",
        height:"100%",
        // autoSize:true,
        // bodyStyleName:"ListGrid",
        // baseStyle:"cell",
        // overflow:"hidden",
        // bodyOverflow:"auto",
        ID: "basicCubeGrid",
        border:"2px solid red",
        // styleName: "fontSize1",
        autoFitFieldWidths:true,
        enableCharting: true,
        defaultFacetWidth:200,
        autoSizeHeaders:true,
        bodyMinWidth:1280,
        layoutAlign:"center",
        // canCollapseFacets:true,
        data: productData,
        hideEmptyFacetValues: true,
        // valueFormat: "\u00A4,0.00",
        columnFacets: ["quarter", "month"],
        rowFacets: ["domain", "product"],

        // configure export colors
        exportFacetTextColor: "blue",
        exportFacetBGColor: "yellow",

        exportColumnFacetTextColor: "red",
        exportColumnFacetBGColor: "#44FF44",

        exportDefaultBGColor: "#FFDDAA",
        cellClick :function(record, rowNum, colNum){
            alert("")
        }
    });

    isc.VLayout.create({
        // autoDraw:true,
        border:"2px solid red",
        width: "100%",
        height: "100%",
        // membersMargin:10,
        members: [NeedAssessmentDF_First,NeedAssessmentCG_First],
    });