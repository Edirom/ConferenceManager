xquery version "3.0";

module namespace ecmAccount="http://edirom.de/ecm/xquery/account";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace ecmCore="http://edirom.de/ecm/xquery/core" at "ecmCore.xqm";

declare function ecmAccount:get-data($user as xs:string?, $conference as xs:string?) as element(tei:person)? {
    if(exists($user) and exists($conference)) then ecmCore:get-users($conference)//tei:idno[.=$user][@type="ecm"]/parent::tei:person
    else ()
};

declare function ecmAccount:set-user-data($node as element(tei:person), $conference as xs:string) as xs:string? {
    try {
        xmldb:store(ecmCore:get-user-dir($conference), xmldb:get-current-user(), $node)
    }
    catch * {
        ()
    }
};

declare function ecmAccount:create-user($userName as xs:string, $password as xs:string, $data as element(tei:person)) as xs:boolean {
    false()
};