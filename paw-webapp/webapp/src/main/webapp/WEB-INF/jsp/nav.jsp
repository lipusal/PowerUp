<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<nav class="light-blue lighten-1" role="navigation">
    <div class="nav-wrapper container">

        <a id="logo-container" href="<c:url value="/" />" class="brand-logo">Logo</a>

        <ul class="right hide-on-med-and-down">
            <li><a href="<c:url value="/results" /> "><i class="material-icons">search</i></a></li>
            <li><a href="#!"><i class="material-icons">person_outline</i></a></li>
            <li><a href="#!"><i class="material-icons">person</i></a></li>
            <%--TODO change to full person icon when logged in (or use an icon)--%>
        </ul>

        <ul id="nav-mobile" class="side-nav black-text">
            <li><a href="<c:url value="/results" /> "><i class="material-icons">search</i>Search</a></li>
            <li><a href="#!"><i class="material-icons">person_outline</i>Log in</a></li>
            <li><a href="#!"><i class="material-icons">person</i>Profile</a></li>
        </ul>

        <a href="#" data-activates="nav-mobile" class="button-collapse"><i class="material-icons">menu</i></a>

    </div>
</nav>