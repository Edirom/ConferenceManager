xquery version "3.0";

module namespace app="http://exist-db.org/xquery/app";

import module namespace templates="http://exist-db.org/xquery/templates" at "templates.xql";
import module namespace login="http://exist-db.org/xquery/app/wiki/session" at "login.xqm";

(:~
 : Generates the login section
 : 
 : @param $node the HTML node with the class attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:get-login($node as node(), $model as map(*)) {
    <form class="form-signin" id="login-form">
        <h2 class="form-signin-heading">Login</h2>
        <input name="user" type="text" class="input-block-level" placeholder="Username"/>
        <input name="password" type="password" class="input-block-level" placeholder="Password"/>
        <label class="checkbox">
          <input type="checkbox" value="remember-me"/> Remember me
        </label>
        <button class="btn btn-primary" type="submit">Login</button>
        <p>{login:set-user("de.edirom.confManager", (), true())[@name="de.edirom.confManager.user"]/@value/string()}</p>
    </form>
};

(:~
 : Generates the intro text
 : 
 : @param $node the HTML node with the class attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:get-intro($node as node(), $model as map(*)) {
    <p class="lead">Willkommen. Entweder einloggen oder <a href="#">registrieren</a>.</p>
};
