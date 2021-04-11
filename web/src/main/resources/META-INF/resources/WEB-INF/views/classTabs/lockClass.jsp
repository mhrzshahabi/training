<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>

//<script>
    var classIdForFinish = null;

    var DynamicForm_JspClassFinish = isc.DynamicForm.create({
        titleAlign: "right",
        titleWidth: 200,
        styleName: "evaluation-form",
        numCols: 2,
        margin: 5,
        fields: [
            {
                type: "button",
                title: "اختتام کلاس",
                width: 160,
                height: "30",
                startRow: false,
                endRow: true,
                click: function () {
                    Window_Class_Finish.show();
                }
            },
            {
                type: "button",
                title: "حذف اختتام",
                width: 160,
                height: "30",
                startRow: false,
                endRow: true,
                click: function () {
                    isc.RPCManager.sendRequest(TrDSRequest(changeClassStatusToUnLock + classIdForFinish+"/"+"81" , "GET", null, function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.successful"/>", "3000", "say");
                            Window_Class_Finish.close();
                            ListGrid_Class_refresh();
                        } else {
                            createDialog("info",JSON.parse(resp.httpResponseText).message, "<spring:message code="error"/>");
                        }
                    }));

                }
            },
        ]
    });

    let DynamicForm_Finish_Reason = isc.DynamicForm.create({
        width: 600,
        height: 120,
        padding: 6,
        titleAlign: "right",
        fields: [
            {
                name: "reason",
                width: "100%",
                height: 100,
                title: "توضیحات",
                editorType: 'textArea'
            }
        ]
    });

    let Window_Class_Finish = isc.Window.create({
        width: 600,
        height: 120,
        numCols: 2,
        title: "ثبت اختتام",
        items: [
            DynamicForm_Finish_Reason,
            isc.MyHLayoutButtons.create({
                members: [
                    isc.IButtonSave.create({
                        title: "<spring:message code="save"/>",
                        click: function () {
                           let data = {};
                            data.reason = Window_Class_Finish.items[0].getField("reason").getValue();
                            data.classId=classIdForFinish;
                            data.groupId="61";
                            isc.RPCManager.sendRequest(TrDSRequest(changeClassStatusToLock, "POST",  JSON.stringify(data), function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.successful"/>", "3000", "say");
                                    ListGrid_Class_refresh();
                                    Window_Class_Finish.items[0].setValue("reason", "");
                                    Window_Class_Finish.close();
                                } else {
                                   createDialog("info",JSON.parse(resp.httpResponseText).message, "<spring:message code="error"/>");
                                }
                            }));

                        }
                    }),
                    isc.IButtonCancel.create({
                        title: "<spring:message code="cancel"/>",
                        click: function () {
                            Window_Class_Finish.items[0].setValue("reason", "");
                            Window_Class_Finish.close();
                        }
                    })]
            })]
    });

    var VLayout_Body_JspClassFinish = isc.TrVLayout.create({
        width: "100%",
        height: "100%",
        overflow: "scroll",
        members: [
            DynamicForm_JspClassFinish
        ]
    });

    function loadPage_classFinish(classId) {
        //id -> 61 = id lock in work group table
        //id -> 81 = id unLock in work group table
        // isc.RPCManager.sendRequest(TrDSRequest(hasAccessToGroups+"61,81", "GET",null, function (resp) {
        //     if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
        //                 console.log(resp.data)
        //
        //         alert(resp.data.getItem("61").getValue())
        //
        //         // if (resp.data === "false" )
        //         //     TabSet_Class.disableTab(TabSet_Class.getTab("classFinish"));
        //         // else
        //         //     TabSet_Class.enableTab(TabSet_Class.getTab("classFinish"));
        //
        //     }

        // }));
        classIdForFinish = classId;
    }