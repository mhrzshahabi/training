<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<%--<script>--%>

	teacherImage = isc.Img.create({
		height: "130px",
        width: "120px",
		align: "center",
		src: "data:image/jpeg;base64, ${teacherImg}",
		overflow: "hidden",
		imageHeight:130,
		imageWidth:120,
		scrollbarSize: 0,
		imageType: "center"
	});

	isc.VLayout.create({
		ID: "teacherPhotoVLayout",
		layoutMargin: 5,
		membersMargin: 10,
		showEdges: false,
		overflow: "scroll",
		scrollbarSize: 0,
		edgeImage: "",
		width: "100%",
		height: "100%",
		alignLayout: "center",
		members: [
			teacherImage
		]
	});

