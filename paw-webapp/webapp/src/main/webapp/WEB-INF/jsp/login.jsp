<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <%@include file="header.jsp" %>
    <title>Starter Template - PowerUp</title>
</head>
<body>
<header>
    <%@include file="nav.jsp" %>
</header>

<main>
    <div class="section">
        <h1 class="orange-text center">Log In to Your Account</h1>
    </div>

    <div class="section">
        <div class="container row">
            <div class="col s4 offset-s4">
                <div class="card-panel grey lighten-3 col s12">
                    <div class="container">
                        <c:url value="/login" var="postUrl"/>
                        <form:form modelAttribute="loginForm" action="${postUrl}" method="post" class="center-align">
                            <form method="post">
                                <div class='row'>
                                    <div class='col s12'>
                                    </div>
                                </div>

                                <div class='row'>
                                    <div class='input-field col s12'>
                                        <p>Username:</p>
                                        <form:input type="text" path="username"/>
                                        <form:errors path="username" cssClass="formError" element="p" Style="size: 1px"/>
                                    </div>
                                </div>

                                <div class='row'>
                                    <div class='input-field col s12'>
                                        <p>Password:</p>
                                        <form:input type="password" path="password"/>
                                        <form:errors path="password" cssClass="formError" element="p"/>
                                    </div>
                                    <label style='float: right;'>
                                        <a id="forgot-password" class='light-blue-text' href='#!'><b>Forgot Password?</b></a>
                                    </label>
                                </div>

                                <c:if test="${error}" >
                                    <div class="row">
                                        <div class="col s12">
                                            <p class="center"  style="font-size: larger; color:red;">Invalid username/password</p>
                                        </div>
                                    </div>
                                </c:if>

                                <p>
                                    <form:checkbox path="rememberMe" checked="checked" cssStyle="display: none;"/>
                                    <%--<form:label path="rememberMe1">Remember Me</form:label>--%>
                                </p>

                                <div class="row">
                                    <button type='submit' name='btn_login' class='col s12 btn btn-large waves-effect light-blue'>Log In</button>
                                </div>
                            </form>
                        </form:form>
                    </div>
                </div>
            </div>
        </div>
        <h5 class="center"><a href="<c:url value="/register"/>">Create account</a></h5>
    </div>
</main>

<footer class="page-footer orange">
    <%@include file="footer.jsp" %>
</footer>
<script type="text/javascript" src="<c:url value="/js/sweetalert.min.js" />"></script>
<link rel="stylesheet" type="text/css" href="<c:url value="/css/sweetalert.css"/>" />
<script type="text/javascript">
    //Rename links
    $("#forgot-password").on('click', function (event) {
        swal({
                title: "Enter your email",
                type: "input",
                showCancelButton: true,
                closeOnConfirm: false,
                confirmButtonText: "Reset Password",
                inputPlaceholder: "Email"
            },
            function (inputValue) {
                if (inputValue === false) return false;

                if (inputValue === "") {
                    swal.showInputError("You need to write something!");
                    return false;
                }

                //Disable submit button to prevent multiple submissions
                $(".confirm").attr('disabled', 'disabled');
                <c:url value="/reset-password" var="url" />
                //Create an inline form and submit it to redirect with POST
                $("<form action='${url}' method='POST'><input type='hidden' name='email' value='" + inputValue + "' /></form>").submit();
            });
    });
</script>
</body>
</html>