<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
//<script>

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
                title: "حد نصاب پرسشنامه ها",
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
                value: "2- فرمول ارزیابی واکنش کلاس = (نمره ارزیابی فراگیران به امکانات و سازماندهی)* Z4+(نمره ارزیابی دوره توسط استاد)*Z3 +(نمره ارزیابی فراگیران به استاد)*Z2 +(نمره ارزیابی فراگیران به محتوای دوره)*Z1"
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
                title: "حد نصاب قابل قبول برای واکنش",
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
                title: "حد نصاب پرسشنامه ها",
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
                title: "حد نصاب پیش آزمون",
                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },

            {
                hint: "%",
                width: "200",
                name: "minPasTestEL",
                title: "حد نصاب پس آزمون",

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
                title: "حد نصاب پرسشنامه ها",

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
                mask: "##",
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
                title: "حد نصاب پرسشنامه ها",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
//==================================================================================================
            {type: "RowSpacerItem"},
            {type: "BlurbItem", value: "5- فرمول اثربخشی کلاس _ واکنش"},
                {
                width: "200",
                hint: "%",
                mask: "###",
                name: "FECRZ",
                title: "ضریب نمره ارزیابی واکنشی کلاس",
                 change: function (form, item, value) {
                      if (value > 100) {
                  item.setValue()

                    }
                }
           },  {
                width: "200",
                hint: "%",
                mask: "###",
                name: "minScoreFECR",
                title: "حد نمره اثر بخشی",
                change: function (form, item, value) {
                if (value > 100) {
                item.setValue()

                }
                }
                },
//=======================================================================================
            {type: "RowSpacerItem"},
            {type: "BlurbItem", value: "6- فرمول اثربخشی کلاس _ یادگیری"},
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "FECLZ1",
                title: "ضریب ارزیابی واکنش دوره",
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
                title: "ضریب نمره ارزیابی یادگیری",

                change: function (form, item, value) {
                    if (value > 100) {
                        item.setValue()
                    }
                }
            },
//================================================================================
            {type: "RowSpacerItem"},
            {type: "BlurbItem", value: "7- فرمول اثربخشی کلاس _ رفتاری"},
            {
                width: "200",
                hint: "%",
                mask: "###",
                name: "FECBZ1",
                title: "ضریب نمره ارزیابی واکنش دوره",

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
                title: "ضریب نمره ارزیابی یادگیری",

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
                title: "ضریب نمره رفتار",

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
                        createDialog("info", "جمع ضرایب فرمول یک باید 100 شود", "<spring:message code="message"/>")
                        return;
                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z3")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z4")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z5")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z6")) != 100) {
                        createDialog("info", "جمع ضرایب فرمول دو باید 100 شود", "<spring:message code="message"/>")
                        return;
                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z7")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("z8")) != 100) {
                        createDialog("info", "جمع ضرایب فرمول چهارباید 100 شود", "<spring:message code="message"/>")
                        return;
                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECLZ1")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECLZ2")) != 100) {
                        createDialog("info", "جمع ضرایب فرمول شش باید 100 شود", "<spring:message code="message"/>")
                        return;
                    } else if (parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECBZ1")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECBZ2")) + parseFloat(DynamicForm_Evaluation_Coefficient.getValue("FECBZ3")) != 100) {
                        createDialog("info", "جمع ضرایب فرمول هفت باید 100 شود", "<spring:message code="message"/>")
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusET").getValue() == null) {
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minQusET").focusInItem()
                        return;
                    }else if (DynamicForm_Evaluation_Coefficient.getItem("FECRZ").getValue() == null) {
                            createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                            DynamicForm_Evaluation_Coefficient.getItem("FECRZ").focusInItem()
                            return;
                            }
                    else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreET").getValue() == null) {
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minScoreET").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreER").getValue() == null) {
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minScoreER").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusER").getValue() == null) {
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minQusER").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minPreTestEL").getValue() == null) {
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minPreTestEL").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minPasTestEL").getValue() == null) {
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minPasTestEL").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusEL").getValue() == null) {
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minQusEL").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minScoreEB").getValue() == null) {
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minScoreEB").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minScorePreTestEB").getValue() == null) {
                        createDialog("info", "فیلد مشخص شده خالی می باشد", "<spring:message code="message"/>")
                        DynamicForm_Evaluation_Coefficient.getItem("minScorePreTestEB").focusInItem()
                        return;
                    } else if (DynamicForm_Evaluation_Coefficient.getItem("minQusEB").getValue() == null) {
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
