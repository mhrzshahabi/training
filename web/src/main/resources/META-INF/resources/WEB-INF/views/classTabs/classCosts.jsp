<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>

    var Wait_JspClassCosts = null;
    var ClassID_JspClassCosts = null;

    var currency_ds_JspClassCosts = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>"},
                {name: "code", title: "<spring:message code="code"/>"}
            ],
        autoFetchData: false,
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/currency"
    });

    var DynamicForm_JspClassCosts = isc.DynamicForm.create({
        titleAlign: "left",
        titleWidth: 150,
        numCols: 4,
        margin: 5,
        showInlineErrors: true,
        showErrorText: false,
        fields: [
            {
                name: "studentCost",
                title: "هزینه ثبت نام فراگیر در کلاس",
                length: "9",
                keyPressFilter: "[0-9]",
                hint: "#########",
                showHintInField: true,
                required: true,
            },
            {
                name: "studentCostCurrency",
                title: "انتخاب واحد پول",
                type: "SelectItem",
                filterOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: currency_ds_JspClassCosts,
                required: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
        ]
    });


    var saveButton_JspClassCosts = isc.IButtonSave.create({
        title: "تائید",
        align: "center",
        click: function () {
            DynamicForm_JspClassCosts.validate();
            if (DynamicForm_JspClassCosts.hasErrors())
                return;
            else {
                Wait_JspClassCosts = createDialog("wait");
                let record = new Object();
                record.studentCost = DynamicForm_JspClassCosts.getValue("studentCost");
                record.studentCostCurrency = DynamicForm_JspClassCosts.getValue("studentCostCurrency");
                isc.RPCManager.sendRequest(TrDSRequest(classUrl  + "updateCostInfo/" + ClassID_JspClassCosts, "PUT", JSON.stringify(record), (resp) => {
                    Wait_JspClassCosts.close();
                    ListGrid_Class_JspClass.getSelectedRecord().studentCost = DynamicForm_JspClassCosts.getValue("studentCost");
                    ListGrid_Class_JspClass.getSelectedRecord().studentCostCurrency = DynamicForm_JspClassCosts.getValue("studentCostCurrency");
                    let OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                    "<spring:message code="msg.command.done"/>");
                    setTimeout(function () {
                    OK.close();
                    }, 3000);
                }));
            }
        }
    });

    var VLayout_Body_JspClassCosts = isc.TrVLayout.create({
        width: "100%",
        height: "100%",
        overflow: "scroll",
        members: [
            DynamicForm_JspClassCosts,
            isc.TrHLayoutButtons.create({
                members: [saveButton_JspClassCosts]
            })
        ]
    });

    function loadPage_classCosts(studentCost, studentCostCurrency,classId) {
        if (studentCost != null && studentCost != undefined)
            DynamicForm_JspClassCosts.getField("studentCost").setValue(studentCost);
        else
            DynamicForm_JspClassCosts.getField("studentCost").setValue();
        if (studentCostCurrency != null || studentCostCurrency != undefined)
            DynamicForm_JspClassCosts.getField("studentCostCurrency").setValue(studentCostCurrency);
        else
            DynamicForm_JspClassCosts.getField("studentCostCurrency").setValue(619);
        ClassID_JspClassCosts = classId;
    }