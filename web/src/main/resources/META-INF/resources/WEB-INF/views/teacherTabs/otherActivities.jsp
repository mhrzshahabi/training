<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    DynamicForm_JspOtherActivities = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "right",
        titleWidth: 0,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        fields: [
            {name: "id", hidden: true},
            {
                name: "otherActivities",
                type: 'textArea',
                width:"100%",
                height: "100%",
                title:"ساير فعاليتها، زمينه هاي تجربي و مهارت هاي خود را شرح دهيد. ",
            }
        ]
    });

    var HLayOut_JspOtherActivities = isc.TrHLayout.create({
        showEdges: false,
        align: "right",
        // border: "1px solid orange",
        // backgroundColor: "orange",
        width:"40%",
        height: "80%",
        members: [DynamicForm_JspOtherActivities]
    });

    var VLayOut_JspOtherActivities = isc.TrVLayout.create({
        showEdges: false,
        edgeImage: "",
        align: "right",
        members: [HLayOut_JspOtherActivities]
    });



    //</script>