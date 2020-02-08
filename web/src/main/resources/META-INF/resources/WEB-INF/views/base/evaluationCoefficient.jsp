<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
//<script>

    var z1z2Data = [];

    var RestDataSource_Coefficient_JspConfigQuestionnaire = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
            {name: "value", title: "<spring:message code="value"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterUrl + "/iscList/z1z2"
    });

    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FET", "GET", null, setZ1Z2Data));
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FER", "GET", null, setZ1Z2Data));
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FEB", "GET", null, setZ1Z2Data));
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FEL", "GET", null, setZ1Z2Data));

    function setZ1Z2Data(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            z1z2Data = (JSON.parse(resp.data)).response.data;
            for (var j = 0; j < z1z2Data.length; j++) {
                DynamicForm_Evaluation_Coefficient.setValue(z1z2Data[j].code, z1z2Data[j].value);
                DynamicForm_Evaluation_Coefficient.getItem(z1z2Data[j].code).ID = z1z2Data[j].id + "_Coefficient";
            }
        } else {

        }
    }

    isc.DynamicForm.create({
        ID: "DynamicForm_Evaluation_Coefficient",
        width: "100%",

        showEdges: true,
        edgeSize: 2,

        fields: [{name: "id", hidden: true},

            {
                type: "BlurbItem",
                value: "1- فرمول ارزیابی استاد بعد از تدریس دوره = (نمره ارزیابی فراگیران به استاد) *  Z2 + (نمره ارزیابی مسئول آموزش به استاد) * Z1  "
            },
            {
                width: "200",
                hint: "%",
                required: true,
                mask:"###",
                name: "z1",
                title: "ضریب  نمره ارزیابی مسئول آموزش به استاد &nbsp;(Z1)",
                 change:function(form,item,value) {
                if(value>100)
                    {item.setValue()}
                }

            },
            , {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z2",
                title: "ضریب نمره ارزیابی فراگیران به استاد &nbsp;(Z2)",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minScore_ET",
                title: "حد قبولی نمره ارزیابی استاد",
                required: true,
                change:function(item,value) {
                if(value>100)
                    {item.setValue()}
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minQus_ET",
                title: "حد نصاب پرسشنامه ها",
                required: true,
                 change:function(item,value) {
                if(value>100)
                    {item.setValue()}
                }
            },
// //======================================================================================
            {type: "RowSpacerItem"},
            {
                type: "BlurbItem",
                value: "2- فرمول ارزیابی واکنش کلاس = (نمره ارزیابی فراگیران به امکانات و سازماندهی)* Z4+(نمره ارزیابی دوره توسط استاد)*Z3 +(نمره ارزیابی فراگیران به استاد)*Z2 +(نمره ارزیابی فراگیران به محتوای دوره)*Z1"
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z3",
                title: "ضریب نمره ارزیابی فراگیران به محتوای دوره &nbsp;(Z1)",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z4",
                title: "ضریب نمره ارزیابی فراگیران به استاد&nbsp;(Z2)",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z5",
                title: "ضریب نمره ارزیابی دوره توسط استاد&nbsp;(Z3)",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z6",
                title: "ضریب نمره ارزیابی فراگیران به امکانات و سازماندهی&nbsp;(Z4)",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                type: "integer",
                hint: "%",
                mask: "###",
                name: "minScore_ER",
                title: "حد نصاب قابل قبول برای واکنش",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minQus_ER",
                title: "حد نصاب پرسشنامه ها",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
//=================================================================================================
            {type: "RowSpacerItem"},
            {type: "BlurbItem", value: "3- فرمول ارزیابی یادگیری کلاس"},

            {
                hint: "%",
                width: "200",
                mask: "###",
                name: "minPreTest_EL",
                title: "حد نصاب پیش آزمون",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },

            {
                hint: "%",
                width: "200",
                mask: "###",
                name: "minPasTest_EL",
                title: "حد نصاب پس آزمون",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minQus_EL",
                title: "حد نصاب پرسشنامه ها",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
//====================================================================================
            {type: "RowSpacerItem"},
            {type: "BlurbItem", value: "4- فرمول ارزیابی تغییر رفتار"},
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z7",
                title: "(نمره ارزیابی بالا دست)Z1",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "##",
                name: "z8",
                title: "(نمره ارزیابی فراگیران)Z2",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minScore_EB",
                title: "حدقبولی نمره ارزیابی رفتاری",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minScore_PreTestEB",
                title: "حد قبولی نمره پیش آزمون",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },

            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minQus_EB",
                title: "حد نصاب پرسشنامه ها",
                required: true,
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },


        ],

    });

    var Window_Evaluation_Coefficient = isc.Window.create({

        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,

        items: [DynamicForm_Evaluation_Coefficient, isc.MyHLayoutButtons.create({
            members: [isc.IButtonSave.create({
                title: "ذخیره",
                click: function () {

                 DynamicForm_Evaluation_Coefficient.validate();
            if (DynamicForm_Evaluation_Coefficient.hasErrors()) {

                return;
            }

                    var fields = DynamicForm_Evaluation_Coefficient.getFields();
                    var toUpdate = [];

                    for (var i = 0; i < fields.length; i++) {
                        if (fields[i].getID().startsWith("isc"))
                            continue;
                        toUpdate.add({
                            "id": ((fields[i].getID()).split('_'))[0],
                            "value": fields[i].getValue()
                        });
                    }
                    if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z1")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z2")) != 100) {
                        createDialog("info", "جمع ضرایب فرمول یک باید 100 شود", "<spring:message code="message"/>")
                        return;
                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z3")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z4")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z5")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z6")) != 100) {
                        createDialog("info", "جمع ضرایب فرمول دو باید 100 شود", "<spring:message code="message"/>")
                        return;
                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z7")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z8")) != 100) {
                        createDialog("info", "جمع ضرایب فرمول چهارباید 100 شود", "<spring:message code="message"/>")
                        return;
                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("minPasTest_EL")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("minPreTest_EL")) != 100) {
                        createDialog("info", "جمع حد نصاب فرمول سه باید 100 شود", "<spring:message code="message"/>")
                        return;
                    } else {
                        var parameterValue = parameterValueUrl + "/edit-config-list"
                        isc.RPCManager.sendRequest(TrDSRequest(parameterValue, "PUT", JSON.stringify(toUpdate), "callback:show_Result(rpcResponse)"));
                        DynamicForm_Evaluation_Coefficient.refreshFields();


                    }
                }
            }), isc.IButtonCancel.create({
                title: "بستن",
                click: function () {
                    trainingTabSet.removeTab(trainingTabSet.getSelectedTab())

                }
            })],
        }),]
    })

    function show_Result(resp) {
    if(resp.httpResponseCode == 200 || resp.httpResponseCode == 201)
        {
         createDialog("info", "اطلاعات با موفقیت ثبت شد", "<spring:message code="message"/>")
        }

}
    // ======================================
    // var Hlayout_Body=isc.HLayout.create({
    // width:"50%",
    // height:"50%",
    // leaveScrollbarGap:"false",
    // members:[DynamicForm_Evaluation_Coefficient]
    // })
    // var Hlayout_Body2=isc.HLayout.create({
    // height:"50%",
    // width:"50%",
    // leaveScrollbarGap:"true",
    // members:[,isc.IButtonCancel.create({
    //              title: "لغو",
    //              click: function () {
    //                  Window_Evaluation_Coefficient.close();
    //              }
    //          })]
    // })
    //  var Vlayout_Body = isc.VLayout.create({
    // height:"100%",
    // width:"100%",
    //      members: [Hlayout_Body2,Hlayout_Body],
    //  })