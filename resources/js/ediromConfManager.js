$(document).ready(function() {
    
    console.log($("#login-form"));
    $("#login-form").on("submit", function(e) {
        e.preventDefault();
        console.log('TEST');
        
        /*
        //login = query("input[name='user']", form).val();
        //dom.byId("login-message").innerHTML = "Contacting server...";
        dojo.xhrPost({
            url: "login",
            form: form,
            handleAs: "json",
            load: function(data) {
                /*domConstruct.empty("login-message");
                hideStatus();
                registry.byId("user").set("label", login);
                registry.byId("user").closeDropDown(false);
                domStyle.set("login-dialog-form", "display", "none");
                domStyle.set("login-dialog-logout", "display", "block");
                if(callbackFunction){
                    callbackFunction();
                    callbackFunction = undefined;
                }* /
                console.log('login');
                
            },
            error: function(error) {
                /*dom.byId("login-message").innerHTML = "Login failed.";
                registry.byId("user").set("label", "Not logged in");
                login = null;* /
                console.log('fail');
            }
        });
        */
        });
});