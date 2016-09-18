<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="header.jsp" %>
    <title>PowerUp</title>
</head>
<body>
<header>
    <%@include file="nav.jsp" %>
</header>

<main>
    <div class="section no-pad-bot" id="index-banner">
        <div class="container">
            <br><br>
            <h1 class="header center orange-text">PowerUp!</h1>
            <div class="row center">
                <h5 class="header col s12 light">Something cool and inspiring about this site</h5>
            </div>
            <div class="row">
                <%--<a href="<c:url value="/results" /> " class="btn-large waves-effect waves-light orange">Turn this into a search2 bar</a>--%>
                <div class="col s12 m8 offset-m2 l6 offset-l3">
                    <form id="search-form">
                        <div class="input-field">
                            <input name="search" type="search" required>
                            <%--<label for="search2"><i class="material-icons">search2</i></label>--%>
                            <i class="material-icons" style="color:black;">search</i>
                        </div>
                    </form>
                </div>
            </div>
            <br><br>

        </div>
    </div>


    <div class="container">
        <div class="section">

            <!--   Icon Section   -->
            <div class="row">
                <div class="col s12 m4">
                    <div class="icon-block">
                        <h2 class="center light-blue-text"><i class="material-icons">flash_on</i></h2>
                        <h5 class="center">Speeds up development</h5>

                        <p class="light">We did most of the heavy lifting for you to provide a default stylings that
                            incorporate our custom components. Additionally, we refined animations and transitions to
                            provide a smoother experience for developers.</p>
                    </div>
                </div>

                <div class="col s12 m4">
                    <div class="icon-block">
                        <h2 class="center light-blue-text"><i class="material-icons">group</i></h2>
                        <h5 class="center">User Experience Focused</h5>

                        <p class="light">By utilizing elements and principles of Material Design, we were able to create a
                            framework that incorporates components and animations that provide more feedback to users.
                            Additionally, a single underlying responsive system across all platforms allow for a more
                            unified user experience.</p>
                    </div>
                </div>

                <div class="col s12 m4">
                    <div class="icon-block">
                        <h2 class="center light-blue-text"><i class="material-icons">settings</i></h2>
                        <h5 class="center">Easy to work with</h5>

                        <p class="light">We have provided detailed documentation as well as specific code examples to help
                            new users get started. We are also always open to feedback and can answer any questions a user
                            may have about Materialize.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="page-footer orange">
    <%@include file="footer.jsp" %>
</footer>
<script type="text/javascript" src="<c:url value="/js/index.js" />"></script>
</body>
</html>
