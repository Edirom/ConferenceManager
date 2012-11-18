xquery version "3.0";

module namespace app="http://exist-db.org/xquery/app";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace templates="http://exist-db.org/xquery/templates" at "templates.xql";
import module namespace login="http://exist-db.org/xquery/app/wiki/session" at "login.xqm";
import module namespace ecmAccount="http://edirom.de/ecm/xquery/account" at "ecmAccount.xqm";
import module namespace ecmCore="http://edirom.de/ecm/xquery/core" at "ecmCore.xqm";
import module namespace i18n="http://exist-db.org/xquery/i18n" at "i18n.xql";

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
    i18n:process(<p class="intl:translate"><i18n:text key="RememberMe">Translate simple text</i18n:text></p>)
};

declare function app:get-user-shortcuts() as element(div) {
    <div>
        <h3>Angemeldet als {ecmCore:current-fe-user()}</h3>
        <ul>
            <li><a href="account.html">Meine Daten</a></li>
            <!--<li><a href="changePassword.html">Passwort ändern</a></li>-->
        </ul>
    </div>
};

declare function app:get-account-data($node as node(), $model as map(*)) {
    let $userData := ecmAccount:get-data(ecmCore:current-fe-user(), ecmCore:get-conference-name())
    let $newUserFieldset := 
        <fieldset>
            <legend><i18n:text key="LoginDetails">Login Details</i18n:text></legend>
            <label class="inputLabel" for="loginName"><i18n:text key="LoginName">Login Name</i18n:text>:</label>
            <input type="text" name="loginName" size="41" maxlength="96" id="loginName" placeholder="i18n(ChooseLoginName)"/>
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="email"><i18n:text key="EmailAddress">Email Address</i18n:text>:</label>
            <input type="text" name="email" size="41" maxlength="96" id="email" placeholder="i18n(EmailAddress)"/>
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="password-new"><i18n:text key="Password">Password</i18n:text>:</label>
            <input type="password" name="password" size="21" maxlength="40" id="password-new" placeholder="******"/>
            <span class="alert">* (<i18n:translate><i18n:text key="atLeastXCharacters">at least {{1}} characters</i18n:text><i18n:param>6</i18n:param></i18n:translate>)</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="password-confirm"><i18n:text key="ConfirmPassword">Confirm Password</i18n:text>:</label>
            <input type="password" name="confirmation" size="21" maxlength="40" id="password-confirm" placeholder="******"/>
            <span class="alert">*</span>
            <br class="clearBoth"/>
        </fieldset>
    let $standardFieldset :=
        <fieldset>
            <legend><i18n:text key="BillingAddress">Billing Address</i18n:text></legend>
            <label class="inputLabel" for="firstName"><i18n:text key="FirstName">First Name</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'firstName'},
                attribute size {'33'},
                attribute maxlength {'32'},
                attribute id {'firstName'},
                if(exists($userData)) then attribute value {$userData//tei:forename} else attribute placeholder {'i18n(FirstName)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="lastName"><i18n:text key="LastName">Last Name</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'lastName'},
                attribute size {'33'},
                attribute maxlength {'32'},
                attribute id {'lastName'},
                if(exists($userData)) then attribute value {$userData//tei:surname} else attribute placeholder {'i18n(LastName)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="institution"><i18n:text key="Institution">Institution</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'institution'},
                attribute size {'41'},
                attribute maxlength {'64'},
                attribute id {'institution'},
                if(exists($userData)) then attribute value {$userData//tei:orgName} else attribute placeholder {'i18n(Institution)'}
                }
            }
            <br class="clearBoth"/>
            <label class="inputLabel" for="addressLine1"><i18n:text key="AddressLine1">Street Address</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'addressLine1'},
                attribute size {'41'},
                attribute maxlength {'64'},
                attribute id {'addressLine1'},
                if(exists($userData)) then attribute value {$userData//tei:addrLine[1]} else attribute placeholder {'i18n(AddressLine1)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="addressLine2"><i18n:text key="AddressLine2">Address Line 2</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'addressLine2'},
                attribute size {'41'},
                attribute maxlength {'64'},
                attribute id {'addressLine2'},
                if(exists($userData)) then attribute value {$userData//tei:addrLine[2]} else attribute placeholder {'i18n(AddressLine2)'}
                }
            }
            <br class="clearBoth"/>
            <label class="inputLabel" for="city"><i18n:text key="City">City</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'city'},
                attribute size {'33'},
                attribute maxlength {'32'},
                attribute id {'city'},
                if(exists($userData)) then attribute value {$userData//tei:settlement} else attribute placeholder {'i18n(City)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
            <label class="inputLabel" for="postcode"><i18n:text key="PostCode">Post/Zip Code</i18n:text>:</label>
            {element input {
                attribute type {'text'},
                attribute name {'postcode'},
                attribute size {'11'},
                attribute maxlength {'10'},
                attribute id {'postcode'},
                if(exists($userData)) then attribute value {$userData//tei:postCode} else attribute placeholder {'i18n(PostCode)'}
                }
            }
            <span class="alert">*</span>
            <br class="clearBoth"/>
        </fieldset>
    
    return  
        i18n:process(
            <form name="manageAccount" method="post" action="account.html" class="intl:translate">{
                if(exists($userData)) then ()  
                else $newUserFieldset,
                $standardFieldset
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
                    attribute href {if($loggedIn) then 'account.html' else 'registration.html'},
                    if($loggedIn) then 'My Account' else 'Registration'
                }
            }
        }</ul>
};