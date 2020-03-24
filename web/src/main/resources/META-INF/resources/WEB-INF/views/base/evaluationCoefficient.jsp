<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    var z1z2Data = [];

    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FET", "GET", null, setZ1Z2Data));
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FER", "GET", null, setZ1Z2Data));
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FEB", "GET", null, setZ1Z2Data));
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FEL", "GET", null, setZ1Z2Data));
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FEC_R", "GET", null, setZ1Z2Data));
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FEC_L", "GET", null, setZ1Z2Data));
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FEC_B", "GET", null, setZ1Z2Data));

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
        showInlineErrors: true,
        edgeSize: 2,
        fields: [{name: "id", hidden: true},

            {
                type: "BlurbItem",
                value: "1- فرمول ارزیابی استاد بعد از تدریس دوره = (نمره ارزیابی فراگیران به استاد) * Z2 + (نمره ارزیابی مسئول آموزش به استاد) * Z1 "
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z1",
                title: "ضریب نمره ارزیابی مسئول آموزش به استاد &nbsp;(Z1)",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }

                }
            },
            , {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z2",
                title: "ضریب نمره ارزیابی فراگیران به استاد &nbsp;(Z2)",
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
                name: "minScoreET",
                title: "حد قبولی نمره ارزیابی استاد",
                change: function (item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minQusET",
                title: "حداقل تعداد پرسشنامه های تکمیل شده",
                change: function (item, value) {

                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
// //======================================================================================
            {type: "RowSpacerItem"},
            {
                type: "BlurbItem",
                value: "2- فرمول ارزیابی واکنشی کلاس = (نمره ارزیابی فراگیران به امکانات و سازماندهی)* Z4+(نمره ارزیابی دوره توسط استاد)*Z3 +(نمره ارزیابی فراگیران به استاد)*Z2 +(نمره ارزیابی فراگیران به محتوای دوره)*Z1"
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z3",
                title: "ضریب نمره ارزیابی فراگیران به محتوای دوره &nbsp;(Z1)",
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
                name: "minScoreER",
                title: "حد قبولی نمره واکنشی",
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
                name: "minQusER",
                title: "حداقل تعداد پرسشنامه های تکمیل شده",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
//=================================================================================================
            {type: "RowSpacerItem"},
            {type: "BlurbItem", value: "3- فرمول ارزیابی یادگیری کلاس "},

            {
                hint: "%",
                width: "200",
                mask: "###",
                name: "minPreTestEL",
                title: "حد قبولی نمره پیش آزمون",
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
                name: "minPasTestEL",
                title: "حد قبولی نمره پس آزمون",

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
                name: "minScoreEL",
                title: "حد قبولی",
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
                name: "minQusEL",
                title: "حداقل تعداد پرسشنامه های تکمیل شده",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
//====================================================================================
            {type: "RowSpacerItem"},
            {
                type: "BlurbItem",
                value: "4- فرمول ارزیابی تغییر رفتار= ( نمره ارزیابی فراگیران)*Z2 + ( نمره ارزیابی بالا دست)*Z1"
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "z7",
                title: "(ضریب نمره ارزیابی بالا دست)Z1",

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
                name: "z8",
                title: "(ضریب نمره ارزیابی فراگیران)Z2",

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
                name: "minScoreEB",
                title: "حدقبولی نمره ارزیابی رفتاری",

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
                name: "minScorePreTestEB",
                title: "حد قبولی نمره پیش آزمون",

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
                name: "minQusEB",
                title: "حداقل تعداد پرسشنامه های تکمیل شده",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
//==================================================================================================
            {type: "RowSpacerItem"},
            {type: "BlurbItem", value: "5- فرمول اثربخشی کلاس _ واکنشی=( نمره ارزیابی واکنشی کلاس)*Z1"},
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "FECRZ",
                title: "ضریب نمره ارزیابی واکنشی کلاس(Z1)",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()

                    }
                }
            }, {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minScoreFECR",
                title: "حد قبولی نمره اثر بخشی",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()

                    }
                }
            },
//=======================================================================================
            {type: "RowSpacerItem"},
            {
                type: "BlurbItem",
                value: "6- فرمول اثربخشی کلاس _ یادگیری=( نمره ارزیابی یادگیری)*Z2 +( نمره ارزیابی واکنشی دوره)*Z1 "
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "FECLZ1",
                title: "ضریب نمره ارزیابی واکنشی دوره(Z1)",
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
                name: "FECLZ2",
                title: "ضریب نمره ارزیابی یادگیری(Z2)",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
//================================================================================
            {type: "RowSpacerItem"},
            {
                type: "BlurbItem",
                value: "7- فرمول اثربخشی کلاس _ رفتاری= ( نمره رفتار)*Z3 + ( نمره ارزیابی یادگیری)*Z2 + ( نمره ارزیابی واکنشی دوره)*Z1"
            },
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "FECBZ1",
                title: "ضریب نمره ارزیابی واکنشی دوره(Z1)",
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
                name: "FECBZ2",
                title: "ضریب نمره ارزیابی یادگیری(Z2)",

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
                name: "FECBZ3",
                title: "ضریب نمره رفتار(Z3)",

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
                    if (!DynamicForm_Evaluation_Coefficient.validate()) {

                        return;
                    }


                    var fields = DynamicForm_Evaluation_Coefficient.getFields();
                    var toUpdate = [];

                    for (var i = 0; i < fields.length; i++) {
                        if (fields[i].getID().startsWith("isc"))
                            continue;
                        toUpdate.add({
                            "id": ((fields[i].getID()).split('_'))[0],
                            "value": fields[i].getValue(),
                        });
                    }
                    if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z1")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z2")) != 100) {
                        var str1 = DynamicForm_Evaluation_Coefficient.getItem("z1").title
                        var str2 = DynamicForm_Evaluation_Coefficient.getItem("z2").title
                         if (DynamicForm_Evaluation_Coefficient.getItem("z1").getValue() == null)
                         {
                             DynamicForm_Evaluation_Coefficient.getItem("z1").focusInItem()
                             createDialog("info", "فیلد ' " + str1 + " ' خالی می باشد", "<spring:message code="message"/>")
                          }
                         else if (DynamicForm_Evaluation_Coefficient.getItem("z2").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("z2").focusInItem()
                             createDialog("info", "فیلد ' " + str2 + " ' خالی می باشد", "<spring:message code="message"/>")
                          }
                          else{
                           createDialog("info", "جمع ضرایب فرمول یک باید 100 شود", "<spring:message code="message"/>")
                           }
                    }


                    else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z3")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z4")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z5")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z6")) != 100) {
                        var str3 = DynamicForm_Evaluation_Coefficient.getItem("z3").title
                        var str4 = DynamicForm_Evaluation_Coefficient.getItem("z4").title
                        var str5 = DynamicForm_Evaluation_Coefficient.getItem("z5").title
                        var str6 = DynamicForm_Evaluation_Coefficient.getItem("z6").title
                         if (DynamicForm_Evaluation_Coefficient.getItem("z3").getValue() == null)
                         {
                             DynamicForm_Evaluation_Coefficient.getItem("z3").focusInItem()
                             createDialog("info", "فیلد ' " + str3 + " ' خالی می باشد", "<spring:message code="message"/>")
                          }
                         else if (DynamicForm_Evaluation_Coefficient.getItem("z4").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("z4").focusInItem()
                             createDialog("info", "فیلد ' " + str4 + " ' خالی می باشد", "<spring:message code="message"/>")
                          }
                           else if (DynamicForm_Evaluation_Coefficient.getItem("z5").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("z5").focusInItem()
                             createDialog("info", "فیلد ' " + str5 + " ' خالی می باشد", "<spring:message code="message"/>")
                          } else if (DynamicForm_Evaluation_Coefficient.getItem("z6").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("z6").focusInItem()
                             createDialog("info", "فیلد ' " + str6 + " ' خالی می باشد", "<spring:message code="message"/>")
                          }
                          else{
                           createDialog("info", "جمع ضرایب فرمول دو باید 100 شود", "<spring:message code="message"/>")
                           }

                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z7")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z8")) != 100) {
                        var str7 = DynamicForm_Evaluation_Coefficient.getItem("z7").title
                        var str8 = DynamicForm_Evaluation_Coefficient.getItem("z8").title
                        if (DynamicForm_Evaluation_Coefficient.getItem("z7").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("z7").focusInItem()
                             createDialog("info", "فیلد ' " + str7 + " ' خالی می باشد", "<spring:message code="message"/>")
                          } else if (DynamicForm_Evaluation_Coefficient.getItem("z8").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("z8").focusInItem()
                             createDialog("info", "فیلد ' " + str8 + " ' خالی می باشد", "<spring:message code="message"/>")
                          }
                          else{
                             createDialog("info", "جمع ضرایب فرمول چهارباید 100 شود", "<spring:message code="message"/>")
                             return;
                          }
                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECLZ1")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECLZ2")) != 100) {
                        var strFECLZ1 = DynamicForm_Evaluation_Coefficient.getItem("FECLZ1").title
                        var strFECLZ2 = DynamicForm_Evaluation_Coefficient.getItem("FECLZ2").title
                         if (DynamicForm_Evaluation_Coefficient.getItem("FECLZ1").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("FECLZ1").focusInItem()
                             createDialog("info", "فیلد ' " + strFECLZ1 + " ' خالی می باشد", "<spring:message code="message"/>")
                          } else if (DynamicForm_Evaluation_Coefficient.getItem("FECLZ2").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("FECLZ2").focusInItem()
                             createDialog("info", "فیلد ' " + strFECLZ2 + " ' خالی می باشد", "<spring:message code="message"/>")
                          }
                          else{
                            createDialog("info", "جمع ضرایب فرمول شش باید 100 شود", "<spring:message code="message"/>")
                            return;
                          }
                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECBZ1")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECBZ2")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECBZ3")) != 100) {
                        var strFECBZ1 = DynamicForm_Evaluation_Coefficient.getItem("FECBZ1").title
                        var strFECBZ2 = DynamicForm_Evaluation_Coefficient.getItem("FECBZ2").title
                        var strFECBZ3 = DynamicForm_Evaluation_Coefficient.getItem("FECBZ3").title
                       if (DynamicForm_Evaluation_Coefficient.getItem("FECBZ1").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("FECBZ1").focusInItem()
                             createDialog("info", "فیلد ' " + strFECBZ1 + " ' خالی می باشد", "<spring:message code="message"/>")
                          } else if (DynamicForm_Evaluation_Coefficient.getItem("FECBZ2").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("FECBZ2").focusInItem()
                             createDialog("info", "فیلد ' " + strFECBZ2 + " ' خالی می باشد", "<spring:message code="message"/>")
                          }
                          else if (DynamicForm_Evaluation_Coefficient.getItem("FECBZ3").getValue() == null)
                          {
                             DynamicForm_Evaluation_Coefficient.getItem("FECBZ3").focusInItem()
                             createDialog("info", "فیلد ' " + strFECBZ3 + " ' خالی می باشد", "<spring:message code="message"/>")
                          }
                          else{
                            createDialog("info", "جمع ضرایب فرمول هفت باید 100 شود", "<spring:message code="message"/>")
                        return;
                          }
                            } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusET").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minQusET").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minQusET").focusInItem();
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("FECRZ").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("FECRZ").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("FECRZ").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreET").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minScoreET").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minScoreET").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreER").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minScoreER").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minScoreER").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusER").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minQusER").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minQusER").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minPreTestEL").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minPreTestEL").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minPreTestEL").focusInItem()
                        return;
                    }else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreEL").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minScoreEL").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minScoreEL").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minPasTestEL").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minPasTestEL").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minPasTestEL").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusEL").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minQusEL").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minQusEL").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreEB").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minScoreEB").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minScoreEB").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minScorePreTestEB").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minScorePreTestEB").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minScorePreTestEB").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusEB").getValue() == null) {
                        var str = DynamicForm_Evaluation_Coefficient.getItem("minQusEB").title
                        createDialog("info", "فیلد ' " + str + " ' خالی می باشد", "<spring:message code="message"/>")
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minQusEB").focusInItem()
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
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            createDialog("info", "اطلاعات با موفقیت ثبت شد", "<spring:message code="message"/>")
        }

    }
