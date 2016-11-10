<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="header.jsp" %>
    <title>Results - PowerUp</title>
    <%--TODO change default title on all pages--%>

</head>
<body>
<header>
    <%@include file="nav.jsp" %>
</header>

<main>
    <div class="container">
        <div class="row filters-row">
            <h3 class="header center orange-text">
                Search
            </h3>

            <div class="row">
                <form id="search-form">
                    <div class="input-field col s6 offset-s3">
                        <input placeholder="Title" type="text" name="name" value="${fn:length(searchedName) > 0 ? searchedName : ""}">
                    </div>
                </form>
            </div>

            <div class="col s6">
                <!-- Nothing here... may be used by future things -->
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
            <div class="col s2">
                <div class="row select-title">
                    Page size
                </div>
                <select class="row select-drop-down" id="pageSizeSelectId" onchange="changePageSize()">
                    <option value="25">25</option>
                    <option value="50">50</option>
                    <option value="100">100</option>
                    <c:if test="${page.pageSize != 25 && page.pageSize != 50 && page.pageSize != 100}">
                        <option value="${page.pageSize}">Other: ${page.pageSize}</option>
                    </c:if>
                </select>
            </div>

        </div>

        <%--RESULTS--%>
        <div class="row">
            <c:choose>
                <%--"No results" notice--%>
                <c:when test="${ page.overAllAmountOfElements == 0 }">
                    <h3 class="center">No results</h3>
                </c:when>
                <c:otherwise>
                    <%--Total games count--%>
                    <ul class="row games-count">
                        <div class="col s6">
                            Games ${(page.pageNumber - 1) * page.pageSize + 1 } -
                                ${(page.pageNumber - 1) * page.pageSize + page.amountOfElements}
                            of ${page.overAllAmountOfElements}
                        </div>
                    </ul>
                </c:otherwise>
            </c:choose>

            <%--Filters collapsible--%>
            <button class="btn waves-effect waves-light right" id="clear-filters" ${hasFilters ? "" : "disabled"}>Clear
                filters <i class="material-icons right">close</i></button>
            <ul class="collapsible" data-collapsible="expandable">
                <li>
                    <div class="collapsible-header ${hasFilters ? " active" : ""}"><i
                            class="material-icons">filter_list</i>Filters
                    </div>
                    <div class="collapsible-body">
                        <%--Filter categories--%>
                        <div class="row">
                            <div class="col s12">
                                <ul class="tabs">
                                    <li class="tab col s3"><a href="#platforms">Plaftorms</a></li>
                                    <li class="tab col s3"><a href="#genres">Genres</a></li>
                                    <li class="tab col s3"><a href="#developers">Developers</a></li>
                                    <li class="tab col s3"><a href="#publishers">Publishers</a></li>
                                </ul>
                            </div>
                            <%--Filter values--%>
                            <div id="platforms" class="col s12 filter">
                                <c:forEach items="${platforms}" var="platform">
                                    <c:choose>
                                        <c:when test="${platform[1]}">
                                            <div class="chip selected" data-filter-type="platform"
                                                 data-value="${platform[0]}">${platform[0]}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="chip" data-filter-type="platform"
                                                 data-value="${platform[0]}">${platform[0]}</div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <div id="genres" class="col s12 filter">
                                <c:forEach items="${genres}" var="genre">
                                    <c:choose>
                                        <c:when test="${genre[1]}">
                                            <div class="chip selected" data-filter-type="genre"
                                                 data-value="${genre[0]}">${genre[0]}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="chip" data-filter-type="genre"
                                                 data-value="${genre[0]}">${genre[0]}</div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <div id="developers" class="col s12 filter">
                                <c:forEach items="${developers}" var="developer">
                                    <c:choose>
                                        <c:when test="${developer[1]}">
                                            <div class="chip selected" data-filter-type="developer"
                                                 data-value="${developer[0]}">${developer[0]}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="chip" data-filter-type="developer"
                                                 data-value="${developer[0]}">${developer[0]}</div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <div id="publishers" class="col s12 filter">
                                <c:forEach items="${publishers}" var="publisher">
                                    <c:choose>
                                        <c:when test="${publisher[1]}">
                                            <div class="chip selected" data-filter-type="publisher"
                                                 data-value="${publisher[0]}">${publisher[0]}</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="chip" data-filter-type="publisher"
                                                 data-value="${publisher[0]}">${publisher[0]}</div>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>

            <%--Results, if any--%>
            <c:if test="${ fn:length(page.data) > 0 }">
                <%--Games list--%>
                <ul class="collection games-list">
                    <c:forEach var="game" items="${page.data}">
                        <li class="collection-item avatar col s12">
                            <div class="col s2 cover-pic-container valign-wrapper">
                                <img class="cover-picture valign"
                                     src="${game.coverPictureUrl}" alt="${game.name}">

                            </div>
                            <div class="col primary-content s7">
                                <p class="title">
                                    <a href="<c:url value="/game?id=${game.id}" />">${game.name}</a>
                                </p>
                                <p class="summary">${game.summary}</p>
                            </div>
                            <div class="col s1 center">
                                <p style="margin-top: 33px;">${game.releaseDate.year}</p>
                            </div>
                            <div class="col s2">
                                <div class="secondary-content">
                                    <c:choose>
                                        <c:when test="${game.avgScore <= 10 && game.avgScore > 0}">
                                            <p class="rating-number center"><b>${game.avgScore}</b></p>
                                            <p class="rating-stars hide-on-small-and-down">
                                                <c:forEach begin="0" end="4" var="i">
                                                    <c:choose>
                                                        <c:when test="${game.avgScore - (i * 2) - 1 < 0}">
                                                            <i class="material-icons">star_border</i>
                                                        </c:when>
                                                        <c:when test="${game.avgScore - (i * 2) - 1 == 0}">
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

                <%--Another total games count--%>
                <ul class="row games-count">
                    <div class="col s6">
                        Games ${(page.pageNumber - 1) * page.pageSize + 1 } -
                            ${(page.pageNumber - 1) * page.pageSize + page.amountOfElements}
                        of ${page.overAllAmountOfElements}
                    </div>
                </ul>

                <%--Pagination--%>
                <div class="row">
                    <ul class="pagination center">
                            <%--Left chevron - only shown when there are > 1 pages --%>
                        <c:if test="${page.totalPages > 1}">
                            <c:choose>
                                <c:when test="${page.pageNumber > 1}">
                                    <li class="waves-effect">
                                        <a href="<c:url value="${changePageUrl}"> <c:param name="pageNumber" value="${page.pageNumber - 1}"/> </c:url>">
                                            <i class="material-icons">chevron_left</i>
                                        </a>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="disabled">
                                        <a href="#!">
                                            <i class="material-icons">chevron_left</i>
                                        </a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                            <%--Page numbers - always shown--%>
                        <c:set var="just_one"
                               value="${(page.pageNumber - 4) <= 0 || page.totalPages <= 10}"/>
                        <c:set var="no_more_prev"
                               value="${(page.pageNumber + 5) > page.totalPages}"/>
                        <c:set var="the_first_ones"
                               value="${(page.pageNumber + 5) < 10}"/>
                        <c:set var="no_more_next"
                               value="${page.totalPages < 10 || (page.pageNumber + 5) >= page.totalPages}"/>
                        <c:forEach var="pageIt"
                                   begin="${just_one ? 1 : no_more_prev ? page.totalPages - 9 : page.pageNumber - 4}"
                                   end="${no_more_next ? page.totalPages : the_first_ones ? 10 : page.pageNumber + 5}">
                            <li class=${pageIt == page.pageNumber ? "active" : "waves-effect"}>
                                <c:choose>
                                    <c:when test="${pageIt == page.pageNumber}">
                                        <a>
                                                ${pageIt}
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value="${changePageUrl}"> <c:param name="pageNumber" value="${pageIt}"/> </c:url>">
                                                ${pageIt}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </c:forEach>
                            <%--Right chevron - only shown if there are > 1 pages--%>
                        <c:if test="${page.totalPages > 1}">
                            <c:choose>
                                <c:when test="${page.pageNumber == page.totalPages}">
                                    <li class="disabled">
                                        <a href="#!">
                                            <i class="material-icons">chevron_right</i>
                                        </a>
                                    </li>
                                </c:when>
                                <c:otherwise>
                                    <li class="waves-effect">
                                        <a href="<c:url value="${changePageUrl}"> <c:param name="pageNumber" value="${page.pageNumber + 1}"/> </c:url>">
                                            <i class="material-icons">chevron_right</i>
                                        </a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </ul>
                </div>
            </c:if>
        </div>
        <%--END RESULTS--%>
    </div>
