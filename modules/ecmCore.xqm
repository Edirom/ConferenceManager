xquery version "3.0";

module namespace ecmCore="http://edirom.de/ecm/xquery/core";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";

declare function ecmCore:get-conference-name() as xs:string {
    'sampleConference'
};

declare function ecmCore:get-data-dir() as xs:string {
    $config:app-root || '/data'
};

declare function ecmCore:current-fe-user() as xs:string? {
    'sampleUser'
    (:():)
};

declare function ecmCore:get-user-dir($conference as xs:string) as xs:string? {
    let $userDirName := 'people'
    let $targetDir := string-join((ecmCore:get-data-dir(), $conference, $userDirName), '/')
    return 
        if(xmldb:collection-available($targetDir)) then $targetDir
        else if(xmldb:collection-available(substring-before($targetDir, $userDirName))) then (
            let $createNewDir := xmldb:create-collection(substring-before($targetDir, $userDirName), $userDirName)
            return $targetDir
        )
        else ()
};

declare function ecmCore:get-users($conference as xs:string) as element(tei:person)* {
    collection(ecmCore:get-user-dir($conference))//tei:person
};

declare function ecmCore:get-default-i18n-language() as xs:string {
    'en'
};

declare function ecmCore:get-default-i18n-catalogue-dir() as xs:string {
    $config:app-root || '/lib/i18n'
};