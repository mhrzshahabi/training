<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    <%
        final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    %>


    var MSG_textEditorValue = "";

    var MSG_sendTypesItems = [];
    var MSG_msgContent = {};
    var MSG_attachFiles = [];
    var MSG_userType = "";
    var MSG_classID;
    //data from API
    var MSG_msgs = [
        { id: 1, title: '001', text: 'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است، چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است، و برای شرایط فعلی تکنولوژی مورد نیاز، و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد، کتابهای زیادی در شصت و سه درصد گذشته حال و آینده، شناخت فراوان جامعه و متخصصان را می طلبد، تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی، و فرهنگ پیشرو در زبان فارسی ایجاد کرد، در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها، و شرایط سخت تایپ به پایان رسد و زمان مورد نیاز شامل حروفچینی دستاوردهای اصلی، و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.' },
        { id: 2, title: '002', text: 'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است،' },
        { id: 3, title: '003', text: 'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است،' },
        { id: 4, title: '004', text: 'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ، و با استفاده از طراحان گرافیک است،' },
    ]

    var sendMessageFunc;

    var ErrorMsg=isc.Label.create({
        height: 30,
        padding: 10,
        width:"100%",
        align: "center",
        styleName: 'MSG-type-label-error',

        valign: "center",
        wrap: false,
        contents: ""
    })


    var MSG_selectDefaultMsgsBtn = isc.IButton.create({
        autoDraw:false,
        baseStyle: 'MSG-btn-orange',
        title:"استفاده از پیش فرض ها", width:150,
        click: function () {
            MSG_WindowDefaultMsg.show();
        },
        mouseOver: function(){
            this.baseStyle = 'MSG-btn-white';
        },
        mouseOut: function(){
            this.baseStyle = 'MSG-btn-orange';
        },

    });

    var MSG_selectDefaultMsgBtn = isc.IButton.create({
        autoDraw:false,
        baseStyle: 'MSG-btn-orange',
        title:"بازیابی متن پیش فرض", width:150,
        click: function () {
            MSG_contentEditor.setValue(MSG_textEditorValue);
        },
        mouseOver: function(){
            this.baseStyle = 'MSG-btn-white';
        },
        mouseOut: function(){
            this.baseStyle = 'MSG-btn-orange';
        },

    });

    var MSG_saveDefaultMsgBtn = isc.IButton.create({
        autoDraw:false,
        baseStyle: 'MSG-btn-white',
        title:"ذخیره به عنوان پیش فرض", width:150,
        click:"MSG_saveDefaultMsg()",
        mouseOver: function(){
            this.baseStyle = 'MSG-btn-orange';
        },
        mouseOut: function(){
            this.baseStyle = 'MSG-btn-white';
        },
    });



    var MSG_attachMsgBtn =  isc.HTMLFlow.create({
        align: "center",
        contents: "<form class=\"MSG-uploadButton\" method=\"POST\" id=\"form\" action=\"\" enctype=\"multipart/form-data\"><label for=\"MSG-file-upload\" class=\"MSG-custom-file-upload\"><img src='static/img/msg/attach.png'> فایل پیوست </label><input id=\"MSG-file-upload\" type=\"file\" name=\"file[]\" name=\"attachPic\" onchange=\"MSG_upload()\" /></form>"
    });

    var MSG_defaultMsgCollapse = isc.SectionStack.create({
        sections:[],
        visibilityMode:"multiple",
        animateSections:true,
        autoSize: false,
        styleName: "MSG-sections",
        width:"100%",
        height: "100%",
        overflow: "auto",
    })


    var MSG_WindowDefaultMsg = isc.Window.create({
        placement: "center",
        title: "پیام های پیشفرض",
        overflow: "auto",
        width: 650,
        height: 500,
        autoSize: false,
        items: [
            MSG_defaultMsgCollapse
        ],
        closeClick: function () {
            this.close();
        },
    });






    var OAUserRestDataSource = isc.RestDataSource.create({
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        fields:
            [
                {name: "id"},
                {name: "firstName"},
                {name: "lastName"},
                {name: "nationalCode"},
                {name: "username"},
                {name: "version"}
            ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        transformResponse: function (dsResponse, dsRequest, data) {
            return this.Super("transformResponse", arguments);
        },
        fetchDataURL: "<spring:url value="/api/oauth/users/spec-list"/>"
    });





    var MSG_selectUsersForm = isc.DynamicForm.create({
        width: "80%",
        fields: [
            {
                name: "multipleSelect", title: "افزودن مخاطب", editorType: "SelectItem",
                displayField: "firstName", valueField: "id",
                pickListWidth: 800,
                autoFetchData: false,
                filterOnKeypress: true,
                //optionDataSource: OAUserRestDataSource,
                pickListFields: [
                    {name: "firstName", width: "10%", align: "center"},
                    {name: "lastName", width: "10%", align: "center"},
                ],
                multiple: true,

                pickListProperties: {
                    showFilterEditor:true,
                },
                changed: function (form, item, value) {
                    /*if(MSG_selectUsersForm.getItem("multipleSelect").getValue() == null){
                        MSG_sendMsgForm.disable();
                    }else{
                        MSG_sendMsgForm.enable();
                    }*/
                }
            }
        ]
    })


    function MSG_getMessageTypes(){
        MSG_sendTypesItems = [];
        MSG_msgContent.type = [];

        return  MSG_messageTypes = isc.HLayout.create({
            width: "80%",
            height: "100%",
            membersMargin: 5,
            alignment: 'center',
            align: "center",
            vAlign: "center",
            layoutTopMargin: 5,
            members: [
                //MSG_getSelectMessageType('cartable', '<spring:message code="send.message.cartable"/>',true),
                MSG_getSelectMessageType('sms', '<spring:message code="send.message.sms"/>', true),
                /*MSG_getSelectMessageType('email', '<spring:message code="send.message.email"/>'),
              MSG_getSelectMessageType('whatsapp', '<spring:message code="send.message.whatsapp"/>'),
              MSG_getSelectMessageType('telegram', '<spring:message code="send.message.telegram"/>'),*/
            ]
        })
    }

    MSG_sendMsgForm = isc.IButton.create({
        autoDraw:false,
        baseStyle: 'MSG-btn-orange',
        border: 'none',
        title:"ارســـــــال", width:120,
        click: function () {
            if(MSG_selectUsersForm.getItem("multipleSelect").getValue()==null || MSG_selectUsersForm.getItem("multipleSelect").getValue().length == 0){
                var ERROR = isc.Dialog.create({
                    message:"حداقل یک مخاطب انتخاب نمایید",
                    icon: "[SKIN]say.png",
                    title:  "متن خطا"
                });

                setTimeout(function () {
                    ERROR.close();
                }, 2000);

                return;

            }
            MSG_sendMsg(MSG_contentEditor.getValue())
        }
    });

    MSG_Cancel_MsgForm = isc.IButton.create({
        autoDraw:false,
        baseStyle: 'MSG-btn-white',
        title:"انصراف", width:120,
        click: function () {
            MSG_initMSG()
            MSG_Window_MSG_Main.close()
        },
        mouseOver: function(){
            this.baseStyle = 'MSG-btn-orange';
        },
        mouseOut: function(){
            this.baseStyle = 'MSG-btn-white';
        }
    });

    var MSG_action_Btns_HLayout = isc.HLayout.create({
        width: "80%",
        membersMargin:5,
        alignment: 'center',
        align: "center",
        vAlign: "center",
        layoutTopMargin: 20,
        members: [
            MSG_sendMsgForm,
            MSG_Cancel_MsgForm

        ]
    });



    var MSG_repeatOptions = isc.DynamicForm.create({
        width: 400,
        wrapItemTitles:false,
        numCols: 4,
        fields: [
            {
                name: "maxRepeat", title: "حداکثر تعداد تکرار", type: "select",
                wrapHintText: false,
                value:"0",
                valueMap:
                    {
                        "10000" : "نامحدود",
                        "0" : "عدم تکرار",
                        "1" : "یکبار",
                        "2" : "دوبار",
                        "3" : "سه بار",
                        "4" : "چهار بار",
                        "5" : "پنج بار",
                        "6" : "شش بار",
                        "7" : "هفت بار",
                        "8" : "هشت بار",
                        "9" : "نه بار",
                        "10" : "ده بار",
                    },
            },
            {
                name: "timeBMessages", title: "فاصله زمانی بین پیام ها", type: "select",
                wrapHintText: false,
                value:"1",
                valueMap: {
                    "1" : "هر روز",
                    "2" : "هر دو روز یکبار",
                    "3" : "هر سه روز یکبار",
                },
            }
        ]
    });


    var MSG_main_layout = isc.VLayout.create({
        width: "100%",
        height: 400,
        vAlign: "center",
        autoDraw: false,
        marginTop:30,
        defaultLayoutAlign: "center",
        members:[
            isc.DynamicForm.create({
                titleAlign: "center",
                showInlineErrors: true,
                showErrorText: false,
                width: "100%",
                align: "right",
                numCols: 6,
                fields: [
                    {
                        colSpan: 2,
                        type: "header",
                        defaultValue: "      برای تغییر نوع پیامک از منوی زیر نوع پیام را انتخاب کنید"
                    },
                    {
                        ID:"messageType",
                        name:"messageType",
                        title: " نوع پیامک :",
                        colSpan: 2,
                        // optionDataSource: RestDataSource_Messages,
                        autoFetchData: false,
                        displayField: "title",
                        pickListWidth: 500,
                        valueField: "description",
                        textAlign: "center",
                        pickListFields: [
                            {
                                name: "title",
                                title: "<spring:message code="title"/>",
                                filterOperator: "iContains",
                                autoFitWidth: true
                            }
                        ],
                        changed: function (form, item, value) {
                            MSG_textEditorValue = value;
                            MSG_contentEditor.setValue(MSG_textEditorValue);
                        },

                    }

                ]
            }),
            isc.VLayout.create({
                width: "90%",
                height: "100%",
                membersMargin:5,
                alignment: 'center',
                align: "center",
                vAlign: "center",
                layoutTopMargin: 20,
                members: [
                    isc.RichTextEditor.create({
                        autoDraw:false,
                        ID:"MSG_contentEditor",
                        height:200,
                        styleName: 'MSG-RichTextEditor',
                        overflow:"hidden",
                        align: 'right',
                        textAlign: 'right',
                        direction: 'rtl',
                        layoutAlign: 'right',
                        canDragResize:true,
                        disabled:true,
                        controlGroups:["fontControls", "formatControls", "styleControls", "colorControls", "bulletControls"],
                        styleControls: ["alignRight", "boldSelection"],
                        value:MSG_textEditorValue
                    }),
                    isc.DynamicForm.create({
                        ID: "linkFormMLanding",
                        width: "100%",
                        fields: [
                            { name: "link", title: "لینک کلاس مجازی : ", controlStyle : "inputRTL",cellStyle  : "inputRTL",showRTL :false, validateOnExit: true,
                                validators: [TrValidators.WebsiteValidate],},
                            { name: "messageType",hidden: true}
                        ]
                    }),
                ],

            }),
            // isc.HLayout.create({
            //     ID:'MSGAttachContainer',
            //     width: "80%",
            //     height: "100%",
            //     membersMargin:10,
            //     layoutTopMargin: 10,
            //     alignment: 'right',
            //     align: "right",
            //     vAlign: "center",
            //     members: [
            //
            //     ]
            // }),
            isc.HLayout.create({
                width: "80%",
                height: "100%",
                membersMargin:5,
                alignment: 'center',
                align: "right",
                vAlign: "center",
                layoutTopMargin: 10,
                members: [
                    //MSG_selectDefaultMsgBtn,

                    isc.HLayout.create({
                        width: "80%",
                        height: "100%",
                        alignment: 'left',
                        align: "right",
                        vAlign: "center",
                        layoutTopMargin: -10,
                        members: [
                            MSG_repeatOptions
                        ]
                    })
                    /*MSG_selectDefaultMsgBtn, MSG_saveDefaultMsgBtn,
                    isc.HLayout.create({
                        width: "80%",
                        height: "100%",
                        alignment: 'left',
                        align: "left",
                        vAlign: "center",
                        members: [
                            MSG_attachMsgBtn
                        ]
                    })*/
                ]
            }),
            isc.LayoutSpacer.create({height: 20}),
            isc.HTMLFlow.create({
                align: "center",
                layoutTopMargin: 20,
                width:"80%",
                contents: "<hr/>"
            }),
            isc.LayoutSpacer.create({height: 20}),
            isc.Label.create({
                height: 30,
                padding: 10,
                width:"100%",
                align: "center",
                styleName: 'MSG-type-label',
                valign: "center",
                wrap: false,
                contents: "ارســـــال از طریق"
            }),
            MSG_getMessageTypes(),
            isc.HLayout.create({
                width: "80%",
                membersMargin:5,
                alignment: 'center',
                align: "center",
                vAlign: "center",
                layoutTopMargin: 20,
                members: [
                    MSG_selectUsersForm
                ]
            }),
            ErrorMsg
            ,
            isc.LayoutSpacer.create({height: 20}),
            MSG_action_Btns_HLayout
        ]
    });




    /////////////////////////////////////////Functions

    function MSG_upload() {
        isFileAttached = true;
        var upload = document.getElementById('MSG-file-upload');
        var file = upload.files[0];
        MSG_attachFiles.push(file);
        MSGAttachContainer.addMember(MSG_getAttachedFile(file.name))
    }


    function MSG_saveDefaultMsg(){
        if(MSG_contentEditor.getValue().length ==0){
            var ERROR = isc.Dialog.create({
                message:"متن پیام را وارد نمایید",
                icon: "[SKIN]stop.png",
                title:  "متن پیام"
            });
            setTimeout(function () {
                ERROR.close();
            }, 1000);
            return;
        }

        isc.askForValue("عنوان پیام را وارد نمایید",
            function (value) {
                if (value !== "" && value !== null && value !== undefined) {
                    let id = MSG_msgs.length +1;
                    MSG_msgs.push({
                        id: id, title: value, text: MSG_contentEditor.getValue()
                    })
                    MSG_setMsgItems();

                }
            });

    }

    function  MSG_addDefaultContent(content) {
        MSG_contentEditor.setValue(content);
        MSG_WindowDefaultMsg.close()
    }

    function MSG_getSelectMsgBtn(content){
        return  isc.IButton.create({
            autoDraw:false,
            layoutRightMargin: 20,
            icon: '../static/img/msg/check-white.svg',
            baseStyle: 'MSG-btn-orange',
            title:"انتخاب", width:80,
            click: function () {
                MSG_addDefaultContent(content)
            },
            mouseOver: function(){
                this.setIcon('../static/img/msg/check-orange.svg');
                this.baseStyle = 'MSG-btn-white';
            },
            mouseOut: function(){
                this.setIcon('../static/img/msg/check-white.svg');
                this.baseStyle = 'MSG-btn-orange';
            },
        })
    }

    function MSG_getShowMsgBtn(i){
        return isc.IButton.create({
            autoDraw:false,
            baseStyle: 'MSG-btn-white',
            icon: '../static/img/msg/eye-orange.svg',
            layoutRightMargin: 20,
            title:"مشاهده", width:80,
            iconWidth: 12,
            iconHeight: 12,
            click: function () {
                this.setTitle(this.title == 'مشاهده' ? 'بستن'   : 'مشاهده');

                if(MSG_defaultMsgCollapse.sectionIsExpanded(i)){
                    MSG_defaultMsgCollapse.collapseSection(i);
                    this.setIcon('../static/img/msg/eye-white.svg');

                }else {
                    this.setIcon('../static/img/msg/close-white.svg');
                    MSG_defaultMsgCollapse.expandSection(i);
                }
            },
            mouseOver: function(){
                if(this.title == 'مشاهده')
                    this.setIcon('../static/img/msg/eye-white.svg');
                else
                    this.setIcon('../static/img/msg/close-white.svg');
                this.baseStyle = 'MSG-btn-orange';
            },
            mouseOut: function(){
                if(this.title == 'مشاهده')
                    this.setIcon('../static/img/msg/eye-orange.svg');
                else
                    this.setIcon('../static/img/msg/close-orange.svg');
                this.baseStyle = 'MSG-btn-white';
            }
        })
    }



    function selectSendMessageType(item){
        var itemID = item.parentElement.id;
        item.parentElement.classList.toggle('MSG-select-icon')
        var finded = MSG_sendTypesItems.findIndex(function (item) {
            return item == itemID;
        })
        if(finded == -1){
            MSG_sendTypesItems.push(itemID)
        }else{
            MSG_sendTypesItems.splice(finded, 1);
        }

        MSG_msgContent.type = MSG_sendTypesItems;
    }
    function stripHtml(html){
        var tmp = document.createElement("DIV");
        tmp.innerHTML = html;
        return tmp.textContent || tmp.innerText || "";
    }


    function MSG_sendMsg(html){

        if(linkFormMLanding.getItem('link').required && (!linkFormMLanding.getItem('link').getValue() || linkFormMLanding.getItem('link').getValue().trim() == '' || !linkFormMLanding.getItem('link').isValid())){
            var ERROR = isc.Dialog.create({
                message:"لینک را وارد نمایید",
                icon: "[SKIN]stop.png",
                title:  "لینک"
            });
            setTimeout(function () {
                ERROR.close();
            }, 1000);
            return;
        }

        if(MSG_selectUsersForm.getItem('multipleSelect').getValue() == undefined || MSG_selectUsersForm.getItem('multipleSelect').getValue() == null){
            var ERROR = isc.Dialog.create({
                message:"افراد را انتخاب نمایید",
                icon: "[SKIN]stop.png",
                title:  "انتخاب افراد"
            });
            setTimeout(function () {
                ERROR.close();
            }, 2000);
            return;
        }

        if(html.length ==0){
            var ERROR = isc.Dialog.create({
                message:"متن پیام را وارد نمایید",
                icon: "[SKIN]stop.png",
                title:  "متن پیام"
            });
            setTimeout(function () {
                ERROR.close();
            }, 2000);
            return;
        }


        if(MSG_msgContent.type == undefined || MSG_msgContent.type.length == 0){
            var ERROR = isc.Dialog.create({
                message:"نوع ارسال پیام را انتخاب نمایید",
                icon: "[SKIN]stop.png",
                title:  "متن پیام"
            });
            setTimeout(function () {
                ERROR.close();
            }, 2000);
            return;
        }


        if(!MSG_msgContent.type.some(p => p == 'MSG_messageType_sms')){
            var ERROR = isc.Dialog.create({
                message:"نوع ارسال پیامک انتخاب نشده است",
                icon: "[SKIN]stop.png",
                title:  "متن پیام"
            });
            setTimeout(function () {
                ERROR.close();
            }, 2000);
            return;
        }

        MSG_msgContent.users = MSG_selectUsersForm.getItem('multipleSelect').getValue();
        MSG_msgContent.files = MSG_attachFiles;

        MSG_msgContent.text = stripHtml(html);
        MSG_msgContent.html = html;

        sendMessageFunc();



    }



    function  MSG_setMsgItems() {
        var MSG_msgItems = [];
        for (let i = 0; i < MSG_msgs.length; i++) {
            var MSG_textDefaultMsg = isc.HTMLFlow.create({
                height: 100,
                overflow: "auto",
                width: "100%",
                styleName: "MSG-htmlFlow",
                align: "right",
                contents: MSG_msgs[i].text
            })
            item = {items: MSG_textDefaultMsg, title: MSG_msgs[i].title, controls: [], expanded: false};
            item.controls.push(MSG_getSelectMsgBtn(MSG_msgs[i].text, MSG_msgs[i].id));
            item.controls.push(MSG_getShowMsgBtn(i));
            MSG_msgItems.push(item)
        }
        MSG_defaultMsgCollapse.children = []
        MSG_defaultMsgCollapse.sections.clear()
        MSG_defaultMsgCollapse.members.clear()
        MSG_defaultMsgCollapse.reflowNow()
        MSG_defaultMsgCollapse.addSections(MSG_msgItems)
    }

    MSG_setMsgItems();




    function MSG_removeAttach(id){
        var finded = MSGAttachContainer.members.find(function (item){
            return item.ID == id.parentElement.id
        })
        MSGAttachContainer.removeMember(finded)
    }

    function truncate(source, size) {
        return source.length > size ? source.slice(0, size - 1) + "…" : source;
    }

    function MSG_getAttachedFile(id) {
        attachFileID = "MSG-attach-"+id;
        var htmlFlow = isc.HTMLFlow.create({
            ID: attachFileID,
            height: 30,
            overflow: "unset",
            maxWidth: 120,
            align: "right",
            contents: "<div class='MSG-attach-container' id='"+attachFileID+"' ><img class='MSG-attach-remove' src='static/img/msg/close-white.svg' onclick='MSG_removeAttach(this)' ><span>"+truncate(id, 8)+"</span><img class='MSG-attach-assign' src='static/img/msg/attach.png' ></div>"
        })

        return htmlFlow;
    }

    function MSG_getSelectMessageType(messageTypeID, faName, isEnable) {
        var MSG_typeHtmlFlow = isc.HTMLFlow.create({
            ID: "MSG_messageType_"+messageTypeID,
            height: 115,
            overflow: "auto",
            width: 100,
            align: "right",
            contents: ""
        })
        var contentEnable = "<div class='MSG-type-container MSG-select-icon'  id='MSG_messageType_"+messageTypeID+"' ><img class='MSG-type-icon' src='static/img/msg/"+messageTypeID+".png' onclick='selectSendMessageType(this)' ><span class='MSG-type-title'>"+faName+"</span></div>";
        var contentDisable = "<div class='MSG-type-container-disable'  id='MSG_messageType_"+messageTypeID+"' ><img class='MSG-type-icon' src='static/img/msg/"+messageTypeID+".png'  ><span class='MSG-type-title'>"+faName+"</span></div>";
        MSG_typeHtmlFlow.setContents(isEnable ? contentEnable : contentDisable);
        MSG_sendTypesItems.push('MSG_messageType_sms');
        MSG_msgContent.type = MSG_sendTypesItems;


        return MSG_typeHtmlFlow;
    }


    function MSG_initMSG(){
        MSG_Window_MSG_Main.clear()
        MSG_main_layout.members[0].getField("messageType").clearValue();
        MSG_contentEditor.setValue('');
        linkFormMLanding.getItem('link').setValue('');
        linkFormMLanding.getItem('link').setRequired(false);
        linkFormMLanding.getItem('link').disable();
        //MSGAttachContainer.removeMembers(MSGAttachContainer.getMembers());
        MSG_selectUsersForm.clearValues()
        MSG_sendTypesItems = [];
        MSG_msgContent = {};
        MSG_attachFiles = [];


    }

    function MSG_toggleMessageType(messageTypeID, isEnable){
        var selectType = 'MSG_messageType_'+messageTypeID;
        setTimeout(function(){
            var c = window[selectType].contents;
            var joinText = isEnable ? 'MSG-type-container': 'MSG-type-container-disable';
            var cr = c.split("MSG-type-container").join(joinText);
            var cr2 = cr.split('onclick=\'selectSendMessageType(this)\'').join('');
            window[selectType].setContents(isEnable ? cr : cr2)
        },1000)

    }


    var MSG_Window_MSG_Main = isc.Window.create({
        placement: "center",
        title:  "ارسال پیام" ,
        overflow: "auto",
        width: 900,
        height: 760,
        isModal: false,
        autoDraw: false,
        autoSize: false,
        items: [
            MSG_main_layout
        ],
        closeClick: function () {
            MSG_initMSG()
            this.clear()
            this.close();
        },
    });

    /*----------------------------------setDisable-----------------------------*/

    // MSG_sendMsgForm.setDisabled(true); // true == enable  false == disable
    // MSG_toggleMessageType('sms', true)   // true == enable  false == disable
