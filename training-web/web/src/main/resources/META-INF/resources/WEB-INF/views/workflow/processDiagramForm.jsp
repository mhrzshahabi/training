<%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 1/13/2019
  Time: 3:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%--<script>--%>

	processImage = isc.Img.create({
		width: "100%",
		height: "100%",
		align: "center",
		src: "data:image/jpeg;base64, ${diagramName}",
		overflow: "visible",
		imageType: "center"

	});
	processImage1 = isc.Img.create({
		width: "100%",
		height: "100%",
		align: "center",
		src: "data:image/jpeg;base64, ${diagramName}",
		overflow: "visible",
		imageType: "center"

	});

	var fillScreenWindowsVLayout = isc.VLayout.create({
		layoutMargin: 5,
		membersMargin: 10,
		showEdges: false,
		overflow: "scroll",
		edgeImage: "",
		width: "100%",
		height: "100%",
		alignLayout: "center",
		members: [

			processImage1

		]
	});

	<%--isc.HLayout.create({--%>
	<%--ID: "processConfirmHeaderHLayout",--%>
	<%--width: "100%",--%>
	<%--height: "100%",--%>
	<%--alwaysShowVScrollbar: "true",--%>
	<%--align: "center",--%>
	<%--members: [--%>

	<%--processImage--%>

	<%--]--%>
	<%--});--%>

	var processWindow = isc.Window.create({
		placement: "fillScreen",
		title: " گردش کار",
		autoDraw: false,
		canDragReposition: true,
		canDragResize: true,
		items: [
			fillScreenWindowsVLayout
		]
	});


	var diagramZoomButton = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/view_rtl.png",
		prompt: "بزرگ نمایی تصویر",
		title: "بزرگ نمایی تصویر",
		click: function () {
			processWindow.show();

		}
	});

	var docControls = isc.ToolStrip.create({
		width: "100%", height: 20,
		members: [
			diagramZoomButton


		]
	});

	isc.VLayout.create({
		ID: "processConfirmVLayout",
		layoutMargin: 5,
		membersMargin: 10,
		showEdges: false,
		overflow: "scroll",
		edgeImage: "",
		width: "100%",
		height: "100%",
		alignLayout: "center",
		members: [
			docControls,
			processImage
		]
	});
	