</main>

<footer class="page-footer orange">
    <%@include file="footer.jsp" %>
</footer>
<style type="text/css">
    <c:set var="fontSizeStr" value="16px" />
    <c:set var="fontSizeInt" value="16" />
    <c:set var="lineHeight" value="1.5" />
    <c:set var="maxLines" value="3" />

    /* Multi-line clamping adapted from http://codepen.io/martinwolf/pen/qlFdp */
    .summary {
        margin: 5px auto 0 auto !important;
        display: block; /* Fallback for non-webkit */
        display: -webkit-box;
        max-width: 100%;
        font-size: ${fontSizeStr};
        line-height: ${lineHeight};
        -webkit-line-clamp: ${maxLines};
        height: ${fontSizeInt * lineHeight * maxLines}; /* Fallback for non-webkit */
        -webkit-box-orient: vertical;
        overflow: hidden;
        text-overflow: ellipsis;
    }
</style>

<script type="text/javascript">
    /**
     * Tracks currently applied filters.
     */
    var filters = ${filters};

    /**
     * Tracks whether filters have changed. If so, searching will reset page number.
     */
    var filtersChanged = false;

    /*
     * Tracks the entered name.
     */
    var name = "${searchedName}";

    var nameChanged = false;

    $(function () {
        $("#orderSelectId").val("${orderCategory == null ? "name" : orderCategory}");
        $("#orderSelectId").material_select();
        $("#orderBooleanId").val("${orderBoolean == null ? "ascending" : orderBoolean}");
        $("#orderBooleanId").material_select();
        $("#pageSizeSelectId").val("${page.pageSize}");
        $("#pageSizeSelectId").material_select();

        $('.chip').on('click', function (e) {
            var $chip = $(e.target);
            var value = $chip.html();
            if ($chip.hasClass('selected')) {
                removeFilter($chip.data('filter-type'), $chip.data('value'));
                $chip.removeClass('selected');
                search();
                if (filters === {}) {
                    $("#clear-filters").attr('disabled', 'disabled');
                }
            } else {
                addFilter($chip.data('filter-type'), $chip.data('value'));
                $chip.addClass('selected');
                search();
                $("#clear-filters").removeAttr('disabled');
            }
        });

        $("#clear-filters").on('click', function () {
            clearFilters();
            search();
        });

        $("#search-form").on("submit", function(event) {
            event.preventDefault();
            var inputName = $(this).find("input[name='name']").val();
            nameChanged = inputName != name;
            name = inputName;
            search();
        });
    });

    function changeOrderDropDown() {
        var selectedOrderCategory = document.getElementById("orderSelectId");
        var selectedOrderBoolean = document.getElementById("orderBooleanId");
        var strOrderCategory = selectedOrderCategory.options[selectedOrderCategory.selectedIndex].value;
        var strOrderBoolean = selectedOrderBoolean.options[selectedOrderBoolean.selectedIndex].value;
        var url = "<c:url value="${changeOrderUrl}"/>";
        var hasQuery = url.indexOf("?") != -1;
        url += (hasQuery ? "&" : "?") + "orderCategory=" + strOrderCategory + "&orderBoolean=" + strOrderBoolean;
        window.location = url;
    }

    function changePageSize() {
        var selectedPageSize = document.getElementById("pageSizeSelectId");
        var pageSize = selectedPageSize.options[selectedPageSize.selectedIndex].value;
        var url = "<c:url value="${changePageSizeUrl}"/>";
        var hasQuery = url.indexOf("?") != -1;
        url += (hasQuery ? "&" : "?") + "pageSize=" + pageSize;
        window.location = url;
    }

    /**
     * Adds the specified filter.
     *
     * @param category The category in which the value is.
     * @param value The value to add.
     * @return The new filters object, so you can chain this call.
     */
    function addFilter(category, value) {
        if (!category || !value) {
            return;
        }
        if (!filters.hasOwnProperty(category)) {
            filters[category] = [];
        }
        filters[category].push(value);
        filtersChanged = true;
        return filters;
    }

    /**
     * Removes the specified filter.
     *
     * @param category The category in which the value is.
     * @param value (Optional) The value to remove. If not provided, the entire category will be removed.
     * @return The new filters object, so you can chain this call.
     */
    function removeFilter(category, value) {
        if (filters.hasOwnProperty(category)) {
            if (value) {
                var index = filters[category].indexOf(value);
                if (index !== -1) {
                    if (filters[category].length === 1) {
                        delete filters[category];
                    } else {
                        filters[category].splice(index, 1);
                    }
                }
            } else {
                delete filters[category];
            }
            filtersChanged = true;
        }
        return filters;
    }

    /**
     * Clears all applied filters.
     */
    function clearFilters() {
        filters = {};
        $(".chip.selected").each(function () {
            $(this).removeClass("selected");
        });
        filtersChanged = true;
    }

    /**
     * Reloads the current page with the applied filters and/or title, resetting the page number if necessary. Note that
     * this function is NOT meant to handle changes in page number or sorting parameters.
     */
    function search() {
        var url = decodeURI(window.location.href);
        if (window.location.search) {
            //Change name
            if(nameChanged) {
                if (window.location.search.indexOf("name=") !== -1) {
                    //*? is a non-greedy matcher
                    if(url.search(/name=.*?&/) !== -1) {   //The name is followed by a &, don't drop it
                        url = url.replace(/name=.*?&/, (name === "" ? "" : "name=" + encodeURIComponent(name) + "&"));
                    } else {                                //No & to the right ($ matches end of URL)
                        url = url.replace(/name=.*?\$/, (name === "" ? "" : "name=" + encodeURIComponent(name)));
                    }
                } else {
                    if(name !== "") {
                        url += "&name=" + encodeURIComponent(name);
                    }
                }
            }
            //Change filters
            if(filtersChanged) {
                if (window.location.search.indexOf("filters=") !== -1) {
                    url = url.replace(/filters={.*}/, "filters=" + JSON.stringify(filters));
                } else {
                    url += "&filters=" + JSON.stringify(filters);
                }
            }
            //Remove page number if necessary
            if(filtersChanged || nameChanged) {
                if (window.location.search.indexOf("pageNumber=") !== -1) {
                    url = url.replace(/pageNumber=\d+/, "");
                }
            }
        } else {
            if(filtersChanged) {
                url += "?filters=" + JSON.stringify(filters);
            }
            if(nameChanged && name !== "") {
                url += (filtersChanged ? "&name=" : "?name=") + encodeURIComponent(name);
            }
            //No need to handle page/sorting parameters here
        }
        window.location = encodeURI(url);
    }
</script>
</body>
</html>