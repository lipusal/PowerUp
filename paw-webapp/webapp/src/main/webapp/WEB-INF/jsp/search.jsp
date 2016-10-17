<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--<%@ taglib prefix="reload"%> --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="header.jsp" %>
    <title>Results - PowerUp</title>

    <!-- variables -->
    <c:set var="filtersJson" value="${pageContext.request.getParameter('filters')}"/>
    <c:set var="pageSizeUrl" value="${pageContext.request.getParameter('pageSize')}"/>

</head>
<body>
<header>
    <%@include file="nav.jsp" %>
</header>

<main>
    <div class="container">
        <div class="section">
            <h1 class="header center orange-text"><c:if test="${hasFilters}">Avanced </c:if>Search for ${searchedName}</h1>
        </div>
        <div class="row">

            <div class="col s2">

            </div>
        </div>
        <%--<div class="row">--%>
            <%--<div class="col s4 center">--%>
                <%--<h6>name</h6>--%>
            <%--</div>--%>
            <%--<div class="col s6 center">--%>
                <%--<h6>release date</h6>--%>
            <%--</div>--%>
            <%--<div class="col 2 center">--%>
                <%--<h6>avg-rating</h6>--%>
            <%--</div>--%>
        <%--</div>--%>
        <div class="section ">
            <div class="row filters-row">
                <div class="col s6">
                    <%--Games ${(pageNumber - 1) * pageSize + 1 } ---%>
                    <%--${(pageNumber - 1) * pageSize + amountOfElements}--%>
                </div>
                <div class="col s4">
                    <div class="row select-title">
                        Order by
                    </div>
                    <div class="row">
                        <select class="col s5 select-drop-down" id="orderSelectId" onchange="changeOrderDropDown()">
                            <option value="name">Name</option>
                            <option value="release">Release date</option>
                            <option value="rating">Rating</option>
                        </select>
                        <div class="col s1">

                        </div>
                        <select class="col s5 select-drop-down" id="orderBooleanId" onchange="changeOrderDropDown()">
                            <option value="ascending">Ascending</option>
                            <option value="descending">Descending</option>
                        </select>
                        <div class="col s1">

                        </div>
                    </div>
                </div>
                <%--<div class="col s1">--%>

                <%--</div>--%>
                <div class="col s2">
                    <div class="row select-title">
                        Page size
                    </div>
                    <select class="row select-drop-down" id="pageSizeSelectId" onchange="changePageSize()">
                        <option value="25">25</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
                        <c:if test="${pageSizeUrl != null && pageSizeUrl != 25 && pageSizeUrl != 50 && pageSizeUrl != 100}">
                            <option value="${pageSizeUrl}">Other: ${pageSizeUrl}</option>
                        </c:if>
                    </select>
                </div>

            </div>
            <div class="row">
                <c:choose>
                    <c:when test="${ fn:length(page.data) == 0 }">
                        <h3 class="center">No results</h3>
                    </c:when>
                    <c:otherwise>
                        <ul class="row games-count">
                            <div class="col s6">
                                Games ${(page.pageNumber - 1) * page.pageSize + 1 } -
                                    ${(page.pageNumber - 1) * page.pageSize + page.amountOfElements}
                            </div>
                        </ul>
                        <ul class="collection" id="results">
                            <c:forEach var="game" items="${page.data}">
                                <li class="collection-item avatar col s12">
                                    <div class="col s2" style="padding: 0;">
                                        <img src="${game.coverPictureUrl}" alt="${game.name}"
                                             style="max-width: 100%; height: auto;">
                                    </div>
                                    <div class="col primary-content s7">
                                        <p class="title"><a
                                                href="<c:url value="/game?id=${game.id}" />">${game.name}</a></p>
                                        <p>
                                            <c:forEach var="platform" items="${game.platforms}" varStatus="status">
                                                ${platform} <c:if test="${!status.last}"> | </c:if>
                                            </c:forEach>
                                        </p>
                                    </div>
                                    <div class="col s1 center">
                                        <p style="margin-top: 33px;">${game.releaseDate.year}</p>
                                    </div>
                                    <div class="col s2">
                                        <div class="secondary-content">
                                            <c:choose>
                                                <c:when test="${game.avgScore <= 10 && game.avgScore>0}">
                                                    <p class="rating-number center"><b>${game.avgScore}</b></p>
                                                    <p class="rating-stars hide-on-small-and-down">
                                                        <c:forEach begin="0" end="4" var="i">
                                                            <c:choose>
                                                                <c:when test="${game.avgScore-(i*2)-1<0}">
                                                                    <i class="material-icons">star_border</i>
                                                                </c:when>
                                                                <c:when test="${game.avgScore-(i*2)-1==0}">
                                                                    <i class="material-icons">star_half</i>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <i class="material-icons">star</i>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                    </p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p class="rating-number center"><b>unrated</b></p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </li>
                            </c:forEach>
                        </ul>
                        <ul class="row games-count">
                            <div class="col s6">
                                Games ${(page.pageNumber - 1) * page.pageSize + 1 } -
                                    ${(page.pageNumber - 1) * page.pageSize + page.amountOfElements}
                            </div>
                        </ul>
                        <div class="row">
                            <%--<select class="col s2" id="pageSizeSelectId" onchange="changePageSize()">--%>
                                <%--<option value="25">25</option>--%>
                                <%--<option value="50">50</option>--%>
                                <%--<option value="100">100</option>--%>
                            <%--</select>--%>
                            <div class="col s8">
                                <ul class="pagination">
                                    <c:choose>
                                        <c:when test="${page.pageNumber == 1}">
                                            <li class="disabled">
                                                <a href="#!" class="disabled" onclick="return false">
                                                    <i class="material-icons disabled">chevron_left</i>
                                                </a>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="waves-effect">
                                                <a href="#!" onclick="changePage(${page.pageNumber - 1})">
                                                    <i class="material-icons">chevron_left</i>
                                                </a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:set var="just_one"
                                           value="${(page.pageNumber - 4) <= 0 || page.totalPages <= 10}"/>
                                    <c:set var="no_more_prev"
                                           value="${(page.pageNumber + 5) > page.totalPages}"/>
                                    <c:set var="the_first_ones"
                                           value="${(page.pageNumber + 5) < 10}"/>
                                    <c:set var="no_more_next"
                                           value="${page.totalPages < 10 || (page.pageNumber + 5) >= page.totalPages}"/>
                                    <c:forEach var="page_it"
                                               begin="${just_one ? 1 : no_more_prev ? page.totalPages - 9 : page.pageNumber - 4}"
                                               end="${no_more_next ? page.totalPages : the_first_ones ? 10 : page.pageNumber + 5}">
                                        <li class=${page_it == page.pageNumber ? "active" : "waves-effect"}>
                                            <a href="#!" onclick="changePage(${page_it})">
                                                ${page_it}
                                            </a>
                                        </li>
                                    </c:forEach>
                                    <c:choose>
                                        <c:when test="${page.pageNumber == page.totalPages}">
                                            <li class="disabled">
                                                <a href="#!" class="disabled" onclick="return false">
                                                    <i class="material-icons disabled">chevron_right</i>
                                                </a>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="waves-effect">
                                                <a href="#!" onclick="changePage(${page.pageNumber + 1})">
                                                    <i class="material-icons">chevron_right</i>
                                                </a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </ul>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<footer class="page-footer orange">
    <%@include file="footer.jsp" %>
