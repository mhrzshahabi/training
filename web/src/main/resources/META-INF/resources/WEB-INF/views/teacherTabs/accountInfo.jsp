<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var DynamicForm_AccountInfo_JspTeacher = isc.DynamicForm.create({
        height: "100%",
        align: "right",
        canSubmit: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        numCols: 6,
        titleAlign: "left",
        margin: 10,
        newPadding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "personality.accountInfo.bank",
                title: "<spring:message code='bank'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },
            {
                name: "personality.accountInfo.bankBranch",
                title: "<spring:message code='bank.branch'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "30"
            },

            {
                name: "personality.accountInfo.bankBranchCode",
                title: "<spring:message code='bank.branch.code'/>",
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "personality.accountInfo.accountNumber",
                title: "<spring:message code='account.number'/>",
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "personality.accountInfo.cartNumber",
                title: "<spring:message code='cart.number'/>",
                keyPressFilter: "[0-9]",
                length: "16"
            },

            {
                name: "personality.accountInfo.shabaNumber",
                title: "<spring:message code='shaba.number'/>",
                keyPressFilter: "[0-9]",
                length: "30"
            },

            {
                name: "economicalCode",
                title: "<spring:message code='economical.code'/>",
                keyPressFilter: "[0-9]",
                length: "15",
                stopOnError: true
            },

            {
                name: "economicalRecordNumber",
                title: "<spring:message code='economical.record.number'/>",
                keyPressFilter: "[0-9]",
                length: "15",
                stopOnError: true
            }
        ]
    });


    var VLayOut_JspAccountInfo = isc.TrVLayout.create({
        showEdges: false,
        edgeImage: "",
        align: "right",
        members: [DynamicForm_AccountInfo_JspTeacher]
    });



    //</script>