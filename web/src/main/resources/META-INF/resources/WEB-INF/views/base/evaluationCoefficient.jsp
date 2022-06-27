<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

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
                value:"<span style='font-size:14px;color:blue'>1- فرمول ارزیابی مدرس بعد از تدریس دوره = (نمره ارزیابی فراگیران به مدرس) * Z2 + (نمره ارزیابی مسئول آموزش به مدرس) * Z1</span>"
            },
            {
                width: "200",
              //  hint: "%",
              //  showHintInField:true,
                mask: "###",
                name: "z1",
                title: "ضریب نمره ارزیابی مسئول آموزش به مدرس &nbsp;(Z1)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }

                }
            },
            , {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "z2",
                title: "ضریب نمره ارزیابی فراگیران به مدرس &nbsp;(Z2)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               // hint: "%",
                mask: "###",
                name: "minScoreET",
                title: "حد قبولی نمره ارزیابی مدرس",
                change: function (item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "minQusET",
                title: "حداقل تعداد پرسشنامه های تکمیل شده&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
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
                value: "<p style='font-size:14px;color:blue'>2- فرمول ارزیابی واکنشی کلاس = (نمره ارزیابی فراگیران به امکانات و سازماندهی)* Z4+(نمره ارزیابی دوره توسط مدرس)*Z3 +(نمره ارزیابی فراگیران به مدرس)*Z2 +(نمره ارزیابی فراگیران به محتوای دوره)*Z1</p>"
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "z3",
                title: "ضریب نمره ارزیابی فراگیران به محتوای دوره &nbsp;(Z1)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "z4",
                title: "ضریب نمره ارزیابی فراگیران به مدرس&nbsp;(Z2)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "z5",
                title: "ضریب نمره ارزیابی دوره توسط مدرس&nbsp;(Z3)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "z6",
                title: "ضریب نمره ارزیابی فراگیران به امکانات و سازماندهی&nbsp;(Z4)&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                type: "integer",
               // hint: "%",
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
              ////  hint: "%",
                mask: "###",
                name: "minQusER",
                title: "حداقل تعداد پرسشنامه های تکمیل شده&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
//=================================================================================================
            {type: "RowSpacerItem"},
            {type: "BlurbItem",
                value:"<p style='font-size:14px;color:blue'> 3- فرمول ارزیابی یادگیری کلاس</p>"
            },

            {
               // hint: "%",
                width: "200",
                mask: "###",
                name: "minPreTestEL",
                title: "حد قبولی یادگیری برای دوره هایی که پیش آزمون دارند",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },

            {
               // hint: "%",
                width: "200",
                 mask: "###",
                name: "minPasTestEL",
                title: "حد قبولی یادگیری برای دوره هایی که پیش آزمون ندارند",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
               // hint: "%",
                width: "200",
                 mask: "###",
                name: "minScoreEL",
                title: "حد قبولی نرخ یادگیری",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "minQusEL",
                title: "حداقل تعداد پرسشنامه های تکمیل شده&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",

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
                value: "<p style='font-size:14px;color:blue'>4- فرمول ارزیابی تغییر رفتار= ( نمره ارزیابی همکاران)*Z4 + ( نمره ارزیابی مسئول آموزش)*Z3 + (ضریب نمره ارزیابی فراگیران)*Z2 +  (ضریب نمره ارزیابی بالا دست)*Z1</p>"
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "z7",
                title: "(ضریب نمره ارزیابی بالا دست)Z1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               //// hint: "%",
                 mask: "###",
                name: "z8",
                title: "(ضریب نمره ارزیابی فراگیران)Z2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                ////hint: "%",
                mask: "###",
                name: "scoreEvaluationRTEB",
                title: "(نمره ارزیابی مسئول آموزش)Z3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                ////hint: "%",
                mask: "###",
                name: "scoreEvaluationPartnersEB",
                title: "(نمره ارزیابی همکاران)Z4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               // hint: "%",
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
               // hint: "%",
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
                ////hint: "%",
                mask: "###",
                name: "minQusEB",
                title: "حداقل تعداد پرسشنامه های تکمیل شده&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },

//==================================================================================================
            {type: "RowSpacerItem"},
            {type: "BlurbItem", value: "<p style='font-size:14px;color:blue'>5- فرمول اثربخشی کلاس _ واکنشی=( نمره ارزیابی واکنشی کلاس)*Z1</p>"},
            {
                width: "200",
              ////  hint: "%",
                mask: "###",
                name: "FECRZ",
                title: "ضریب نمره ارزیابی واکنشی کلاس(Z1)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()

                    }
                }
            }, {
                width: "200",
               // hint: "%",
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
               value: "<p style='font-size:14px;color:blue'>6- فرمول اثربخشی کلاس _ یادگیری=( نمره ارزیابی یادگیری)*Z2 +( نمره ارزیابی واکنشی دوره)*Z1 </p>"

            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "FECLZ1",
                title: "ضریب نمره ارزیابی واکنشی دوره(Z1)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "FECLZ2",
                title: "ضریب نمره ارزیابی یادگیری(Z2)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",

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
                value: "<p style='font-size:14px;color:blue'>7- فرمول اثربخشی کلاس _ رفتاری= ( نمره رفتار)*Z3 + ( نمره ارزیابی یادگیری)*Z2 + ( نمره ارزیابی واکنشی دوره)*Z1</p>"
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "FECBZ1",
                title: "ضریب نمره ارزیابی واکنشی دوره(Z1)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
                ////hint: "%",
                mask: "###",
                name: "FECBZ2",
                title: "ضریب نمره ارزیابی یادگیری(Z2)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
            {
                width: "200",
               //// hint: "%",
                mask: "###",
                name: "FECBZ3",
                title: "ضریب نمره رفتار(Z3)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%",

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
        items: [
            <sec:authorize access="hasAuthority('EvaluationCoefficient_R')">
            DynamicForm_Evaluation_Coefficient,
            </sec:authorize>
            isc.MyHLayoutButtons.create({
                members: [
                    <sec:authorize access="hasAuthority('EvaluationCoefficient_U')">
                    isc.IButtonSave.create({
                        title: "ذخیره",
                        click: function () {
                        DynamicForm_Evaluation_Coefficient.validate();
                        if (!DynamicForm_Evaluation_Coefficient.validate()) {

                            return;
                        }
                        var fields = DynamicForm_Evaluation_Coefficient.getFields();
                        var toUpdate = [];

                        for (let i = 0; i < fields.length; i++) {
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
                                 createDialog("info", "فیلد ' " + str1.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              }
                             else if (DynamicForm_Evaluation_Coefficient.getItem("z2").getValue() == null)
                              {
                                 DynamicForm_Evaluation_Coefficient.getItem("z2").focusInItem()
                                 createDialog("info", "فیلد ' " + str2.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
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
                                 createDialog("info", "فیلد ' " + str3.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              }
                             else if (DynamicForm_Evaluation_Coefficient.getItem("z4").getValue() == null)
                              {
                                 DynamicForm_Evaluation_Coefficient.getItem("z4").focusInItem()
                                 createDialog("info", "فیلد ' " + str4.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              }
                               else if (DynamicForm_Evaluation_Coefficient.getItem("z5").getValue() == null)
                              {
                                 DynamicForm_Evaluation_Coefficient.getItem("z5").focusInItem()
                                 createDialog("info", "فیلد ' " + str5.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              } else if (DynamicForm_Evaluation_Coefficient.getItem("z6").getValue() == null)
                              {
                                 DynamicForm_Evaluation_Coefficient.getItem("z6").focusInItem()
                                 createDialog("info", "فیلد ' " + str6.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              }
                              else{
                               createDialog("info", "جمع ضرایب فرمول دو باید 100 شود", "<spring:message code="message"/>")
                               }

                        } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z7")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z8")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("scoreEvaluationRTEB")) +  parseFloat(DynamicForm_Evaluation_Coefficient.getValue("scoreEvaluationPartnersEB")) != 100) {
                            var str7 = DynamicForm_Evaluation_Coefficient.getItem("z7").title
                            var str8 = DynamicForm_Evaluation_Coefficient.getItem("z8").title
                            var str9 = DynamicForm_Evaluation_Coefficient.getItem("scoreEvaluationRTEB").title
                            var str10 = DynamicForm_Evaluation_Coefficient.getItem("scoreEvaluationPartnersEB").title
                            if (DynamicForm_Evaluation_Coefficient.getItem("z7").getValue() == null)
                              {
                                 DynamicForm_Evaluation_Coefficient.getItem("z7").focusInItem()
                                 createDialog("info", "فیلد ' " + str7.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              } else if (DynamicForm_Evaluation_Coefficient.getItem("z8").getValue() == null)
                              {
                                 DynamicForm_Evaluation_Coefficient.getItem("z8").focusInItem()
                                 createDialog("info", "فیلد ' " + str8.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              }
                            else if (DynamicForm_Evaluation_Coefficient.getItem("scoreEvaluationRTEB").getValue() == null)
                            {
                                DynamicForm_Evaluation_Coefficient.getItem("scoreEvaluationRTEB").focusInItem()
                                createDialog("info", "فیلد ' " + str9.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                            }
                            else if (DynamicForm_Evaluation_Coefficient.getItem("scoreEvaluationPartnersEB").getValue() == null)
                            {
                                DynamicForm_Evaluation_Coefficient.getItem("scoreEvaluationPartnersEB").focusInItem()
                                createDialog("info", "فیلد ' " + str10.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
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
                                 createDialog("info", "فیلد ' " + strFECLZ1.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              } else if (DynamicForm_Evaluation_Coefficient.getItem("FECLZ2").getValue() == null)
                              {
                                 DynamicForm_Evaluation_Coefficient.getItem("FECLZ2").focusInItem()
                                 createDialog("info", "فیلد ' " + strFECLZ2.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
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
                                 createDialog("info", "فیلد ' " + strFECBZ1.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              } else if (DynamicForm_Evaluation_Coefficient.getItem("FECBZ2").getValue() == null)
                              {
                                 DynamicForm_Evaluation_Coefficient.getItem("FECBZ2").focusInItem()
                                 createDialog("info", "فیلد ' " + strFECBZ2.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              }
                              else if (DynamicForm_Evaluation_Coefficient.getItem("FECBZ3").getValue() == null)
                              {
                                 DynamicForm_Evaluation_Coefficient.getItem("FECBZ3").focusInItem()
                                 createDialog("info", "فیلد ' " + strFECBZ3.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                              }
                              else{
                                createDialog("info", "جمع ضرایب فرمول هفت باید 100 شود", "<spring:message code="message"/>")
                            return;
                              }
                                } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusET").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minQusET").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                            DynamicForm_Evaluation_Coefficient.getItem("minQusET").focusInItem();
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("FECRZ").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("FECRZ").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                            createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                            DynamicForm_Evaluation_Coefficient.getItem("FECRZ").focusInItem()
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreET").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minScoreET").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                            DynamicForm_Evaluation_Coefficient.getItem("minScoreET").focusInItem()
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreER").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minScoreER").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                            DynamicForm_Evaluation_Coefficient.getItem("minScoreER").focusInItem()
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusER").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minQusER").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                            DynamicForm_Evaluation_Coefficient.getItem("minQusER").focusInItem()
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("minPreTestEL").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minPreTestEL").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                            DynamicForm_Evaluation_Coefficient.getItem("minPreTestEL").focusInItem()
                            return;
                        }else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreEL").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minScoreEL").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")

                            DynamicForm_Evaluation_Coefficient.getItem("minScoreEL").focusInItem()
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("minPasTestEL").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minPasTestEL").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")

                            DynamicForm_Evaluation_Coefficient.getItem("minPasTestEL").focusInItem()
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusEL").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minQusEL").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")

                            DynamicForm_Evaluation_Coefficient.getItem("minQusEL").focusInItem()
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreEB").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minScoreEB").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")

                            DynamicForm_Evaluation_Coefficient.getItem("minScoreEB").focusInItem()
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("minScorePreTestEB").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minScorePreTestEB").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")

                            DynamicForm_Evaluation_Coefficient.getItem("minScorePreTestEB").focusInItem()
                            return;
                        } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusEB").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minQusEB").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")

                            DynamicForm_Evaluation_Coefficient.getItem("minQusEB").focusInItem()
                            return;
                        }
                         else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreFECR").getValue() == null) {
                            var str = DynamicForm_Evaluation_Coefficient.getItem("minScoreFECR").title
                            createDialog("info", "فیلد ' " + str.replace("%","") + " ' خالی می باشد", "<spring:message code="message"/>")
                            DynamicForm_Evaluation_Coefficient.getItem("minScoreFECR").focusInItem()
                            return;
                        }
                        else {
                            var parameterValue = parameterValueUrl + "/edit-config-list"
                            isc.RPCManager.sendRequest(TrDSRequest(parameterValue, "PUT", JSON.stringify(toUpdate), "callback:show_Result(rpcResponse)"));
                            DynamicForm_Evaluation_Coefficient.refreshFields();
                        }

                    }
                    }),
                    </sec:authorize>
                    <sec:authorize access="hasAuthority('EvaluationCoefficient_R')">
                    isc.IButtonCancel.create({
                        title: "بستن",
                        click: function () {
                            mainTabSet.removeTab(mainTabSet.getSelectedTab())
                        }
                    })
                    </sec:authorize>
                ]
            })
        ]
    })

    function show_Result(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            createDialog("info", "اطلاعات با موفقیت ثبت شد", "<spring:message code="message"/>")
        }

    }