</footer>

<script type="text/javascript" src="<c:url value='/js/advanced-search.js' />"></script>


</body>
</html>

<script>

    $(document).ready(function () {


        <c:choose>
            <c:when test="${orderCategory == null}">
                <c:set var="selectedOrderCategory" value="name"/>
            </c:when>
            <c:otherwise>
                <c:set var="selectedOrderCategory" value="${orderCategory}"/>
            </c:otherwise>
        </c:choose>

        <c:choose>
            <c:when test="${orderBoolean == null}">
                <c:set var="selectedOrderBoolean" value="ascending"/>
            </c:when>
            <c:otherwise>
        <c:set var="selectedOrderBoolean" value="${orderBoolean}"/>
            </c:otherwise>
        </c:choose>

        <c:choose>
            <c:when test="${pageSizeUrl == null}">
                <c:set var="selectedPageSizeUrl" value="25"/>
            </c:when>
            <c:otherwise>
                <c:set var="selectedPageSizeUrl" value="${pageSizeUrl}"/>
            </c:otherwise>
        </c:choose>

        $("#orderBooleanId").val("${selectedOrderBoolean}");
        $("#orderBooleanId").material_select();
        $("#orderSelectId").val("${selectedOrderCategory}");
        $("#orderSelectId").material_select();
        $("#pageSizeSelectId").val("${selectedPageSizeUrl}");
        $("#pageSizeSelectId").material_select();
    });

    function changeOrderDropDown() {

        var selectedOrderCategory = document.getElementById("orderSelectId");
        var selectedOrderBoolean = document.getElementById("orderBooleanId");

        var name;
        var filters;
        var pageSize;

        <c:if test="${searchedName != null && !searchedName.equals('')}">
            name = "${searchedName}";
        </c:if>
        <c:if test="${filtersJson != null && !filtersJson.equals('')}">
            filters = JSON.stringify(${filtersJson});
        </c:if>
        var strOrderCategory = selectedOrderCategory.options[selectedOrderCategory.selectedIndex].value;
        var strOrderBoolean = selectedOrderBoolean.options[selectedOrderBoolean.selectedIndex].value;
        <c:if test="${pageSizeUrl != null && !pageSizeUrl.equals('')}">
            pageSize = "${pageSizeUrl}";
        </c:if>
        reload(name, filters, strOrderCategory, strOrderBoolean, pageSize, null);
    }

    function changePageSize() {
        var selectedPageSize = document.getElementById("pageSizeSelectId");

        var name;
        var filters;
        var orderCategory;
        var orderBoolean;

        <c:if test="${searchedName != null && !searchedName.equals('')}">
            name = "${searchedName}";
        </c:if>
        <c:if test="${filtersJson != null && !filtersJson.equals('')}">
            filters = JSON.stringify(${filtersJson});
        </c:if>
        <c:if test="${orderCategory != null && !orderCategory.equals('')}">
            orderCategory = "${orderCategory}";
        </c:if>
        <c:if test="${orderBoolean != null && !orderBoolean.equals('')}">
            orderBoolean = "${orderBoolean}";
        </c:if>
        <c:if test="${pageSizeUrl != null && !pageSizeUrl.equals('')}">
            pageSize = "${pageSizeUrl}";
        </c:if>
        var pageSize = selectedPageSize.options[selectedPageSize.selectedIndex].value;
        reload(name, filters, orderCategory, orderBoolean, pageSize, pageNumber);
    }


    function reload(name, filters, orderCategory, orderBoolean, pageSize, pageNumber) {
        window.location = create_new_url(name, filters, orderCategory, orderBoolean, pageSize, pageNumber);
    }

    function create_new_url(name, filters, orderCategory, orderBoolean, pageSize, pageNumber) {
        var url = "/search";
        var params = ["name", "filters", "orderCategory", "orderBoolean", "pageSize", "pageNumber"];
        var values = [name, filters, orderCategory, orderBoolean, pageSize, pageNumber];
        return url + create_new_url_recursive(0, params, values, true);
    }


    function create_new_url_recursive(index, params, values, question_mark) {
        if (index == params.length) {
            return "";
        }
        var symbol = question_mark ? "?" : "&";
        var aux = "";
        if (values[index] != null && values[index] != "") {
            question_mark = false;
            aux = symbol + params[index] + "=" + encodeURIComponent(values[index]);
        }
        return aux + create_new_url_recursive(index + 1, params, values, question_mark);
    }

</script>