xquery version "3.0";

import module namespace login="http://exist-db.org/xquery/app/wiki/session" at "login.xqm";

declare namespace json="http://www.json.org";

declare option exist:serialize "method=json media-type=text/javascript";

let $loggedIn := login:set-user("de.edirom.confManager", (), false())
return
    if (exists($loggedIn)) then (
        let $user := $loggedIn[@name="de.edirom.confManager.user"]/@value/string()
        let $user-groups := xmldb:get-user-groups($user)
        return
        <ok>
            <user>{$user}</user>
            {
                for $grp in $user-groups
                return
                    <group>{$grp}</group>
            }
        </ok>
    )else (
        response:set-status-code(401),
        <fail/>
    )
    