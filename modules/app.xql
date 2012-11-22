xquery version "3.0";

module namespace app="http://exist-db.org/xquery/app";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace templates="http://exist-db.org/xquery/templates" at "templates.xql";
import module namespace login="http://exist-db.org/xquery/app/wiki/session" at "login.xqm";
import module namespace ecmAccount="http://edirom.de/ecm/xquery/account" at "ecmAccount.xqm";
import module namespace ecmCore="http://edirom.de/ecm/xquery/core" at "ecmCore.xqm";
import module namespace i18n="http://exist-db.org/xquery/i18n" at "i18n.xql";
import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";

declare function app:get-right-sidebar($node as node(), $model as map(*)) {
    if(exists(ecmCore:current-fe-user())) then app:get-user-shortcuts()
    else app:get-login()
};

(:~
 : Generates the login section
 : 
 : @param $node the HTML node with the class attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:get-login() as element(form) {
    <form class="form-signin" id="login-form">
        <h2 class="form-signin-heading">Login</h2>
        <input name="user" type="text" class="input-block-level" placeholder="Username"/>
        <input name="password" type="password" class="input-block-level" placeholder="Password"/>
        <label class="checkbox">
          <input type="checkbox" value="remember-me"/> Remember me
        </label>
        <button class="btn btn-primary" type="submit">Login</button>
    </form>
};

(:~
 : Generates the intro text
 : 
 : @param $node the HTML node with the class attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:get-intro($node as node(), $model as map(*)) {
    <p class="lead">Willkommen beim Edirom Conference Mangager.</p>,
    <p>App root: {$config:app-root}</p>,
    i18n:process(<p class="intl:translate"><i18n:text key="RememberMe">Translate simple text</i18n:text></p>)
};

declare function app:get-user-shortcuts() as element(div) {
    <div>
        <h3>Angemeldet als {ecmCore:current-fe-user()}</h3>
        <ul>
            <li><a href="account.html">Meine Daten</a></li>
            <li><a href="?changePassword">Passwort ändern</a></li>
            <!--<li><a href="changePassword.html">Logout</a></li>-->
        </ul>
    </div>
};

declare function app:get-account-data($node as node(), $model as map(*)) {
    let $setHeader := response:set-header('cache-control','no-cache')
    let $saveUserData := if(request:get-parameter-names() = 'save') then ecmAccount:set-user-data((ecmAccount:createTEIPersonFromHttpRequest(ecmCore:current-fe-user())), ecmCore:get-conference-name()) else ()
    let $userData := ecmAccount:get-data(ecmCore:current-fe-user(), ecmCore:get-conference-name())
    
    let $passwordFieldset := 
        <fieldset>
            <legend><i18n:text key="changePassword">Change Password</i18n:text></legend>
            <label class="inputLabel" for="oldPassword"><i18n:text key="oldPassword">Old Password</i18n:text>:</label>
            <input type="password" name="password" size="21" maxlength="40" id="oldPassword" placeholder="******"/>
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="newPassword"><i18n:text key="newPassword">New Password</i18n:text>:</label>
            <input type="password" name="password" size="21" maxlength="40" id="newPassword" placeholder="******"/>
            <span class="alert">* (<i18n:translate><i18n:text key="atLeastXCharacters">at least {{1}} characters</i18n:text><i18n:param>6</i18n:param></i18n:translate>)</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="confirmNewPassword"><i18n:text key="confirmNewPassword">Confirm New Password</i18n:text>:</label>
            <input type="password" name="confirmNewPassword" size="21" maxlength="40" id="confirmNewPassword" placeholder="******"/>
            <span class="alert">*</span>
            <br class="clearBoth"/>
        </fieldset>
    let $newUserFieldset := 
        <fieldset>
            <legend><i18n:text key="loginDetails">Login Details</i18n:text></legend>
            <label class="inputLabel" for="loginName"><i18n:text key="loginName">Login Name</i18n:text>:</label>
            <input type="text" name="loginName" size="41" maxlength="96" id="loginName" placeholder="i18n(chooseLoginName)"/>
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="password"><i18n:text key="Password">Password</i18n:text>:</label>
            <input type="password" name="password" size="21" maxlength="40" id="password" placeholder="******"/>
            <span class="alert">* (<i18n:translate><i18n:text key="atLeastXCharacters">at least {{1}} characters</i18n:text><i18n:param>6</i18n:param></i18n:translate>)</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="confirmPassword"><i18n:text key="confirmPassword">Confirm Password</i18n:text>:</label>
            <input type="password" name="confirmPassword" size="21" maxlength="40" id="confirmPassword" placeholder="******"/>
            <span class="alert">*</span>
            <br class="clearBoth"/>
        </fieldset>
    let $emailFieldset := 
        <fieldset>
            <legend><i18n:text key="email">Email</i18n:text></legend>
            <label class="inputLabel" for="email"><i18n:text key="email">Email Address</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'email'},
                attribute size {'41'},
                attribute maxlength {'96'},
                attribute id {'email'},
                if(exists($userData)) then attribute value {$userData//tei:email} else attribute placeholder {'i18n(email)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="confirmEmail"><i18n:text key="confirmEmail">Confirm Email Address</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'confirmEmail'},
                attribute size {'41'},
                attribute maxlength {'96'},
                attribute id {'confirmEmail'},
                if(exists($userData)) then attribute value {$userData//tei:email} else attribute placeholder {'i18n(confirmEmail)'}
                }
            }
            <span class="alert">*</span>
        </fieldset>
    let $standardFieldset :=
        <fieldset>
            <legend><i18n:text key="billingAddress">Billing Address</i18n:text></legend>
            <label class="inputLabel" for="forename"><i18n:text key="forename">First Name</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'forename'},
                attribute size {'33'},
                attribute maxlength {'32'},
                attribute id {'forename'},
                if(exists($userData)) then attribute value {$userData//tei:forename} else attribute placeholder {'i18n(forename)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="surname"><i18n:text key="surname">Last Name</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'surname'},
                attribute size {'33'},
                attribute maxlength {'32'},
                attribute id {'surname'},
                if(exists($userData)) then attribute value {$userData//tei:surname} else attribute placeholder {'i18n(surname)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="orgName"><i18n:text key="orgName">Institution</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'orgName'},
                attribute size {'41'},
                attribute maxlength {'64'},
                attribute id {'orgName'},
                if(exists($userData)) then attribute value {$userData//tei:orgName} else attribute placeholder {'i18n(orgName)'}
                }
            }
            <br class="clearBoth"/>
            <label class="inputLabel" for="addrLine1"><i18n:text key="addrLine1">Street Address</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'addrLine1'},
                attribute size {'41'},
                attribute maxlength {'64'},
                attribute id {'addrLine1'},
                if(exists($userData)) then attribute value {$userData//tei:addrLine[1]} else attribute placeholder {'i18n(addrLine1)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="addrLine2"><i18n:text key="addrLine2">Address Line 2</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'addrLine2'},
                attribute size {'41'},
                attribute maxlength {'64'},
                attribute id {'addrLine2'},
                if(exists($userData)) then attribute value {$userData//tei:addrLine[2]} else attribute placeholder {'i18n(addrLine2)'}
                }
            }
            <br class="clearBoth"/>
            <label class="inputLabel" for="settlement"><i18n:text key="settlement">City</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'settlement'},
                attribute size {'33'},
                attribute maxlength {'32'},
                attribute id {'settlement'},
                if(exists($userData)) then attribute value {$userData//tei:settlement} else attribute placeholder {'i18n(settlement)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="postCode"><i18n:text key="postCode">Post/Zip Code</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'postCode'},
                attribute size {'11'},
                attribute maxlength {'10'},
                attribute id {'postCode'},
                if(exists($userData)) then attribute value {$userData//tei:postCode} else attribute placeholder {'i18n(postCode)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="country"><i18n:text key="country">Country</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'country'},
                attribute size {'33'},
                attribute maxlength {'32'},
                attribute id {'country'},
                if(exists($userData)) then attribute value {$userData//tei:country} else attribute placeholder {'i18n(country)'}
                }
            }
            <span class="alert">*</span>
        </fieldset>
    
    return  
        i18n:process(
            <form name="manageAccount" method="post" action="account.html?save" class="intl:translate">{
                if(exists($userData)) then ()  
                else $newUserFieldset,
                if(request:get-parameter-names() = 'changePassword') then $passwordFieldset
                else ($emailFieldset, $standardFieldset)
                }
                <button class="btn btn-primary" type="submit"><i18n:text key="Save">Save</i18n:text></button>
            </form>
        )
};

declare function app:get-top-nav($node as node(), $model as map(*)) as element(ul) {
    let $loggedIn := exists(ecmCore:current-fe-user())
    return 
        <ul class="nav">{
            element li {
                element a {
                    attribute href {'index.html'},
                    'Home'
                }
            },
            element li {
                element a {
                    attribute href {if($loggedIn) then 'account.html' else 'account.html'},
                    if($loggedIn) then 'My Account' else 'Registration'
                }
            }
        }</ul>
};