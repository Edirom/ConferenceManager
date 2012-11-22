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
        xmldb:store(ecmCore:get-user-dir($conference), $node/tei:idno/text() || '.xml', $node)
    }
    catch * {
        ()
    }
};

declare function ecmAccount:create-user($userName as xs:string, $password as xs:string, $data as element(tei:person)) as xs:boolean {
    false()
};

declare function ecmAccount:createTEIPersonFromHttpRequest($userName as xs:string) as element(tei:person) {
    <person xmlns="http://www.tei-c.org/ns/1.0">
        <idno type="ecm">{$userName}</idno>
        <persName>
            <surname>{request:get-parameter('surname', '')}</surname>
            <forename>{request:get-parameter('forename', '')}</forename>
        </persName>
        <sex>{request:get-parameter('sex', '')}</sex>
        <affiliation>
            <orgName>{request:get-parameter('orgName', '')}</orgName>
            <address>
                <addrLine>{request:get-parameter('addrLine1', '')}</addrLine>
                <addrLine>{request:get-parameter('addrLine2', '')}</addrLine>
                <postCode>{request:get-parameter('postCode', '')}</postCode>
                <settlement>{request:get-parameter('settlement', '')}</settlement>
                <country>{request:get-parameter('country', '')}</country>
            </address>
            <email>{request:get-parameter('email', '')}</email>
        </affiliation>
    </person>
};