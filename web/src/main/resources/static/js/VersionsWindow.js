isc.defineClass("VersionsWindow", isc.Window);
isc.VersionsWindow.addProperties({
    width: "50%", isModal: true,
    autoCenter: true,
    autoDraw: true,
    title:"امکانات نسخه جدید",
    initWidget: function () {
        this.Super("initWidget", arguments);
        this.pageLoader =isc.HTMLFlow.create({
                autoDraw:false,
                width: "100%",height:"100%",
                // contentsURL: "static/js/versions.html"
                contentsURL: "js/versions.html"
             })
        this.addItems(this.pageLoader)
    }
});
