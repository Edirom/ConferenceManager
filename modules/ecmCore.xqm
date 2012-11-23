xquery version "3.0";

module namespace ecmCore="http://edirom.de/ecm/xquery/core";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace config="http://exist-db.org/xquery/apps/config" at "config.xqm";

(:
 :  Function for retrieving the current conference id
 :  Status: STUB
 :
 :  @return The id of the conference, empty sequence otherwise
 :)
declare function ecmCore:get-conference-id() as xs:string? {
    'sampleConference'
};

(:
 :  Function for retrieving the path to the data collection of the webapp
 :  Status: STUB
 :
 :  @return The path to the data collection as xs:string, empty sequence otherwise
 :)
declare function ecmCore:get-data-dir() as xs:string? {
    $config:app-root || '/data'
};

(:
 :  Function for retrieving the current front end user id
 :  Status: STUB
 :
 :  @return The front end user id as xs:string, empty sequence otherwise
 :)
declare function ecmCore:current-fe-user() as xs:string? {
    'sampleUser'
    (:():)
};

(:
 :  Function for retrieving the (complete) database collection path for user data.
 :  This function will also try to create this collection if it does not exist.
 :
 :  @param $conference The unique id of the conference
 :  @return The path to the user data collection, empty sequence otherwise
 :)
declare function ecmCore:get-user-dir($conference as xs:string) as xs:string? {
    let $userDirName := 'people'
    let $targetDir := string-join((ecmCore:get-data-dir(), $conference, $userDirName), '/')
    return 
        if(xmldb:collection-available($targetDir)) then $targetDir
        else if(xmldb:collection-available(substring-before($targetDir, $userDirName))) then (
            try {xmldb:create-collection(substring-before($targetDir, $userDirName), $userDirName)}
            catch * {ecmCore:log('error', 'collection ' || $userDirName || ' could not be created; ' || $err:decription)}
        )
        else ()
};

(:
 :  Function for retrieving all users (and data) for a given conference
 :
 :  @param $conference The unique id of the conference 
 :  @return tei:person nodes, valid against the RNG schema at "$app-root$/resources/rng/people.rng"
 :)
declare function ecmCore:get-users($conference as xs:string) as element(tei:person)* {
    collection(ecmCore:get-user-dir($conference))//tei:person
};

(:
 :  Function for retrieving the default application language. 
 :  Status: STUB
 :
 :  @return A language code, according to the representation of names of languages standard ISO 639 
 :)
declare function ecmCore:get-default-i18n-language() as xs:string {
    'en'
};

(:
 :  Function for retrieving the (complete) database collection path for the language catalogue files 
 :  Status: STUB
 :
 :  @return path to catalogue files, defaults to "$app-root$/lib/i18n"
 :)
declare function ecmCore:get-default-i18n-catalogue-dir() as xs:string {
    $config:app-root || '/lib/i18n'
};

(:
 :  Function for retrieving the date and time of the last login of a front end user
 :  Status: STUB
 :
 :  @param $user username
 :  @return xs:dateTime of last login, empty sequence otherwise
 :)
declare function ecmCore:fe-user-last-login($user as xs:string) as xs:dateTime? {
    current-dateTime()
};

(:
 :  Function for retrieving the date and time of registration of a front end user
 :  Status: STUB
 :
 :  @param $user username
 :  @return xs:dateTime of registration, empty sequence otherwise
 :)
declare function ecmCore:fe-user-registered($user as xs:string) as xs:dateTime? {
    current-dateTime()
};

(:
 :  Function for writing Edirom Conference Manager log messages to file
 :  Status: STUB
 :
 :  @param $priority The logging priority: 'error', 'warn', 'debug', 'info', 'trace'
 :  @param $message The message to log
 :  @return The empty sequence
 :)
declare function ecmCore:log($priority as xs:string, $message as xs:string) as empty() {
    let $file := 'ecm.webapp'
    return util:log-app($priority, $file, $message)
};