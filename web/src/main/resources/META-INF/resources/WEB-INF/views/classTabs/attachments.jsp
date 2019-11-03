<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>


    isc.DynamicForm.create({
        autoDraw: false,
        ID: "uploadForm", width: 300,
        // dataSource: mediaLibrary,
        fields: [
            { name: "title", required: true },
            { name: "file", type: "xml", multiple:false, hint: "Maximum file size is 5 MiB" },
            { title: "Save", type: "button",
                click: function () {
                    this.form.saveData("if(dsResponse.status>=0) uploadForm.editNewRecord()");
                }
            }
        ]
    });

    isc.DynamicForm.create({
        autoDraw: false,
        ID: "searchForm",
        width: "100%",
        numCols: 3,
        colWidths: [60, 200, "*"],
        saveOnEnter:true,
        fields: [
            { name: "title", title: "Title", type: "text", width: "*" },
            { name: "search", title: "Search", type: "SubmitItem",
                startRow: false, endRow: false
            }
        ],
        submit : function () {
            mediaListGrid.fetchData(this.getValuesAsCriteria(), null, {textMatchStyle:"substring"});
        }
    });

    isc.ListGrid.create({
        autoDraw: false,
        ID: "mediaListGrid",
        width: "100%",
        height: 224,
        alternateRecordStyles: true,
        // dataSource: mediaLibrary,
        autoFetchData: true
    });

    isc.VLayout.create({
        autoDraw: false,
        ID:"mainLayout",
        width:500,
        height:250,
        members:[searchForm, mediaListGrid]
    });

    isc.HStack.create({
        width:"100%",
        membersMargin: 10,
        members:[uploadForm, mainLayout]
    });






    //</script>